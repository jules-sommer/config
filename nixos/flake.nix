{
  description = "JulesOS NixOS configuration flake";
  inputs = {
    stable.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    pinix.url = "github:remi-dupre/pinix";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      # If using a stable channel you can use `url = "github:nix-community/nixvim/nixos-<version>"`
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    icehouse = {
      url = "github:snowfallorg/icehouse?ref=v1.1.0";
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

      # FIXME: A specific version of Rust is needed right now or
      # the build fails. Re-enable this after some time has passed.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Vault Integration
    vault-service = {
      url = "github:DeterminateSystems/nixos-vault-service";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake Hygiene
    flake-checker = {
      url = "github:DeterminateSystems/flake-checker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Source: https://snowfall.org/guides/lib/quickstart/
    # name must remain for snowfall to function
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Snowfall Flake
    flake = {
      url = "github:snowfallorg/flake?ref=v1.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    thaw = {
      url = "github:snowfallorg/thaw";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-software-center.url = "github:snowfallorg/nix-software-center";

    xremap-flake.url = "github:xremap/nix-flake";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors.url = "github:misterio77/nix-colors";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = inputs:
    let
      test = builtins.trace inputs;
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;
        snowfall = {
          # Choose a namespace to use for your flake's packages, library,
          # and overlays.
          namespace = "jules";
          # package-namespace = "uwu_pkgs";
          root = ./.;

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
      channels-config = { allowUnfree = true; };

      overlays = with inputs; [
        fenix.overlays.default
        # neovim.overlays.default
        # tmux.overlay
        flake.overlays.default
        thaw.overlays.default
        # cowsay.overlays.default
        icehouse.overlays.default
        attic.overlays.default
      ];

      home.modules = with inputs; [ nixvim.homeManagerModules.nixvim ];

      systems.modules.nixos = with inputs; [
        home-manager.nixosModules.home-manager
        nixvim.nixosModules.nixvim
        xremap-flake.nixosModules.default

      ];
    };
}
