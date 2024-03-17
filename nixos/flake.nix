{
  description = "JulesOS NixOS configuration flake";
  inputs = {
    stable = { url = "github:nixos/nixpkgs/nixos-23.11"; };
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };

    nix-fast-build = {
      url = "github:Mic92/nix-fast-build";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pinix.url = "github:remi-dupre/pinix";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    oxalica-rs = {
      url = "github:oxalica/rust-overlay";
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };

    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # GPG default configuration
    gpg-base-conf = {
      url = "github:drduh/config";
      flake = false;
    };

    bibata-cursors = {
      url = "github:suchipi/Bibata_Cursor";
      flake = false;
    };

    attic = {
      url = "github:zhaofengli/attic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vault-service = {
      url = "github:DeterminateSystems/nixos-vault-service";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-checker = {
      url = "github:DeterminateSystems/flake-checker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Source: https://snowfall.org/guides/lib/quickstart/
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    icehouse = {
      url = "github:snowfallorg/icehouse";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    thaw = {
      url = "github:snowfallorg/thaw";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-software-center = { url = "github:snowfallorg/nix-software-center"; };
    xremap-flake = { url = "github:xremap/nix-flake"; };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors = { url = "github:misterio77/nix-colors"; };
    hyprland = { url = "github:hyprwm/Hyprland"; };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;
        snowfall = {
          # Choose a namespace to use for your flake's packages, library,
          # and overlays.
          namespace = "jules";
          # package-namespace = "uwu_pkgs";

          config = {
            allowUnfree = true;
            permittedUnfreePackages = [ "electron" ];
          };

          # Add flake metadata that can be processed by tools like Snowfall Frost.
          meta = {
            # A slug to use in documentation when displaying things like file paths.
            name = "jules-ishottt";
            # A title to show for your flake, typically the name.
            title = "JulesOS (jules@ishottt) Sys Flake";
          };
        };
      };
    in lib.mkFlake {
      channels-config = {
        allowUnfree = true;
      };

      overlays = with inputs; [
        fenix.overlays.default
        flake.overlays.default
        thaw.overlays.default
        icehouse.overlays.default
        attic.overlays.default
      ];

      # Applied modules to all home-manager instances
      homes.users."jules@ishottt" = {
        modules = with inputs; [
          nixvim.homeManagerModules.nixvim
          hyprland.homeManagerModules.default
        ];
      };

      systems.modules.nixos = with inputs; [
        nixvim.nixosModules.nixvim
        home-manager.nixosModules.home-manager
        xremap-flake.nixosModules.default
        vault-service.nixosModules.nixos-vault-service
      ];
    };
}
