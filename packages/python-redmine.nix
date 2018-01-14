{ pkgs, buildPythonPackage }:

let
  self = pkgs.python27Packages;
in

buildPythonPackage {
  name = "python-redmine";
  src = pkgs.fetchFromGitHub {
    owner = "maxtepkeev";
    repo = "python-redmine";
    rev = "master";
    sha256 = "0mckchx9p9mmwr9x9g7qnrqlksdmpk2a7ysha1iq3chqzdsyp5pg";
  };

  propagatedBuildInputs = with self; [ mock nose coverage ];
}
