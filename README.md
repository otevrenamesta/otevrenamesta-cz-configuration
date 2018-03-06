otevrenamesta.cz configuration
==============================

1. Install NixOps - https://nixos.org/nixops/manual/#chap-installation

2. Configure environment

    ~~~~~ bash
    source activate
    ~~~~~

    This configures `NIX_PATH`, `NIXOPS_DEPLOYMENT` variables and configures prompt.

3. Generate empty secret files for API keys

    ~~~~~ bash
    for i in syndication-api-key redmine-api-key lpetl-user-password; do
      echo "CHANGE_ME" > static/$i.secret
    done
    ~~~~~

4. Create the deployment:

    ~~~~~ bash
    nixops create network.nix network-prod.nix
    ~~~~~

5. Deploy!

    ~~~~~ bash
    nixops deploy
    ~~~~~

Virtualized deployment
----------------------

```bash
nixops create -d virt network.nix network-libvirt.nix
nixops deploy -d virt
```
