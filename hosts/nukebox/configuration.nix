{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./services/vaultwarden.nix
    ./services/caddy.nix
    ./services/wireguard.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nukebox";

  networking.firewall = {
    enable = true;

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

  time.timeZone = "Europe/Kyiv";

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
  ];

  system.stateVersion = "25.05";
  nixpkgs.config.allowUnfree = true;
}

