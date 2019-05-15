let
  sysPkgs = import <nixpkgs> {};

  # Pin the deployment package-set to a specific version of nixpkgs
  newPkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs-channels/archive/180aa21259b666c6b7850aee00c5871c89c0d939.tar.gz";
    sha256 = "0gxd10djy6khbjb012s9fl3lpjzqaknfv2g4dpfjxwwj9cbkj04h";
  }) {};
in
{
  network =  {
    pkgs = newPkgs;
    description = "om hosts";
  };

  # uses network.pkgs
  mesta-libvirt = { config, pkgs, ... }: with pkgs; {
    imports = [
      ./env.nix
      ./ct.nix
      ./machines/mesta-libvirt.nix
    ];
  };

  # qemu guest port 10022 (mail)
  mail = { config, pkgs, ... }: with pkgs; {
    imports = [
      ./env.nix
      ./qemu.nix
      ./machines/mail.nix
    ];

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/50884094-57df-49fe-984a-5e25c1f629ac";
        fsType = "ext4";
      };

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/c4cb4b0c-2009-4c22-8ab4-9c9cfc061b59";
        fsType = "ext4";
      };
  };

  # qemu guest port 10122 (sympa)
  sympa = { config, pkgs, ... }: with pkgs; {
    imports = [
      ./env.nix
      ./qemu.nix
    ];

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/3558270a-9c25-492b-bf4b-dcd2db2c5cfa";
        fsType = "ext4";
      };

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/d4eb070a-10ee-42f3-bd59-69d7d891965a";
        fsType = "ext4";
      };
  };

  # qemu guest port 10222 (midpoint)
  midpoint = { config, pkgs, ... }: with pkgs; {
    imports = [
      ./env.nix
      ./qemu.nix
    ];

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/86171d08-b62d-4c99-b1d6-ea075e8183d0";
         fsType = "ext4";
      };

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/a821424a-1ffd-4c08-acf9-74078ee1eeff";
        fsType = "ext4";
      };

    deployment = {
      healthChecks = {
        /*
        cmd = [{
          cmd = ["true" "one argument" "another argument"];
          description = "Testing that 'true' works.";
        }];
        http = [
          {
            scheme = "http";
            port = 80;
            path = "/";
            description = "Check whether nginx is running.";
            period = 1; # number of seconds between retries
          }
        ];
        */
      };
    };
  };
}
