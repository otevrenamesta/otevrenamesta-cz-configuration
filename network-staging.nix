{
  network.description = "Staging infrastructure";

  ckan =
    { config, lib, pkgs, ...}:
    {
      deployment.targetHost = "172.17.4.140";

      imports = [
        #./brno.nix
      ];

      services.ckan.ckanURL = "http://lada-ckan";

      boot.loader.grub.device = "/dev/sda";

      fileSystems."/" =
        { device = "/dev/disk/by-uuid/2133ba67-f556-4b46-883c-2cd48a969b9d";
          fsType = "ext4";
        };

      fileSystems."/boot" =
        { device = "/dev/disk/by-uuid/8d46138d-d360-4382-90a5-c96ac05a6ccb";
          fsType = "ext4";
        };
    };
  ckan-pub =
    { config, lib, pkgs, ...}:
    {
      deployment.targetHost = "172.17.4.142";

      imports = [
        #./brno.nix
      ];

      services.ckan.ckanURL = "http://lada-ckan-pub";

      boot.loader.grub.device = "/dev/sda";

      fileSystems."/" =
        { device = "/dev/disk/by-uuid/2133ba67-f556-4b46-883c-2cd48a969b9d";
          fsType = "ext4";
        };

      fileSystems."/boot" =
        { device = "/dev/disk/by-uuid/8d46138d-d360-4382-90a5-c96ac05a6ccb";
          fsType = "ext4";
      };
    };
  lpetl =
    { config, lib, pkgs, ...}:
    {
      deployment.targetHost = "172.17.4.141";

      boot.loader.grub.device = "/dev/sda";

      fileSystems."/" =
        { device = "/dev/disk/by-uuid/3096dc2b-1f6a-4986-a959-dba3e993bf01";
          fsType = "ext4";
        };
    };
}
