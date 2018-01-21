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
    rev = "09c0dd0419a07aabd368009cf9eac982553c0faa";
    sha256 = "1902c6zfdhacqg84dl6c300375agvxqx31iqck2wicia6lkjzi1q";
  };

  propagatedBuildInputs = with self; [ ckanapi requests pyasn1 ndg-httpsclient pyopenssl ];
}
