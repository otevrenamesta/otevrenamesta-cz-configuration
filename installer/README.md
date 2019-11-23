VM installer
============

Build with
----------

```
nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=toplevel.nix
```

Install with
------------

`justdoit` command
