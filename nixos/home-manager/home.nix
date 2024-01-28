{ inputs, lib, config, pkgs, homeDir, user, version, globalAliases, ... }: {
  # You can import other home-manager modules here
  imports = [ inputs.nix-colors.homeManagerModule ./qt-gtk.nix ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays here
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  programs.home-manager.enable = true;
  home.username = user;
  home.homeDirectory = homeDir;
  home.stateVersion = version;
  home.packages = with pkgs; [
    firefox
    vlc
    monero-gui
    qbittorrent
    adementary-theme
    vscode-extensions.catppuccin.catppuccin-vsc
    catppuccin-papirus-folders
    catppuccin-cursors
    catppuccin
    bibata-cursors
    whitesur-icon-theme
    whitesur-gtk-theme
    oh-my-posh
    discord
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })

    gnomeExtensions.arcmenu
    gnomeExtensions.dash-to-panel
    gnomeExtensions.dash-to-dock
    gnomeExtensions.vitals
    gnomeExtensions.pano
    gnomeExtensions.tiling-assistant
    gnomeExtensions.tray-icons-reloaded

    ollama

    gnome.gnome-tweaks
    gnome-browser-connector
    gnome.gnome-shell-extensions
  ];

  # wayland.windowManager.hyprland.enable = true;

  # Configuration for all programs in /home/jules
  programs = {
    # NuShell Config
    nushell = {
      configFile.source = "${homeDir}/_dev/.config/nushell/config.nu";
      envFile.source = "${homeDir}/_dev/.config/nushell/env.nu";
      loginFile.source = "${homeDir}/_dev/.config/nushell/login.nu";
      environmentVariables = {
        XDG_CONFIG_HOME = "${homeDir}/_dev/.config";
        NIXPKGS_ALLOW_UNFREE = "1";
      };
      shellAliases = [ globalAliases ] ++ [
        # add personal non-sys aliases here
      ];
    };
    alacritty = {
      enable = true;
      settings = {
        window = {
          opacity = 0.85;
          blur = true;
          padding = {
            x = 10;
            y = 10;
          };
          dimensions = {
            lines = 65;
            columns = 125;
          };
        };
        font = {
          size = 12;
          builtin_box_drawing = true;
          normal = {
            family = "JetBrains Mono, monospace";
            style = "Regular";
          };
          bold = {
            family = "JetBrains Mono, monospace";
            style = "Bold";
          };
          italic = {
            family = "JetBrains Mono, monospace";
            style = "Italic";
          };
          bold_italic = {
            family = "JetBrains Mono, monospace";
            style = "Bold Italic";
          };
        };
        selection = { save_to_clipboard = true; };
        key_bindings = [{
          key = "K";
          mods = "Control";
          chars = "\\x0c";
        }];
      };
    };
    starship = {
      enable = true;
      package = pkgs.starship;
    };
    # Git Config
    git = {
      enable = true;
      userName = "julessommer";
      userEmail = "jules@rcsrc.shop";
    };
    # broot.enableNushellIntegration = true;
  };
  # Create XDG Dirs
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}
