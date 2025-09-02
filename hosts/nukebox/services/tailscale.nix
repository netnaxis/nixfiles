{config, ...}:

{
# Still need to run `sudo tailscale up --auth-key=KEY` afterwards since auth key is valid for one time

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
    disableTaildrop = true;
    extraSetFlags = [ "--advertise-exit-node" "--advertise-routes=192.168.1.0/24" ];
  };

}
