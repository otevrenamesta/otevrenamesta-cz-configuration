{ pkgs, ...}:
{
  plugins = {
    "redmine" = pkgs.callPackage ./ckanext-redmine-autoissues.nix {
       pkgs = pkgs;
       buildPythonPackage = pkgs.python27Packages.buildPythonPackage;
    };

    "fileremove" = pkgs.callPackage ./ckanext-fileremove.nix {
       pkgs = pkgs;
       buildPythonPackage = pkgs.python27Packages.buildPythonPackage;
    };

    "hierarchy" = pkgs.callPackage ./ckanext-hierarchy.nix {
       pkgs = pkgs;
       buildPythonPackage = pkgs.python27Packages.buildPythonPackage;
    };

    "noregistration" = pkgs.callPackage ./ckanext-noregistration.nix {
       pkgs = pkgs;
       buildPythonPackage = pkgs.python27Packages.buildPythonPackage;
    };

    "showcase" = pkgs.callPackage ./ckanext-showcase.nix {
       pkgs = pkgs;
       buildPythonPackage = pkgs.python27Packages.buildPythonPackage;
    };

    "syndicate" = pkgs.callPackage ./ckanext-syndicate.nix {
       pkgs = pkgs;
       buildPythonPackage = pkgs.python27Packages.buildPythonPackage;
    };

    "odczdataset" = pkgs.callPackage ./ckanext-odczdataset.nix {
       pkgs = pkgs;
       buildPythonPackage = pkgs.python27Packages.buildPythonPackage;
    };
  };
}
