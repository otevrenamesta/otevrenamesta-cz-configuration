{
  network.description = "Brno production infrastructure";

  kmd =
    { config, lib, pkgs, ...}:
    {
      deployment.targetHost = "10.21.162.10";

      imports = [
        ./brno.nix
      ];

      boot.loader.grub.device = "/dev/sda";

      networking = {
        hostName = "kmd";
        defaultGateway = "10.21.162.1";
        nameservers = [ "10.0.99.8" "10.0.99.24" ];
        interfaces.ens32 = {
          ipAddress = "10.21.162.10";
          prefixLength = 24;
        };
      };

      fileSystems."/" =
        { device = "/dev/disk/by-uuid/75502abb-8b5d-4e62-b1c1-8c3ed00317f6";
          fsType = "ext4";
        };
    };

  kod =
    { config, lib, pkgs, ...}:
    {
      deployment.targetHost = "10.10.11.10";

      imports = [
        ./brno.nix
      ];

      boot.loader.grub.device = "/dev/sda";

      networking = {
        hostName = "kod";
        defaultGateway = "10.10.11.1";
        nameservers = [ "10.0.99.8" "10.0.99.24" ];
        interfaces.ens32 = {
          ipAddress = "10.10.11.10";
          prefixLength = 24;
        };
     };

      fileSystems."/" =
        { device = "/dev/disk/by-uuid/abb1e733-15fd-4228-9eae-51800b209a2c";
          fsType = "ext4";
        };
    };

  #lpetl =
  #  { config, lib, pkgs, ...}:
  #  {
  #    deployment.targetHost = "172.17.4.141";

  #    boot.loader.grub.device = "/dev/sda";

  #    fileSystems."/" =
  #      { device = "/dev/disk/by-uuid/d0b28917-8c38-4870-b085-5091cbf39f4a";
  #        fsType = "ext4";
  #      };

  #    fileSystems."/boot" =
  #      { device = "/dev/disk/by-uuid/e9207110-4211-4993-b430-85c5930e567c";
  #        fsType = "ext4";
  #    };
  #  };
}
