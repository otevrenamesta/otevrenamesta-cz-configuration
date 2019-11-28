{
  network.description = "otevrenamesta-cz small infrastructure";

  kmd =
    { config, lib, pkgs, ...}:
    {
      imports = [
        ./env.nix
        ./ckan.nix
      ];
    };

  kod =
    { config, lib, pkgs, ...}:
    {
      imports = [
        ./env.nix
        ./ckan-pub.nix
      ];
    };
}
