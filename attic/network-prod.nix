{
  network.description = "otevrenamesta-cz infrastructure";

  ckan =
    { config, lib, pkgs, ...}:
    {
      #deployment.targetHost = "172.17.0.0";
    };
  ckan-pub =
    { config, lib, pkgs, ...}:
    {
      #deployment.targetHost = "172.17.0.0";
    };
  redmine =
    { config, lib, pkgs, ...}:
    {
      #deployment.targetHost = "172.17.0.0";
    };
}
