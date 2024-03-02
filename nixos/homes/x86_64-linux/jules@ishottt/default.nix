{ inputs, lib, pkgs, config, ... }:
with lib.jules; {
  # You can import other home-manager modules here
  imports = [ ./qt-gtk.nix ];

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

  programs.home-manager.enable = true;
  home.username = settings.user;
  home.homeDirectory = settings.home;
  home.stateVersion = settings.version;

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
      configFile.source = "${settings.home}/_dev/.config/nushell/config.nu";
      envFile.source = "${settings.home}/_dev/.config/nushell/env.nu";
      loginFile.source = "${settings.home}/_dev/.config/nushell/login.nu";
      environmentVariables = {
        # Add personal environment variables here
      };
      shellAliases = settings.aliases // {
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

    helix = {
      enable = true;
      package = inputs.helix.packages."x86_64-linux".default;
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
