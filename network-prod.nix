{
  network.description = "otevrenamesta-cz infrastructure";

  netboot =
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
