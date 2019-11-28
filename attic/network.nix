{
  network.description = "otevrenamesta-cz infrastructure";

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

  redmine =
    { config, lib, pkgs, ...}:
    {
      imports = [
        ./env.nix
        #./redmine.nix
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
  proxy =
    { config, lib, pkgs, ... }:
    {
      imports = [
        ./env.nix
        ./proxy.nix
      ];
    };
  virtuoso =
    { config, lib, pkgs, ... }:
    {
      imports = [
        ./env.nix
        ./virtuoso.nix
      ];
    };
}
