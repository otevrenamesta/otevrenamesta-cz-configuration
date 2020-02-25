#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix

set -eu -o pipefail

rm -f default.nix node-env.nix node-packages.nix
node2nix -i node-packages.json --nodejs-10
