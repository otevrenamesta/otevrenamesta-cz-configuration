{ pkgs, buildPythonPackage }:

let
  self = pkgs.python27Packages;
  python-redmine = pkgs.callPackage ./python-redmine.nix { inherit pkgs buildPythonPackage; };
in

buildPythonPackage {
  name = "ckanext-redmine-autoissues";
  src = pkgs.fetchFromGitHub {
    owner = "sorki";
    repo = "ckanext-redmine-autoissues";
    rev = "70ec18e3154e6040d48607fb241d1e956fae166e";
    sha256 = "1fpscm6lhhjyjnvgim3h8fcdamqh8xlxahdzyr4ll2wbhx8ik61k";
  };

  propagatedBuildInputs = [ python-redmine ];
}
