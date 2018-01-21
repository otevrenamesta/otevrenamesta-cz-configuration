{
  network.description = "otevrenamesta-cz infrastructure";

  ckan =
    { config, lib, pkgs, ...}:
    {
      #deployment.targetHost = "172.17.0.0";
    };
  redmine =
    { config, lib, pkgs, ...}:
    {
      #deployment.targetHost = "172.17.0.0";
    };
  hydra =
    { config, lib, pkgs, ... }:
    {
      #deployment.targetHost = "172.17.0.0";
    };
  hydra_slave =
    { config, lib, pkgs, ... }:
    {
      #deployment.targetHost = "172.17.0.0";
    };
}
