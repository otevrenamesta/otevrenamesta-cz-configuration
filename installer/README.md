VM installer
============

Creates custom ISO installer for easy libvirt guest creation.

We need to build it ourselves so that it contains the right set of SSH keys.

Build with
----------

```
nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=toplevel.nix
```

Install with
------------

`justdoit` command
