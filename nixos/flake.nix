{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # home-manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # nix-colors theming for home-manager
    nix-colors.url = "github:misterio77/nix-colors";
    # hyprwm
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = { self, nixpkgs, home-manager, fenix, nix-colors, ... }@inputs:
    let
      inherit (self) outputs;

      user = "jules";
      host = "ishot";
      handle = "${user}@${host}";
      homeDir = "/home/${user}";
      system = "x86_64-linux";
      version = "23.11";
      globalAliases = {
        m = "micro";
        nano = "micro";
        cpa = "cp -rviup";
        l = "ls -la";
        hm = "cd ${homeDir}";
        dev = "cd ${homeDir}/_dev";
        z = "zellij";
        ass = "atuin search -i";
        nf =
          "neofetch --gap 15 --color_blocks off --memory_percent on --disk_percent on";
      };
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };

    in {
      packages.x86_64-linux.default =
        fenix.packages.x86_64-linux.latest.toolchain;
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ pkgs, ... }: {
            nixpkgs.overlays = [ fenix.overlays.default ];
            environment.systemPackages = with pkgs; [
              (fenix.complete.withComponents [
                "cargo"
                "clippy"
                "rust-src"
                "rustc"
                "rustfmt"
              ])
              rust-analyzer-nightly
            ];
          })
        ];
      };

      # NixOS configuration entrypoint
      # build w/ `nixos-rebuild --flake .#ishot`
      nixosConfigurations = {
        ishot = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs pkgs version user host homeDir globalAliases;
          };
          # > Our main nixos configuration file <
          modules = [ ./system/configuration.nix ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # build w/ `home-manager --flake .#jules@ishot`
      homeConfigurations = {
        "jules@ishot" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs pkgs version user host homeDir globalAliases;
          };
          # > Our main home-manager configuration file <
          modules = [ ./home-manager/home.nix ];
        };
      };
    };
}
