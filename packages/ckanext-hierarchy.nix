{ pkgs, buildPythonPackage }:

buildPythonPackage {
  name = "ckanext-hierarchy";
  src = pkgs.fetchFromGitHub {
    owner = "otevrenamesta";
    repo = "ckanext-hierarchy";
    rev = "dee497f4c032759b150da2ad1ba222b5242d5154";
    sha256 = "1yl6wh8mi59zm4vxjkvinrx1sp9hzyid77gmm0jrv611p1xmxh3m";
  };
}

