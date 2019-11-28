{ config, ... }:
{
  # XXX: create a module from this
  boot.kernel.sysctl."kernel.shmmax" = 8589934592; # 8GB

  services.postgresql = {
    # shared_buffers to 25% of the memory in your system.
    extraConfig = ''
      #listen_addresses = '0.0.0.0'
      shared_buffers = 8GB
      temp_buffers = 8MB
      work_mem = 16MB
      max_connections = 250
      max_stack_depth = 2MB
    '';
    package = pkgs.postgresql96;
  }; 
}
