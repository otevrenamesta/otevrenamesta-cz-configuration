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
  "libvirt" = { config, pkgs, ... }: with pkgs; {
     imports = [
       ./env.nix
       ./ct.nix
       ./machines/libvirt.nix
     ];

     deployment = {
       targetHost = "37.205.14.17";
     };
  };

  # virt-guest -p 10222 (midpoint)
  "virt-guest" = { config, pkgs, ... }: with pkgs; {
     imports = [
       ./env.nix
       <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
     ];
     boot.loader.grub.enable = true;
     boot.loader.grub.version = 2;
     boot.loader.grub.device = "/dev/sda";

     boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "ehci_pci" "sd_mod" "sr_mod" ];
     boot.kernelModules = [ ];
     boot.extraModulePackages = [ ];

     fileSystems."/" =
       { device = "/dev/disk/by-uuid/86171d08-b62d-4c99-b1d6-ea075e8183d0";
         fsType = "ext4";
       };

     fileSystems."/boot" =
       { device = "/dev/disk/by-uuid/a821424a-1ffd-4c08-acf9-74078ee1eeff";
         fsType = "ext4";
       };

     swapDevices = [ ];

     nix.maxJobs = lib.mkDefault 2;

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
