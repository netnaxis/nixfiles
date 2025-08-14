{config, ...}:

{

  sops.secrets."wireguard/privatekey" = {};
  sops.secrets."wireguard/publickey" = {};
  sops.secrets."wireguard/endpoint" = {};

  sops.templates."wg0.conf" = {
    content = ''
      [Interface]
      Address = 10.0.0.1/24
      PrivateKey = ${config.sops.placeholder."wireguard/privatekey"}

      [Peer]
      PublicKey = ${config.sops.placeholder."wireguard/publickey"}
      AllowedIPs = 10.0.0.2/32
      Endpoint = ${config.sops.placeholder."wireguard/endpoint"}
      PersistentKeepalive = 25
    '';
  };
  networking.wg-quick.interfaces.wg0.configFile = config.sops.templates."wg0.conf".path;

}
