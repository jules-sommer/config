{ inputs, lib, pkgs, homeDir, env_vars, user, version, globalAliases, theme, ...
}: {
  # You can import other home-manager modules here
  imports = [
    inputs.nix-colors.homeManagerModule
    inputs.hyprland.homeManagerModules.default

    ./qt-gtk.nix
    ./hyprconf/hypr.nix
    ./hyprconf/waybar.nix
    ./hyprconf/sway.nix
  ];

  nixpkgs = {
    overlays = [
      # Add overlays here
    ];
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # Set nix-colors theme frome flake's input/variable
  colorScheme = inputs.nix-colors.colorSchemes."${theme}";

  programs.home-manager.enable = true;
  home.username = user;
  home.homeDirectory = homeDir;
  home.stateVersion = version;
  home.packages = with pkgs; [
    firefox
    vlc
    monero-gui
    qbittorrent
    lmms
    steam
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

    grim
    slurp
    sway
    apt

    dolphin
    wofi
    waybar
    swww
    swaynotificationcenter
    rofi-wayland
    swaylock
    element-desktop
    yazi

    swayidle
    screenkey

    # nixpkgs
    cachix
    nil # Nix language server
    nix-info
    nixpkgs-fmt
    nixci

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

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  # Configuration for all programs in /home/jules
  programs = {
    # NuShell Config
    nushell = {
      configFile.source = "${homeDir}/_dev/.config/nushell/config.nu";
      envFile.source = "${homeDir}/_dev/.config/nushell/env.nu";
      loginFile.source = "${homeDir}/_dev/.config/nushell/login.nu";
      environmentVariables = env_vars // {
        # Add personal environment variables here
      };
      shellAliases = globalAliases // {
        # add personal non-sys aliases here
        nf = "neofetch --ascii_distro arch";
      };
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
            family = "JetBrains Mono";
            style = "Regular";
          };
          bold = {
            family = "JetBrains Mono";
            style = "Bold";
          };
          italic = {
            family = "JetBrains Mono";
            style = "Italic";
          };
          bold_italic = {
            family = "JetBrains Mono";
            style = "Bold Italic";
          };
        };
        selection = { save_to_clipboard = true; };
      };
    };
    starship = {
      enable = true;
      package = pkgs.starship;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    git = {
      enable = true;
      userName = "jule-ssommer";
      userEmail = "jules@rcsrc.shop";
    };
  };
  # Create XDG Dirs
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}
