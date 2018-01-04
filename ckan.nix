{ config, pkgs, lib, ...}:
{
  # XXX split to postgresql.nix
  boot.kernel.sysctl."kernel.shmmax" = 8589934592; # 8GB

  services.postgresql = {
    enable = true;
    # shared_buffers to 25% of the memory in your system.
    extraConfig = ''
      listen_addresses = '0.0.0.0'
      shared_buffers = 8GB
      temp_buffers = 8MB
      work_mem = 16MB
      max_connections = 250
      max_stack_depth = 2MB
    '';
    package = pkgs.postgresql96;
    authentication = lib.mkForce ''
      # Generated file; do not edit!
      # TYPE  DATABASE        USER            ADDRESS                 METHOD
      local   all             all                                     trust
      host    all             all             127.0.0.1/32            trust
      host    all             all             ::1/128                 trust
      host    all             all             172.19.9.19/32          trust
    '';
  };

  services.redis.enable = true;

  services.solr.enable = true;
  services.solr.user = "ckan";
  services.solr.group = "ckan";
  services.solr.solrHome = "/srv/ckan/solr";

  users.extraUsers.ckan = {
    uid = 6666;
  };
  users.extraGroups.ckan = {
    gid = 6666;
  };
  users.extraUsers.ckan.extraGroups = [ "ckan" ];
}
