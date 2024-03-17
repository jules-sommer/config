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
    utils = { metasploit = enabled; };
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

  ########################################
  ################ USER ##################
  ########################################

  environment = {

    # TODO: Organize, organize, organize!!
    # all of these should really be separate modules based on
    # group of functionality or if a certain package requires
    # more config than just enabling it, can be individual.

    systemPackages = with pkgs; [
      micro
      # home-manager
      helix
      broot
      zellij
      gleam

      inputs.nix-software-center.packages.${system}.nix-software-center

      nixfmt
      obsidian

      readarr
      ebook_tools
      papeer
      bookworm
      calibre
      foliate
      bk

      jetbrains-mono
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

      grim
      qt5.qtwayland
      slurp
      swaybg
      wl-clipboard
      luakit

      # langs
      git
      gh
      neofetch
      glibc
      uclibc
      cmake
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
      jetbrains.idea-ultimate

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

      apx
      networkmanagerapplet

      # rnix-lsp

      polkit_gnome

      xorg.xkbcomp
      xbindkeys

      virt-viewer

      xorg.xwininfo
      wget
      curl
      xclip
      zlib
      ntfs3g

      lcsync
      librespot
      libresprite
      librecad
      librepcb
    ];

    # FIXME: Better handling of environment variables is needed
    # namely, should be able to set default and additional variables
    # and it should be done consistently across the system

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
