{ config, ... }:

{
  sops.secrets."caddy/domain-w" = {};
  sops.secrets."caddy/cloudflare-token" = {};
  sops.secrets."caddy/vaultwarden-url" = {};
  sops.secrets."caddy/immich-url" = {};

  sops.templates."Caddyfile" = {
    content = ''
      ${config.sops.placeholder."caddy/domain-w"} {
        tls {
            dns cloudflare ${config.sops.placeholder."caddy/cloudflare-token"}
            propagation_delay 30s
        }

        @vaultwarden host ${config.sops.placeholder."caddy/vaultwarden-url"}
        reverse_proxy @vaultwarden http://${config.services.vaultwarden.config.ROCKET_ADDRESS}:${toString config.services.vaultwarden.config.ROCKET_PORT}

        @immich host ${config.sops.placeholder."caddy/immich-url"}
        reverse_proxy @immich http://${config.services.immich.host}:${toString config.services.immich.port}
      }
    '';
    owner = config.services.caddy.user;
    group = config.services.caddy.group;
    reloadUnits = [ "caddy.service" ];
  };

  services.caddy = {
    enable = true;
    configFile = config.sops.templates."Caddyfile".path;
  };

}

