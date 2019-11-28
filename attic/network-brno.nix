{
  network.description = "Brno production infrastructure";

  kmd =
    { config, lib, pkgs, ...}:
    {
      deployment.targetHost = "10.21.162.10";

      imports = [
        ./brno.nix
      ];

      services.ckan = {
        ckanURL = "https://kmd.brno.cz";
        #storagePath = "/home/";
      };

      boot.loader.grub.device = "/dev/sda";

      networking = {
        hostName = "kmd";
        defaultGateway = "10.21.162.1";
        nameservers = [ "10.0.99.8" "10.0.99.24" ];
        interfaces.ens32 = {
          ipAddress = "10.21.162.10";
          prefixLength = 24;
        };
      };

      security.pki.certificateFiles = [ /root/certs/root_brno.crt ];

      fileSystems."/" =
        { device = "/dev/disk/by-uuid/75502abb-8b5d-4e62-b1c1-8c3ed00317f6";
          fsType = "ext4";
        };

      # fileSystems."/data" =
      #   { device = "/dev/disk/by-uuid/6mazDN-1Pwk-RTlK-jG1y-xzY5-1qIv-ClheFE";
      #     fsType = "ext4";
      #   };
    };
  kod =
    { config, lib, pkgs, ...}:
    {
      deployment.targetHost = "10.10.11.10";

      imports = [
        ./brno.nix
      ];
 
      services.ckan.ckanURL = "https://kod.brno.cz";

      boot.loader.grub.device = "/dev/sda";

      networking = {
        hostName = "kod";
        defaultGateway = "10.10.11.1";
        nameservers = [ "10.0.99.8" "10.0.99.24" ];
        interfaces.ens32 = {
          ipAddress = "10.10.11.10";
          prefixLength = 24;
        };
     };

      fileSystems."/" =
        { device = "/dev/disk/by-uuid/abb1e733-15fd-4228-9eae-51800b209a2c";
          fsType = "ext4";
        };
    };

  lpetl =
    { config, lib, pkgs, ...}:
    {
      deployment.targetHost = "10.21.162.20";

      boot.loader.grub.device = "/dev/sda";

      fileSystems."/" =
        { device = "/dev/disk/by-uuid/97f7a696-e901-4e1c-b712-f3e6e48644bc";
          fsType = "ext4";
        };
    };
}
