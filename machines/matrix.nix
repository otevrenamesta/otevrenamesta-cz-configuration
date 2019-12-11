{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
  ];

  networking = {
     domain = "otevrenamesta.cz";
     hostName =  "matrix";
  };

  users.extraUsers.root.openssh.authorizedKeys.keys =
    with import ../ssh-keys.nix; [ rh ];
}
