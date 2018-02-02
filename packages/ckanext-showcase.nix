{ pkgs, buildPythonPackage }:

buildPythonPackage {
  name = "ckanext-showcase";
  src = pkgs.fetchFromGitHub {
    owner = "ckan";
    repo = "ckanext-showcase";
    rev = "3606f295331ae5a56527855217010a0fe36d90d7";
    sha256 = "1kiqr76i193c1z3wm46n1wyzdlamjbnzvpi09bfvb62phnjlzryn";
  };
}

