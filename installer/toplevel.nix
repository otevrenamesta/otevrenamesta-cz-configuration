{ ... }:
{
  imports = [
    ./installer.nix
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
  ];
}
