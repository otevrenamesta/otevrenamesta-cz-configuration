{ pkgs, buildPythonPackage }:

let
  self = pkgs.python27Packages;
  ckanapi = pkgs.callPackage ./ckanapi.nix { inherit pkgs buildPythonPackage; };
in

buildPythonPackage {
  name = "ckanext-syndicate";
  src = pkgs.fetchFromGitHub {
    owner = "otevrenamesta";
    repo = "ckanext-syndicate";
    rev = "e1eab48682c637c37b13bdb2942041693c3cd13c";
    sha256 = "104cpcfxz47cqifrzqm0ya4ryv12lvbnr60sr1fh09ijajv2nmj4";
  };

  propagatedBuildInputs = with self; [ ckanapi requests pyasn1 ndg-httpsclient pyopenssl ];
}
