{ config, pkgs, ... }:

{
  users.users.niap = {
    description = "NIA proxy user (no shell, port forwarding only)";
    shell = "${pkgs.shadow}/bin/nologin";
    openssh.authorizedKeys.keys = with import ../ssh-keys.nix; [ ms ln mm ];
  };
}
