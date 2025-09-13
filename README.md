# MyNixOS Config

This repository contains my personal NixOS configuration, managed with Nix Flakes.

## Host

- `nukebox`: A server running various services.

## Features

- **Flakes**: The entire configuration is managed as a Nix Flake, providing reproducibility and easy management of dependencies.
- **Secrets Management**: Secrets are managed using [sops-nix](https://github.com/Mic92/sops-nix), with secrets encrypted in `secrets.yaml`.
- **Disk Partitioning**: Disk partitioning is managed declaratively using [disko](https://github.com/nix-community/disko).
- **Home Manager**: User-specific configurations are managed with [Home Manager](https://github.com/nix-community/home-manager).

## Services

The `nukebox` host is running the following services:

- **Caddy**: A modern, powerful, and easy-to-use web server. It's configured to use Cloudflare for DNS challenges to obtain SSL certificates.
- **Vaultwarden**: An unofficial Bitwarden compatible server written in Rust.
- **Immich**: A self-hosted photo and video backup solution.
- **Factorio**: A dedicated server for the game Factorio.
- **Syncthing**: A continuous file synchronization program.
- **Tailscale**: A mesh VPN for secure networking.
- **Wireguard**: A fast, modern, and secure VPN tunnel.

## Usage

To build and apply the configuration for a host, use the following command:

```bash
nixos-rebuild switch --flake .#nukebox
```

## Repository Structure

- `flake.nix`: The entry point for the Nix Flake, defining the inputs and outputs of the configuration.
- `hosts/`: Contains the configuration for each host.
  - `nukebox/`: The configuration for the `nukebox` host.
    - `configuration.nix`: The main configuration file for the host.
    - `disko.nix`: The disk partitioning configuration.
    - `hardware-configuration.nix`: The hardware-specific configuration.
    - `secrets.yaml`: The encrypted secrets for the host.
    - `services/`: Contains the configuration for the services running on the host.
      - `caddy.nix`: Caddy web server configuration.
      - `factorio.nix`: Factorio game server configuration.
      - `immich.nix`: Immich photo and video backup solution configuration.
      - `syncthing.nix`: Syncthing file synchronization configuration.
      - `tailscale.nix`: Tailscale mesh VPN configuration.
      - `vaultwarden.nix`: Vaultwarden (Bitwarden compatible server) configuration.
      - `wireguard.nix`: Wireguard VPN configuration.
