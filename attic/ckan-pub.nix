{ config, pkgs, lib, ...}:

let
  plugins = (import ./packages/all-ckan-plugins.nix { inherit pkgs; }).plugins;
in
{
  imports = [
    ./modules/ckan.nix
  ];

  services.ckan = {
    enable = true;

    ckanURL = lib.mkDefault "http://ckan-pub";

    localeDefault = "cs_CZ";

    createAdmin = true;

    extraPluginPackages = plugins;
    enabledPlugins = [
      "stats"
      "text_view"
      "image_view"
      "recline_view"
      "fileremove"
      "hierarchy_display"
      "hierarchy_form"
      "redmine"
      "noregistration"
      "odczdataset"
      "showcase"
    ];

    extraConfig = ''
      ### extension: ckanext-redmine-autoissues
      ckan.redmine.url = https://redmine/
      ckan.redmine.apikey = CHANGE
      ckan.redmine.project = mestska_data
      ckan.redmine.flag = md_ticket_url
      ckan.redmine.subject_prefix = Úkoly datasetu:
    '';
  };

}
