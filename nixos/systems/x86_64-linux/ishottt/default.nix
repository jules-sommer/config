{ lib, pkgs, inputs, system, target, format, virtual, systems, config, ... }:
with lib.jules;
let inherit (lib.jules) enabled;
in {
  imports = [ ./hardware-configuration.nix ];

  jules = {
    electron-support = enabled;
    nix-ld = enabled;
    portals = {
      enable = true;
      extraPortals = {
        hyprland = true;
        gtk = true;
        wlroots = true;
      };
    };
    virtualisation = {
      enable = true;
      containers = {
        enable = true;
        podman = {
          enable = true;
          rootless = true;
        };
        docker = {
          enable = true;
          rootless = true;
        };
      };
    };
    nix = {
      warn-dirty = false;
      experimental-features = [
        "nix-command flakes configurable-impure-env auto-allocate-uids verified-fetches fetch-tree fetch-closure impure-derivations dynamic-derivations"
      ];
      auto-optimise-store = true;
    };
    graphics = {
      opengl = true;
      drivers = [ "nouveau" ];
    };
    flake = {
      thaw = enabled;
      flake-cli = enabled;
    };
    systemd = {
      wireguard = {
        enable = true;
        interfaces = [{
          autostart = true;
          name = "US-NY-301";
          address = "10.2.0.2/32";
          privateKey = "iKYkmILj6cHORqzciADuPcIeQI73crlJC9/uQGHkHFs=";
          port = 51820;
          dns = [ "10.2.0.1" ];
          endpoint = {
            publicKey = "L/lAxBloXzDXNrWw1xtJgEMJWPct1reKQPkRsw/7Knw=";
            ip = "104.234.212.26";
            port = 51820;
          };
        }];
      };
    };
  };

  boot = {
    # supportedFilesystems = [ "zfs" ];
    zfs.forceImportRoot = false;
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
        editor = false;
        netbootxyz.enable = true;
        memtest86.enable = true;
      };
      efi.canTouchEfiVariables = true;
    };
    plymouth = {
      enable = true;
      font =
        "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
    };
  };

  # ---------
  # SERVICES
  # ---------
  services = {
    xserver = {
      enable = true;
      autoRepeatDelay = 200;
      autoRepeatInterval = 30;
      autorun = true;

      xkb = {
        layout = "us";
        variant = "";
      };

      libinput.enable = true;
      displayManager = {
        lightdm.enable = false;
        defaultSession = "hyprland";
        gdm = {
          enable = true;
          wayland = true;
        };
      };

      desktopManager = {
        gnome.enable = false;
        xterm.enable = false;
      };

    };

    openssh.enable = true;
    fstrim.enable = true;

    # Enable CUPS to print documents.
    printing.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true; # For JACK app support
    };

    tumbler.enable = true; # Thumbnail support for images and videos
    gvfs.enable = true;
  };

  hardware.pulseaudio.enable = false;
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  users.defaultUserShell = pkgs.nushell;

  users.users.${settings.user} = {
    isNormalUser = true;
    homeMode = "755";
    ignoreShellProgramCheck = true;
    description = "Jules";
    extraGroups = [
      "networkmanager"
      "wheel"
      "vboxusers"
      "docker"
      "libvirtd"
      "fuse"
      "rootless"
    ];
    useDefaultShell = true;
  };

  # Theme QT -> GTK
  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "adwaita-dark";
  };

  ########################################
  ################ USER ##################
  ########################################

  environment = {
    systemPackages = with pkgs; [
      micro
      # home-manager
      helix
      broot
      zellij

      inputs.nix-software-center.packages.${system}.nix-software-center

      nixfmt
      obsidian

      jetbrains-mono
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

      grim
      qt5.qtwayland
      slurp
      swaybg
      wl-clipboard
      luakit

      git
      gh
      neofetch
      glibc.dev
      glib.dev
      glibc
      uclibc
      cmake
      pkg-config
      gdk-pixbuf
      atkmm
      pango
      gtk4
      gtk3
      gtkmm3
      gobject-introspection
      atk
      cairo

      # langs
      hexyl
      binutils
      clang-tools
      nixpkgs-fmt
      shfmt
      ouch
      python3.pkgs.black
      pyright
      nil
      gcc
      zlib
      clang
      lld
      libclc
      llvm
      llvmPackages_17.clang
      llvmPackages_17.lld
      llvmPackages_17.libclc
      llvmPackages_17.llvm
      nodejs
      bun
      go
      rustup
      strace
      psmisc
      glibcLocales
      gdb

      htop
      rustscan
      alacritty
      alacritty-theme
      bitwarden
      nushell
      librewolf
      firefox
      # vscode

      jetbrains-mono
      fira-code
      vscode-with-extensions

      virtualbox
      linuxKernel.packages.linux_zen.virtualbox
      qemu
      libvirt

      # Langs
      python3
      cmake
      gnumake
      ninja
      gdb
      ant
      maven
      jekyll
      gcc

      # rustup vscode-extensions.rust-lang.rust-analyzer clippy rustc rustfmt rust-analyzer
      # rustup cargo

      llvm
      lld
      lldb

      # Utils
      direnv
      git
      tree
      nox
      htop
      atool
      busybox
      psmisc
      unrar
      zip
      unzip
      ark
      linuxPackages.perf
      patchelf
      aspell
      aspellDicts.en
      binutils
      exfat
      asciidoctor
      jumpapp
      swaynotificationcenter

      pkgs.libsForQt5.qt5.qtgraphicaleffects
      font-awesome

      # Rust stuff
      ripgrep
      jq
      jqp
      eza
      fd
      tokei
      bat
      poppler
      ffmpegthumbnailer
      ffmpeg
      unar
      xz
      jq
      fd
      jql
      jq-lsp
      zoxide

      grim
      grimblast
      slurp

      rnix-lsp

      polkit_gnome

      xorg.xkbcomp
      xbindkeys

      libvirt
      virt-viewer

      xorg.xwininfo
      wget
      curl
      xclip
      zlib
      ntfs3g

    ];
    # Set the environment variables
    variables = {
      FLAKE = "${settings.home}/_dev/.config/nixos";
      POLKIT_BIN =
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    };
  };

  systemd = {
    network.wait-online.enable = false;
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  # Fonts
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;

    packages = with pkgs; [ ubuntu_font_family jetbrains-mono fira-code ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Ubuntu" ];
        sansSerif = [ "Ubuntu" ];
        monospace = [ "JetBrains Mono Nerd Font" ];
      };
    };
  };
  # TODO: Should settings for programs colocated with the
  # module that enables them. Same for all things basically.

  programs = {
    wshowkeys.enable = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    thunar = { enable = true; };
    xfconf.enable = true;
    virt-manager.enable = true;
    sway.enable = true;
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      xwayland.enable = true;
    };
    dconf.enable = true;
    steam.gamescopeSession.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };

  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  security.polkit.enable = true;
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.enable = false;

  system.stateVersion =
    "24.05"; # Did you read the comment? Don't change this unless you know what you're doing.
}
