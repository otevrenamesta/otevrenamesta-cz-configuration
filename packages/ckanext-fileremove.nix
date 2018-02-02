{ pkgs, buildPythonPackage }:

buildPythonPackage {
  name = "ckanext-fileremove";
  src = pkgs.fetchFromGitHub {
    owner = "pheaktra21";
    repo = "fileremove";
    rev = "b4160ef232ecdce6e6d870eea12ee58cc93f2a46";
    sha256 = "1ch3vgkr4k992bh07cwfvvvra16a17nc8yk6frsv063fa8k0h0b6";
  };
}

