{
  description = "Jules' Xetamine Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-conf-editor = {
      url = "github:snowfallorg/nixos-conf-editor";
      inputs.nixpkgs.follows = "unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "unstable";
    };

    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "unstable";
    };

    snowfall-drift = {
      url = "github:snowfallorg/drift";
      inputs.nixpkgs.follows = "unstable";
    };

    snowfall-thaw = {
      url = "github:snowfallorg/thaw";
      inputs.nixpkgs.follows = "unstable";
    };

    xremap-flake = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "unstable";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "unstable";
    };

    nix-colors = { url = "github:misterio77/nix-colors"; };

    systems.url = "github:nix-systems/x86_64-linux";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "unstable";
    };
  };

  outputs = inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;
        snowfall = {
          namespace = "xeta";
          # Move .nix files to  `./nixos/` dir for organization.
          root = ./nixos;

          config = {
            allowUnfree = true;
            permittedUnfreePackages = [ "electron" ];
          };

          meta = {
            name = "jules-ishottt";
            title = "JulesOS (jules@xetamine) Sys Flake";
          };
        };
      };
    in lib.mkFlake {
      overlays = with inputs; [
        fenix.overlays.default
        snowfall-flake.overlays.default
        snowfall-thaw.overlays.default
        snowfall-drift.overlays.default
      ];
    };
}
