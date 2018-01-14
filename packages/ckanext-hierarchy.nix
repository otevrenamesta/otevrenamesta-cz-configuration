{ pkgs, buildPythonPackage }:

buildPythonPackage {
  name = "ckanext-hierarchy";
  src = pkgs.fetchFromGitHub {
    owner = "datagovuk";
    repo = "ckanext-hierarchy";
    rev = "72b6dfdd56cd775457c37352d6cb0bcb0aaea261";
    sha256 = "1mh5787y2k00wb1hfp1hrikvdfrm4g9vwq2azk3cqv5g5s237jmy";
  };
}

