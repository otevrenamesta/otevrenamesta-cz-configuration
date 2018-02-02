{
  network.description = "Brno production infrastructure";

  ckan =
    { config, lib, pkgs, ...}:
    {
      deployment.targetHost = "172.17.4.140";

      imports = [
        ./brno.nix
      ];

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
        ./brno.nix
      ];

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
        { device = "/dev/disk/by-uuid/d0b28917-8c38-4870-b085-5091cbf39f4a";
          fsType = "ext4";
        };
    
      fileSystems."/boot" =
        { device = "/dev/disk/by-uuid/e9207110-4211-4993-b430-85c5930e567c";
          fsType = "ext4";
      };
    };
}
