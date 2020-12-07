
Deprecated. The content has been moved to GitLab.
*************************************************

otevrenamesta.cz configuration
==============================

1. Install [Morph](https://github.com/DBCDK/morph).

    ~~~~~ nix
    environment.systemPackages = with pkgs; [
      morph
    ];
    ~~~~~

2. Deploy environment

    ~~~~~ bash
    morph deploy morph.nix switch
    ~~~~~

3. or deploy a single machine

    ~~~~~ bash
    morph deploy --on=<machine_name> morph.nix switch
    ~~~~~
