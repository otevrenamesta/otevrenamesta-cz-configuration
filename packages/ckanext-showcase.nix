{ pkgs, buildPythonPackage }:

buildPythonPackage {
  name = "ckanext-showcase";
  src = pkgs.fetchFromGitHub {
    owner = "fix-all-the-things";
    repo = "ckanext-showcase";
    rev = "fce8396468f893bbef23246533f443e5152173de";
    sha256 = "1m7gha9qgyck9896wby2k08jk6psipx4sy57i390hr7aca3h9sc3";
  };
}

