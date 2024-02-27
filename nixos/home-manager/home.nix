{ inputs, pinix, lib, pkgs, homeDir, helix, env_vars, user, version
, globalAliases, theme, ... }: {
  # You can import other home-manager modules here
  imports = [
    inputs.nix-colors.homeManagerModule
    inputs.hyprland.homeManagerModules.default

    ./qt-gtk.nix
    ./hyprconf/hypr.nix
    ./hyprconf/rofi.nix
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
      permittedInsecurePackages = [ "electron-25.9.0" ];
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
    qutebrowser
    vlc
    monero-gui
    qbittorrent
    lmms
    steam
    adementary-theme
    catppuccin-cursors
    catppuccin
    bibata-cursors
    whitesur-icon-theme
    whitesur-gtk-theme
    oh-my-posh
    pueue
    swayimg

    udisks
    udiskie

    httpie
    curlie

    runelite

    discord-canary
    vesktop
    betterdiscordctl

    # https://lib.rs/crates/pinix
    pinix

    # JetBrains
    jetbrains.rust-rover
    jetbrains.pycharm-community
    jetbrains.pycharm-professional
    jetbrains.goland
    jetbrains.clion

    # pdf reader
    libreoffice-qt
    zathura

    tor-browser
    torsocks
    tor

    woeusb
    ventoy-full
    unetbootin

    vmware-workstation

    # appimages
    appimage-run
    appimagekit

    # obs
    # obs-studio # apparently wrappedOBS comes with obs-studio package
    obs-do
    obs-cli
    qt5.full
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        input-overlay
        waveform
        obs-websocket
      ];
    })

    # signal stuffs
    signal-export
    signal-desktop
    signalbackup-tools

    localsend

    # pipewire
    helvum

    youtube-tui
    gitui

    # screenshots stuffs
    grim
    slurp
    sox

    # Fonts
    jetbrains-mono
    fira-code
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })

    sway
    apt

    cargo
    clippy
    rustc
    rustfmt
    rust-analyzer

    github-desktop
    protonvpn-gui
    protonvpn-cli
    rye
    flyctl

    dolphin
    wofi
    waybar
    swww
    swaynotificationcenter
    rofi-wayland
    swaylock
    element-desktop
    yazi
    discord-canary

    swayidle
    screenkey

    # nixpkgs
    cachix
    nil
    nix-info
    nixpkgs-fmt
    nixci

    ollama
  ];

  # wayland.windowManager.hyprland.enable = true;

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  # Enable the user's custom fonts
  fonts.fontconfig.enable = true;

  services.lorri.enable = true;

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

    yazi = {
      enable = true;
      enableNushellIntegration = true;
      settings = {
        manager = {
          show_hidden = true;
          sort_dir_first = true;
          linemode = "size";
        };
        manager = {
          ratio = [ 1 4 3 ];
          sort_by = "alphabetical";
          sort_sensitive = false;
          sort_reverse = false;
          show_symlink = true;
        };
        preview = {
          tab_size = 2;
          max_width = 600;
          max_height = 900;
          cache_dir = "";
          image_filter = "triangle";
          image_quality = 75;
          sixel_fraction = 15;
          ueberzug_scale = 1;
          ueberzug_offset = [ 0 0 0 0 ];
        };
        tasks = {
          micro_workers = 10;
          macro_workers = 25;
          bizarre_retry = 5;
          image_alloc = 536870912; # 512MB
          image_bound = [ 0 0 ];
          suppress_preload = false;
        };
      };
    };
    # Alacritty @ ~/_dev/.config/alacritty/[...]
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
            family = "JetBrains Mono Nerd Font";
            style = "Regular";
          };
          bold = {
            family = "JetBrains Mono Nerd Font";
            style = "Bold";
          };
          italic = {
            family = "JetBrains Mono Nerd Font";
            style = "Italic";
          };
          bold_italic = {
            family = "JetBrains Mono Nerd Font";
            style = "Bold Italic";
          };
        };
        selection = { save_to_clipboard = true; };
      };
    };
    nixvim = {
      enable = true;
      enableMan = true;
      colorschemes = {
        catppuccin = {
          enable = true;
          flavour = "mocha";
        };
      };
      plugins.lsp.servers = {
        rust-analyzer = {
          enable = true;
          package = pkgs.rust-analyzer;
          autostart = true;
        };
      };
    };
    helix = {
      enable = true;
      package = helix.packages."x86_64-linux".default;
      defaultEditor = true;
      settings = {
        theme = "github_dark_high_contrast";
        editor.cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
      };
      languages.language = [
        {
          name = "rust";
          comment-token = "//";
          auto-format = true;
          formatter.command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        }
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
        }
        {
          name = "html";
          indent = {
            tab-width = 2;
            unit = "  ";
          };
          language-servers = [ "emmet-ls" ];
          formatter = {
            command = "emmet-ls";
            args = [ "--stdin" ];
          };
        }
        {
          name = "css";
          indent = {
            tab-width = 2;
            unit = "  ";
          };
          language-servers = [ "css-languageserver" ];
          formatter = {
            command = "css-languageserver";
            args = [ "--stdin" ];
          };
        }
        {
          name = "json";
          indent = {
            tab-width = 2;
            unit = "  ";
          };
          language-servers = [ "json-languageserver" ];
          formatter = {
            command = "json-languageserver";
            args = [ "--stdin" ];
          };
        }
        {
          name = "go";
          scope = "source.go";
          injection-regex = "go";
          file-types = [ "go" ];
          roots = [ "Gopkg.toml" "go.mod" ];
          auto-format = true;
          comment-token = "//";
          language-servers = [ "gopls" ];
          indent = {
            tab-width = 4;
            unit = "	";
          };
        }
        {
          name = "astro";
          language-servers = [ "astro-ls" ];
          formatter = {
            command = "astro-ls";
            args = [ "--stdin" ];
          };
        }
        {
          name = "typescript";
          language-servers = [ "deno" ];
        }
      ];
      languages.language-server = {
        rust = {
          config = {
            check = {
              command = "clippy";
              features = "all";
            };
            diagnostics = { experimental = { enable = true; }; };
            hover = { actions = { enable = true; }; };
            typing = { "autoClosingAngleBrackets" = { enable = true; }; };
            cargo = { "allFeatures" = true; };
            procMacro = { enable = true; };
          };
        };
        "emmet-ls" = {
          command = "emmet-ls";
          args = [ "--stdio" ];
        };
        "css-languageserver" = {
          command = "css-languageserver";
          args = [ "--stdio" ];
        };
        "json-languageserver" = {
          command = "json-languageserver";
          args = [ "--stdio" ];
        };
        gopls = {
          command = "gopls";
          args = [ "" ];
        };
        "astro-ls" = {
          command = "astro-ls";
          args = [ "--stdio" ];
        };
        deno = {
          command = "deno";
          args = [ "lsp" ];
        };
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
