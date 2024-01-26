{ inputs, lib, config, pkgs, homeDir, globalAliases, ... }: {
  # You can import other home-manager modules here
  imports = [ inputs.nix-colors.homeManagerModule ];

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

    gnomeExtensions.arcmenu
    gnomeExtensions.dash-to-panel
    gnomeExtensions.dash-to-dock
    gnomeExtensions.vitals
    gnomeExtensions.pano
    gnomeExtensions.tiling-assistant
    gnomeExtensions.tray-icons-reloaded

    gnome.gnome-tweaks
    gnome-browser-connector
    gnome.gnome-shell-extensions
  ];

  gtk = {
    iconTheme = {
      name = "Whitesur-icon-theme";
      package = pkgs.whitesur-icon-theme;
    };
    theme = {
      name = "Whitesur-gtk-theme";
      package = pkgs.whitesur-gtk-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 36;
    };
  };

  # wayland.windowManager.hyprland.enable = true;

  # Configuration for all programs in /home/jules
  programs = {
    # NuShell Config
    nushell = {
      configFile.source = "${homeDir}/_dev/.config/nushell/config.nu";
      envFile.source = "${homeDir}/_dev/.config/nushell/env.nu";
      loginFile.source = "${homeDir}/_dev/.config/nushell/login.nu";
      environmentVariables = { NIXPKGS_ALLOW_UNFREE = "1"; };
      shellAliases = globalAliases ++ [
        # add personal non-sys aliases here
      ];
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
