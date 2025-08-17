{ config, ... }:

{
  users.groups.syncthing.members = [ "caddy" ];

  services.syncthing = {
    enable = true;
    guiAddress = "/run/syncthing/syncthing.sock";
  };

  systemd.services.syncthing.serviceConfig = {
    UMask = "0007";
    RuntimeDirectory = "syncthing";
    RuntimeDirectoryMode = "0750";
  };
}

