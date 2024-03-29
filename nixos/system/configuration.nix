{ inputs, lib, config, pkgs, host, env_vars, user, version, ... }: {

  imports = [ ./hardware-configuration.nix ./nvidia_drivers.nix ];

  nixpkgs = {
    overlays = [
      # If you want to use overlays exported from other flakes:

      # Inline overlays:
      (final: prev: {
        # Override for using Vscode Insiders edition, basically nightly/unstable release instead
        vscode-with-extensions =
          (prev.vscode.override { isInsiders = true; }).overrideAttrs
          (oldAttrs: rec {
            src = (builtins.fetchTarball {
              url =
                "https://update.code.visualstudio.com/latest/linux-x64/insider";
              sha256 = "0z3gir3zkswcyxg9l12j5ldhdyb0gvhssvwgal286af63pwj9c66";
            });
            version = "latest";
          });
      })
    ];
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      permittedInsecurePackages = [ "electron-25.9.0" ];
    };
  };

  # Additional optimizations below from this nix-starter config
  # https://github.com/Misterio77/nix-starter-configs/blob/main/minimal/nixos/configuration.nix

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: { inherit flake; }))
    ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = [ "/home/jules/.nix-defexpr/channels_root/nixos" ];
  environment.etc = lib.mapAttrs' (name: value: {
    name = "/home/jules/.nix-defexpr/channels_root/nixos/${name}";
    value.source = value.flake;
  }) config.nix.registry;

  # Configure the Nix package manager
  nix = {
    settings = {
      warn-dirty = false;
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
      # Use binary caches
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
  };

  # Configure the bootloader
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

  networking.hostName = host;
  networking.networkmanager.enable = true;
  networking.hostId = "bd744803";

  # NETWORKING TWEAKS
  # (source: https://github.com/nh2/nixos-configs/blob/master/configuration.nix)

  # Hibernation with ZFS is unsafe; thus disable it.
  # This is likely the case even if the swap is put on a non-ZFS partition,
  # because the ZFS code paths do not handle being hibernated properly.
  # See:
  # * https://nixos.wiki/wiki/ZFS#Known_issues
  # * https://github.com/openzfs/zfs/issues/12842
  # * https://github.com/openzfs/zfs/issues/12843
  boot.kernelParams = [ "nohibernate" ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable BBR congestion control
  boot.kernelModules = [ "tcp_bbr" ];
  boot.kernel.sysctl."net.ipv4.tcp_congestion_control" = "bbr";
  boot.kernel.sysctl."net.core.default_qdisc" =
    "fq"; # see https://news.ycombinator.com/item?id=14814530

  # Increase TCP window sizes for high-bandwidth WAN connections, assuming
  # 10 GBit/s Internet over 200ms latency as worst case.
  #
  # Choice of value:
  #     BPP         = 10000 MBit/s / 8 Bit/Byte * 0.2 s = 250 MB
  #     Buffer size = BPP * 4 (for BBR)                 = 1 GB
  # Explanation:
  # * According to http://ce.sc.edu/cyberinfra/workshops/Material/NTP/Lab%208.pdf
  #   and other sources, "Linux assumes that half of the send/receive TCP buffers
  #   are used for internal structures", so the "administrator must configure
  #   the buffer size equals to twice" (2x) the BPP.
  # * The article's section 1.3 explains that with moderate to high packet loss
  #   while using BBR congestion control, the factor to choose is 4x.
  #
  # Note that the `tcp` options override the `core` options unless `SO_RCVBUF`
  # is set manually, see:
  # * https://stackoverflow.com/questions/31546835/tcp-receiving-window-size-higher-than-net-core-rmem-max
  # * https://bugzilla.kernel.org/show_bug.cgi?id=209327
  # There is an unanswered question in there about what happens if the `core`
  # option is larger than the `tcp` option; to avoid uncertainty, we set them
  # equally.
  boot.kernel.sysctl."net.core.wmem_max" = 1073741824; # 1 GiB
  boot.kernel.sysctl."net.core.rmem_max" = 1073741824; # 1 GiB
  boot.kernel.sysctl."net.ipv4.tcp_rmem" = "4096 87380 1073741824"; # 1 GiB max
  boot.kernel.sysctl."net.ipv4.tcp_wmem" = "4096 87380 1073741824"; # 1 GiB max
  # We do not need to adjust `net.ipv4.tcp_mem` (which limits the total
  # system-wide amount of memory to use for TCP, counted in pages) because
  # the kernel sets that to a high default of ~9% of system memory, see:
  # * https://github.com/torvalds/linux/blob/a1d21081a60dfb7fddf4a38b66d9cef603b317a9/net/ipv4/tcp.c#L4116

  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";

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

    # VM Services
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
    spice-webdavd.enable = true;

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

  # Enable sound with pipewire.
  sound.enable = false;
  hardware.pulseaudio.enable = false;
  # rtkit is optional but recommended
  security.rtkit.enable = true;

  users.defaultUserShell = pkgs.nushell;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    homeMode = "755";
    ignoreShellProgramCheck = true;
    description = "Jules";
    extraGroups =
      [ "networkmanager" "wheel" "vboxusers" "docker" "libvirtd" "fuse" ];

    useDefaultShell = true;
  };

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

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
      home-manager
      helix
      broot
      zellij

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
    variables = env_vars // {
      FLAKE = "$\${homeDir}/_dev/.config/nixos";
      POLKIT_BIN =
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    };
  };

  systemd = {
    services.NetworkManager-wait-online.enable = false;
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.

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
    nix-ld = {
      enable = true;
      libraries = with pkgs;
        [
          # libs for dyn linked pkgs
        ];
    };
  };

  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal ];
    configPackages =
      [ pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal ];
  };

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
    version; # Did you read the comment? Don't change this unless you know what you're doing.
}
