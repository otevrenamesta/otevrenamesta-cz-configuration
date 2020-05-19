#!/usr/bin/env bash

node2nix \
  --nodejs-12 \
  --input package.json \
  --output node-packages.nix \
  --node-env node-env.nix \
  --composition node-composition.nix
