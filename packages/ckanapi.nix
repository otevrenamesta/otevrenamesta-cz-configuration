{ pkgs, buildPythonPackage }:

let
  self = pkgs.python27Packages;
in

buildPythonPackage {
  name = "ckanapi";
  src = pkgs.fetchFromGitHub {
    owner = "ckan";
    repo = "ckanapi";
    rev = "4b34104c20df61711eeca6d3d139cef89127ba26";
    sha256 = "0x9hxp06dwmiql6c56ck3pzbb802yqn6q9c2fxmx1ivfsy3rkgw3";
  };

  propagatedBuildInputs = with self; [ requests docopt simplejson ];

  doCheck = false;
  # due to
  #   Traceback (most recent call last):
  #   File "/tmp/nix-build-python2.7-ckanapi.drv-0/ckanapi-4b34104c20df61711eeca6d3d139cef89127ba26-src/ckanapi/tests/test_cli_dump.py", line 241, in test_parent_datapackages
  #     assert exists(target + '/dp/data/d902fafc-5717-4dd0-87f2-7a6fc96989b7')

}
