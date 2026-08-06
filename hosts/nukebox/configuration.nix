{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./services/vaultwarden.nix
    ./services/caddy.nix
    ./services/wireguard.nix
    ./services/immich.nix
    ./services/factorio.nix
    ./services/syncthing.nix
    ./services/tailscale.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nukebox";

  networking.firewall = {
    enable = true;

    allowedTCPPorts = [
      22000 # Syncthing (transfer)
    ];

    allowedUDPPorts = [
      34197 # Factorio
      22000 # Syncthing (transfer)
      21027 # Syncthing (discovery)
      41641 # Tailscale
    ];

    interfaces.enp3s0 = {
      allowedTCPPorts = [ 
        22 #SSH
        3389 # RDP
        80 # http
        443 # https
      ];

      allowedUDPPorts = [
        51820 # Wireguard
      ];

    };

    interfaces.wg0 = {
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };

  time.timeZone = "Europe/Kyiv";

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ]; 
  };
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };

  programs.zsh.enable = true;

  users.users.netnax = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICS1l8Qlp/wkws4hS/zwQ25CSeFas8+Brdza/JMQQSi0 netnax@rbook"
    ];
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  security.sudo.wheelNeedsPassword = false;

  services.xrdp.enable = true;

  services.xserver = {
    enable = true;
    desktopManager.xfce.enable = true;
    displayManager.lightdm.enable = true;
  };

  sops = { 

    defaultSopsFile = ./secrets.yaml;

    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };

  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    zsh
    sops
    btop
    fastfetch
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.05";
  nixpkgs.config.allowUnfree = true;
}

