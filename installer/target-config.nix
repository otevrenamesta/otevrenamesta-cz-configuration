{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./generated.nix
  ];
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  services.openssh.enable = true;

  users.extraUsers.root.openssh.authorizedKeys.keys =
    with import ./ssh-keys.nix; [ ln srk mm ];
}
