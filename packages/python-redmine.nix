{ pkgs, buildPythonPackage }:

let
  self = pkgs.python27Packages;
in

buildPythonPackage {
  name = "python-redmine";
  src = pkgs.fetchFromGitHub {
    owner = "maxtepkeev";
    repo = "python-redmine";
    rev = "f084f19bbeeeaff489296c8f80309642f25cc382";
    sha256 = "1k4r6m0r9z01srkx4c4bhpmif747ch8ha0am7x7wqvvhwnk02f70";
  };

  propagatedBuildInputs = with self; [ mock nose coverage ];
}
