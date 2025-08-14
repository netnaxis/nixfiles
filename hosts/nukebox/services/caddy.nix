{ config, ... }:

{
  sops.secrets."caddy/domain-w" = {};
  sops.secrets."caddy/cloudflare-token" = {};
  sops.secrets."caddy/vaultwarden-url" = {};

  sops.templates."Caddyfile" = {
    content = ''
      ${config.sops.placeholder."caddy/domain-w"} {
        tls {
            dns cloudflare ${config.sops.placeholder."caddy/cloudflare-token"}
            propagation_delay 30s
        }

        @vaultwarden host ${config.sops.placeholder."caddy/vaultwarden-url"}
        reverse_proxy @vaultwarden http://${config.services.vaultwarden.config.ROCKET_ADDRESS}:${toString config.services.vaultwarden.config.ROCKET_PORT}
      }
    '';
    owner = config.services.caddy.user;
    group = config.services.caddy.group;
  };

  services.caddy = {
    enable = true;
    configFile = config.sops.templates."Caddyfile".path;
  };

}

