{
  description = "Whatever";

  nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, sops-nix, home-manager, disko }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      # Build Caddy with Cloudflare DNS plugin
      caddy-cloudflare = pkgs.caddy.withPlugins {
        plugins = [ "github.com/caddy-dns/cloudflare@v0.2.3" ];
        hash = "sha256-to0fhW7LWBocw1ccpPQ7e2nod7iJO9gkWZpjHsZDeu4=";
      };
    in
    {
      nixosConfigurations.nukebox = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/nukebox/configuration.nix
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          disko.nixosModules.disko

          { services.caddy.package = caddy-cloudflare; }
        ];
      };
    };
}

