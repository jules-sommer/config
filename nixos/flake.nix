{
  description = "Your new nix config";

  inputs = {
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # keyboard remapping util
    xremap-flake.url = "github:xremap/nix-flake";
    nixpkgs.url = "nixpkgs/nixos-unstable";
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

  outputs = { self, fenix, nixpkgs, home-manager, helix, hyprland, nix-colors
    , ... }@inputs:
    let
      inherit (self) outputs;
      user = "jules";
      host = "ishot";
      handle = "${user}@${host}";
      homeDir = "/home/${user}";
      system = "x86_64-linux";
      version = "23.11";
      theme = "gigavolt";
      waybarStyle = 0; # 0 = default, 1 = other
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
      env_vars = {
        NIXOS_OZONE_WL = "1";
        NIXPKGS_ALLOW_UNFREE = "1";
        XDG_CONFIG_HOME = "${homeDir}/_dev/.config";
        XDG_SESSION_TYPE = "wayland";
        GDK_BACKEND = "wayland";
        CLUTTER_BACKEND = "wayland";
        SDL_VIDEODRIVER = "wayland";
        POLKIT_BIN =
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        XCURSOR_SIZE = "24";
        XCURSOR_THEME = "Bibata-Modern-Ice";
        QT_QPA_PLATFORMTHEME = pkgs.lib.mkDefault "qt5ct";
        QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        MOZ_ENABLE_WAYLAND = "1";
        NIX_PATH = "${homeDir}/.nix-defexpr/channels_root/nixos";
      };

      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
    in {
      packages.x86_64-linux.default =
        fenix.packages.x86_64-linux.minimal.toolchain;
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ({ pkgs, ... }: {
            nixpkgs.overlays = [
              (_: super:
                let pkgs = fenix.inputs.nixpkgs.legacyPackages.${super.system};
                in fenix.overlays.default pkgs pkgs)
            ];
            environment.systemPackages = with pkgs; [
              (fenix.complete.withComponents [
                "cargo"
                "clippy"
                "rust-src"
                "rustc"
                "rustfmt"
              ])
              (with pkgs;
                vscode-with-extensions.override {
                  vscodeExtensions =
                    [ vscode-extensions.rust-lang.rust-analyzer-nightly ];
                })
              rust-analyzer-nightly
            ];
          })
        ];
      };

      # NixOS configuration entrypoint
      # build w/ `nixos-rebuild switch --flake .#ishot`
      nixosConfigurations = {
        ishot = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit self env_vars fenix system inputs version user homeDir host
              globalAliases;
            inherit (inputs.nix-colors.lib-contrib { inherit pkgs; })
              gtkThemeFromScheme;
          };
          modules = [
            # > Our main nixos configuration file <
            ./system/configuration.nix
            inputs.xremap-flake.nixosModules.default

            # > xremap keyboard remapping < 
            {
              services.xremap.withWlroots = true;
              services.xremap.config = {
                # Modmap for single key rebinds
                modmap = [{
                  name = "Global";
                  remap = {
                    "CapsLock" = {
                      held = "KEY_LEFTALT";
                      alone = "CapsLock";
                      alone_timeout_millis = 150;
                    };
                  };
                }];

                # Keymap for key combo rebinds
                keymap = [
                  {
                    name = "Example ctrl-u > pageup rebind";
                    remap = { "C-Esc" = "PAGEUP"; };
                  }
                  {
                    # Rebind shift+escape to tilda
                    name = "Shift+Esc > Tilda";
                    remap = { "SHIFT_L-Esc" = "KEY_GRAVE"; };
                  }
                  {
                    # Rebind shift+escape to tilda
                    name = "Shift+Esc > Tilda";
                    remap = { "C_L-SHIFT_L-Esc" = "C-SHIFT-KEY_GRAVE"; };
                  }
                ];
              };
            }

          ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # build w/ `home-manager switch --flake .#jules@ishot`
      homeConfigurations = {
        "jules@ishot" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;

          extraSpecialArgs = {
            inherit inputs env_vars outputs pkgs version user host homeDir
              globalAliases waybarStyle theme helix;
          };

          # > Our main home-manager configuration file <
          modules = [
            ./home-manager/home.nix

          ];
        };
      };
    };
}
