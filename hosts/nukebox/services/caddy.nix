{ config, ... }:

{
  # Secrets from sops-nix
  sops.secrets."caddy/domain-w" = {};
  sops.secrets."caddy/cloudflare-token" = {};
  sops.secrets."caddy/vaultwarden-url" = {};

  # Environment file for Cloudflare token
  sops.templates."caddy.env" = {
    content = ''
      CLOUDFLARE_TOKEN=${config.sops.placeholder."caddy/cloudflare-token"}
    '';
    owner = config.services.caddy.user;
    group = config.services.caddy.group;
  };

  # Full Caddyfile template
  sops.templates."Caddyfile" = {
    content = ''
      ${config.sops.placeholder."caddy/domain-w"} {
        tls {
            dns cloudflare {$CLOUDFLARE_TOKEN}
            propagation_delay 30s
        }

        @vaultwarden host ${config.sops.placeholder."caddy/vaultwarden-url"}
        reverse_proxy @vaultwarden http://${config.services.vaultwarden.config.ROCKET_ADDRESS}:${toString config.services.vaultwarden.config.ROCKET_PORT}
      }
    '';
    owner = config.services.caddy.user;
    group = config.services.caddy.group;
  };

  # Caddy service config
  services.caddy = {
    enable = true;
    configFile = config.sops.templates."Caddyfile".path;
  };

  # Load environment variables for Caddy at runtime
  systemd.services.caddy.serviceConfig.EnvironmentFile =
    config.sops.templates."caddy.env".path;
}

