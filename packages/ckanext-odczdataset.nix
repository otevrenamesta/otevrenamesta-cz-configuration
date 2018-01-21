{ pkgs, buildPythonPackage }:

buildPythonPackage {
  name = "ckanext-odczdataset";
  src = pkgs.fetchFromGitHub {
    owner = "otevrenamesta";
    repo = "ckanext-odczdataset";
    rev = "47451fd586e01895de0a3b38c1a46a2dba9ba2a5";
    sha256 = "1kzvxdm5pc0w45d1j6l1dhnyh4jqznkhvcdaxf1fqgk8zpvaiyl2";
  };
}

