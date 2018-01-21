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
      "odczdataset"
      "syndicate"
    ];

    extraConfig = ''
      ### extension: ckanext-odczdataset
      ckan.odczdataset.private_catalog = true

      ### extension: ckanext-redmine-autoissues
      ckan.redmine.url = https://redmine/
      ckan.redmine.apikey = CHANGE
      ckan.redmine.project = mestska_data
      ckan.redmine.flag = md_ticket_url
      ckan.redmine.subject_prefix = Úkoly datasetu:


      ### extension: ckanext-syndicate
      ckan.syndicate.ckan_url = http://ckan-pub
      ckan.syndicate.api_key = CHANGE
      ckan.syndicate.flag = md_syndicate
      ckan.syndicate.id = md_syndicated_id
      ckan.syndicate.replicate_organization = true
    '';
  };

}
