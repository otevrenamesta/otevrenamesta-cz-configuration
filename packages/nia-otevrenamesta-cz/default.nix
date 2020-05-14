{ pkgs ? import <nixpkgs> {
    inherit system;
  }
, system ? builtins.currentSystem
}:

let
  rev = "72fb78b7adc0e4b73051eedaaeb29642d18b1966";
  sha256 = "1867y36wvgw6abz7khybhyzljgmbqsblzkjkz1z446lnsll8msw1";
in
(import ./composition.nix { inherit pkgs system; }).overrideAttrs (attrs:
{
  name = "nia.otevrenamesta.cz";
  src = pkgs.fetchzip {
    url = "https://github.com/otevrenamesta/nia.otevrenamesta.cz/archive/${rev}.tar.gz";
    inherit sha256;
  };
})
