{ pkgs, buildPythonPackage }:

buildPythonPackage {
  name = "ckanext-noregistration";
  src = pkgs.fetchFromGitHub {
    owner = "ogdch";
    repo = "ckanext-noregistration";
    rev = "26f7f073c05c2954ddb5086e49ef7982a059146e";
    sha256 = "03kbidrb7a08pb6n3xyhh4hvs05g9g757yipxj8z4jlziyhvg2x6";
  };
}

