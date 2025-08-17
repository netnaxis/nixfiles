{config, ...}:

{
  users.users.immich = {
    home = "/var/cache/immich";
  };

  services.immich = {
    enable = true;
    port = 2283;
    host = "127.0.0.1";
    accelerationDevices = [ "/dev/dri/renderD128" ]; 
    machine-learning.environment = {
      HF_XET_CACHE = "/var/cache/immich/huggingface-xet";
    };
  };
  users.users.immich.extraGroups = [ "video" "render" ];
}
