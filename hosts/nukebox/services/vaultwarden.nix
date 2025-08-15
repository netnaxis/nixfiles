{ config, lib, ... }:

{
  sops.secrets."vaultwarden/domain" = {};

  sops.templates."vaultwarden.env" = {
    content = ''
      DOMAIN = ${config.sops.placeholder."vaultwarden/domain"}
    '';
    owner = config.users.users.vaultwarden.name;
    group = config.users.groups.vaultwarden.name;
    restartUnits = [ "vaultwarden.service" ];
  };

  services.vaultwarden = {
    enable = true;

    environmentFile = config.sops.templates."vaultwarden.env".path;

    config = {
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
    };
  };
}
