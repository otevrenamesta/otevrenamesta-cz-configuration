{ config, pkgs, lib, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "ehci_pci" "sd_mod" "sr_mod" ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 2;
}
