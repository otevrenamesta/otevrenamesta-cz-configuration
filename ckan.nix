{ config, pkgs, lib, ...}:

let
  plugins = {
   "redmine" = pkgs.callPackage ./packages/ckanext-redmine-autoissues.nix {
      pkgs = pkgs;
      buildPythonPackage = pkgs.python27Packages.buildPythonPackage;
   };

   "hierarchy" = pkgs.callPackage ./packages/ckanext-hierarchy.nix {
      pkgs = pkgs;
      buildPythonPackage = pkgs.python27Packages.buildPythonPackage;
   };

   "noregistration" = pkgs.callPackage ./packages/ckanext-noregistration.nix {
      pkgs = pkgs;
      buildPythonPackage = pkgs.python27Packages.buildPythonPackage;
   };

  };

in

{
  imports = [
    ./modules/ckan.nix
  ];

  services.ckan = {
    enable = true;
    #debug = true;
    #ckanURL = "http://192.168.122.109:5000";
    ckanURL = "http://ckan";

    createAdmin = true;

    extraPluginPackages = plugins;
    enabledPlugins = [
      "stats"
      "text_view"
      "image_view"
      "recline_view"
      "redmine"
      "hierarchy_display"
      "hierarchy_form"
      "noregistration"
    ];

    extraConfig = ''
      ### extension: ckanext-redmine-autoissues
      # The URL of the Redmine site
      ckan.redmine.url = https://redmine/

      # Redmine API key
      ckan.redmine.apikey = CHANGE

      # Redmine project
      ckan.redmine.project = mestska_data

      # The custom metadata flag used for storing redmine URL
      # (optional, default: redmine_url).
      ckan.redmine.flag = md_ticket_url

      # A prefix to apply to the name of the dataset when creating an issue
      # (optional, default: New dataset)
      ckan.redmine.subject_prefix = Úkoly datasetu:
    '';
  };

}
