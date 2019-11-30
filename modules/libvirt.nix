{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.virtualisation.libvirtd.networking;
  v6enabled = cfg.ipv6.network != "";
in
{
  options = {
    virtualisation.libvirtd.networking = {
      enable = mkEnableOption "Enable nix-managed networking for libvirt";

      bridgeName = mkOption {
        type = types.str;
        default = "br0";
        description = "Name of the bridged interface for use by libvirt guests";
      };

      infiniteLeaseTime = mkOption {
        type = types.bool;
        default = false;
        description = "Use infinite lease time for DHCP used by guests";
      };

      ipv6 = {
        network = mkOption {
          type = types.str;
          default = "";
        };

        #defaultGateway - IIRC SLAAC just sends our link-local address

        nameServers = mkOption {
          type = types.listOf types.str;
          default = [ "2001:4860:4860::8888" "2001:4860:4860::8844" ]; # google dns
        };
      };
    };
  };

  config = mkIf cfg.enable {
    warnings = [ "Make sure to enable KVM and TUN/TAP features" ];

    system.activationScripts.libvirtImages = ''
      mkdir -p /var/lib/libvirt/images
    '';

    networking.nat = {
       enable = true;
       internalInterfaces = [ cfg.bridgeName ];
       externalInterface = "venet0";
     };

     # libvirt uses 192.168.122.0
     networking.bridges."${cfg.bridgeName}".interfaces = [];
     networking.interfaces."${cfg.bridgeName}".ipv4.addresses = [
       { address = "192.168.122.1"; prefixLength = 24; }
     ];
     #TODO networking.interfaces."${cfg.bridgeName}".ipv6.addresses = [

     services.dhcpd4 = {
       enable = true;
       interfaces = [ cfg.bridgeName ];
       extraConfig = ''
         option routers 192.168.122.1;
         option broadcast-address 192.168.122.255;
         option subnet-mask 255.255.255.0;
         option domain-name-servers 37.205.9.100, 37.205.10.88, 1.1.1.1;
         ${optionalString cfg.infiniteLeaseTime  ''
         default-lease-time -1;
         max-lease-time -1;
         ''}
         subnet 192.168.122.0 netmask 255.255.255.0 {
           range 192.168.122.100 192.168.122.200;
         }
       '';
     };

     services.dhcpd6 = mkIf v6enabled {
       enable = true;
       interfaces = [ cfg.bridgeName ];
       extraConfig = ''
         ${optionalString cfg.ipv6.nameServers != [] ''
           option dhcp6.name-servers ${builtins.concatStringsSep ", " cfg.ipv6.nameServers};
         ''}

         ${optionalString cfg.infiniteLeaseTime  ''
         default-lease-time -1;
         max-lease-time -1;
         ''}
         subnet6 ${cfg.ipv6.network} {
         }
       '';
     };

     services.radvd = mkIf v6enabled {
       enable = true;
       config = ''
         interface ${cfg.bridgeName}
         {
           AdvSendAdvert on;
           AdvManagedFlag off; # on = get also address from dhcp
           AdvOtherConfigFlag off; # on = get dns from dhcp?

           prefix ${cfg.ipv6.network}
           {
             AdvOnLink on;
             AdvAutonomous on; # FIXME only advertise router, addresses
           };

           route ::/0 {};

           ${optionalString cfg.ipv6.nameServers != [] ''
             RDNSS ${builtins.concatStringsSep " " cfg.ipv6.nameServers} {};
           ''}
         };
     '';
  };
}
