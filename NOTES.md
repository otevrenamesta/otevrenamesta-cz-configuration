NixOps
======

Envs
----

Virt
~~~~

```
. activate_virt
nixops create network.nix network-virt.nix
```

Staging
~~~~~~~

```
. activate_staging
nixops create network-small-staging.nix network-staging.nix
```

Brno
~~~~

```
. activate_brno
nixops create network-small.nix network-brno.nix
```


Commands
--------

Delete obsolete vms
```
nixops deploy -d virt --kill-obsolete
```

Modify deployment
```
nixops modify -d staging network-new-logical.nix network-new-physical.nix
```

Modify and rename deployment
```
nixops modify -d staging -n temporary network-new-logical.nix network-new-physical.nix
```


Certificates
============

Apache
------

```
services.httpd.virtualHosts.<name>.sslServerCert = "/cesta" 
services.httpd.virtualHosts.<name>.sslServerKey = "/cesta"
```

Nginx
-----

```
services.nginx.virtualHosts.<name>.sslCertificate = "/cesta"
services.nginx.virtualHosts.<name>.sslCertificateKey = "/cesta"
```


