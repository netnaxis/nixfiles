{ config, lib, ... }:

{
  users.users.factorio = {
    isSystemUser = true;
    group = "factorio";
    home = "/var/lib/factorio";
  };
  users.groups.factorio = {};

  systemd.services.factorio.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = "factorio";
    Group = "factorio";
  };

  sops.secrets."factorio/game-password" = {};
  sops.templates."factorio-secrets.json" = {
    content = ''
      {
        "game-password": "${config.sops.placeholder."factorio/game-password"}"
      }
    '';
    owner = "factorio";
    group = "factorio";
    restartUnits = [ "factorio.service" ];
  };

  services.factorio = {
    enable = true;
    
    requireUserVerification = false;
    port = 34197;

    game-name = "Netnax Factorio Server";

    extraSettingsFile = config.sops.templates."factorio-secrets.json".path;
    admins = [ "netnax" ];
  };

}
