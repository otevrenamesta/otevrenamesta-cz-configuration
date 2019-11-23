{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.justdoit;
in {
  options = {
    justdoit = {
      rootDevice = mkOption {
        type = types.str;
        default = "/dev/sda";
        description = "the root block device that justdoit will nuke from orbit and force nixos onto";
      };
      bootSize = mkOption {
        type = types.int;
        default = 256;
        description = "size of /boot in mb";
      };
    };
  };
  config = {
    system.build.justdoit = pkgs.writeScriptBin "justdoit" ''
      #!${pkgs.stdenv.shell}

      set -e

      dd if=/dev/zero of=${cfg.rootDevice} bs=512 count=10000
      sfdisk ${cfg.rootDevice} <<EOF
      label: dos
      device: ${cfg.rootDevice}
      unit: sectors
      ${cfg.rootDevice}1 : size=${toString (2048 * cfg.bootSize)}, type=83
      ${cfg.rootDevice}2 : type=83
      EOF

      mkfs.ext4 ${cfg.rootDevice}1 -L NIXOS_BOOT
      mkfs.ext4 ${cfg.rootDevice}2 -L NIXOS_ROOT

      mount -t ext4 ${cfg.rootDevice}2 /mnt/
      mkdir -p /mnt/boot
      mount -t ext4 ${cfg.rootDevice}1 /mnt/boot/

      nixos-generate-config --root /mnt/

      cp ${./target-config.nix} /mnt/etc/nixos/configuration.nix
      cp ${../ssh-keys.nix} /mnt/etc/nixos/ssh-keys.nix

      cat > /mnt/etc/nixos/generated.nix <<EOF
      { ... }:
      {
        boot.loader.grub.device = "${cfg.rootDevice}";
      }
      EOF

      nixos-install
    '';
    environment.systemPackages = [ config.system.build.justdoit ];
  };
}

