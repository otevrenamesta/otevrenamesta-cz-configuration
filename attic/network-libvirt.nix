let
  lvirt = {
    deployment.targetEnv = "libvirtd";
    deployment.libvirtd.headless = true;
    deployment.libvirtd.memorySize = 1024;
    deployment.libvirtd.extraDevicesXML = ''
      <serial type='pty'>
        <target port='0'/>
      </serial>
      <console type='pty'>
        <target type='serial' port='0'/>
      </console>
    '';
  };

in
{
  network.description = "testing infrastructure";

  ckan        = lvirt;
  ckan-pub    = lvirt;
  redmine     = lvirt;
  proxy       = lvirt;
  lpetl       = lvirt;
  virtuoso    = lvirt;
}
