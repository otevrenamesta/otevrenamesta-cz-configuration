# temporary module until staging matches virt
{
  network.description = "otevrenamesta-cz small staging infrastructure";

  ckan =
    { config, lib, pkgs, ...}:
    {
      imports = [
        ./env.nix
        ./ckan.nix
      ];
    };

  ckan-pub =
    { config, lib, pkgs, ...}:
    {
      imports = [
        ./env.nix
        ./ckan-pub.nix
      ];
    };
  lpetl =
    { config, lib, pkgs, ... }:
    {
      imports = [
        ./env.nix
        ./lpetl.nix
      ];
    };

}
