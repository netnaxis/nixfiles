{config, ...}:

{
  services.immich = {
    enable = true;
    port = 2283;
    host = "127.0.0.1";
    accelerationDevices = [ "/dev/dri/renderD128" ]; 
  };
  users.users.immich.extraGroups = [ "video" "render" ];
}
