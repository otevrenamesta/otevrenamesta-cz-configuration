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
    rev = "050a95d00d62d13a69911c9a1b4667ded979e654";
    sha256 = "1yy1xl5lsg9cr8p6icqydvfxa5rzd5hyx3dfai5x0nwyczsslsd7";
  };

  propagatedBuildInputs = [ python-redmine ];
}
