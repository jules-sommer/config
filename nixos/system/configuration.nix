{ inputs, lib, config, pkgs, host, user, version, globalAliases, ... }: {

  imports = [ ./hardware-configuration.nix <home-manager/nixos> ];

  nixpkgs = {
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Inline overlays:
      (final: prev: {
        # Override for using Vscode Insiders edition, basically nightly/unstable release instead
        vscode.package =
          (pkgs.vscode.override { isInsiders = true; }).overrideAttrs
          (oldAttrs: rec {
            src = (builtins.fetchTarball {
              url =
                "https://update.code.visualstudio.com/latest/linux-x64/insider";
              sha256 = "1dajhfsdr55mfnj12clf5apy1d4swr71d3rfwlq2hvvmpxvxsa59";
            });
            version = "latest";
          });
      })
    ];
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
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
  nix.nixPath = [ "/etc/nix/path" ];
  environment.etc = lib.mapAttrs' (name: value: {
    name = "nix/path/${name}";
    value.source = value.flake;
  }) config.nix.registry;

  # Configure the Nix package manager
  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
    # Use binary caches
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys =
      [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  # Configure the bootloader
  boot.loader = {
    systemd-boot = {
      enable = true;
      consoleMode = "auto";
      editor = false;
      netbootxyz.enable = true;
      memtest86.enable = true;
    };
    plymouth = {
      enable = true;
      font =
        "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
    };
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = host;
  networking.networkmanager.enable = true;

  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";

  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";
    libinput.enable = true;
    displayManager = {
      lightdm.enable = false;
      gdm = {
        enable = true;
        wayland = true;
      };
    };
    desktopManager = {
      gnome.enable = true;
      xterm.enable = false;
    };
  };

  services.openssh.enable = true;
  services.fstrim.enable = true;

  # Enable XDG Portal for Hyperland
  # xdg.portal = {
  #   enable = true;
  #   extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal ];
  #   configPackages = [
  #     pkgs.xdg-desktop-portal-gtk
  #     pkgs.xdg-desktop-portal-hyprland
  #     pkgs.xdg-desktop-portal
  #   ];
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = false;
  hardware.pulseaudio.enable = false;
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true; # For JACK app support
  };

  users.defaultUserShell = pkgs.nushell;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    description = "Jules";
    extraGroups = [ "networkmanager" "wheel" ];
    useDefaultShell = true;
  };

  # Theme QT -> GTK
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  # hyprland.systemd.enable = true;

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
      rustc
      rustfmt
      rustup
      cargo
      clippy
      nodejs
      bun
      go
      htop
      rustscan
      alacritty
      alacritty-theme
      bitwarden
      nushell
      librewolf
      firefox
      vscode
    ];
    # Set the environment variables
    variables = {
      NIXOS_OZONE_WL = "1";
      NIXPKGS_ALLOW_UNFREE = "1";
      XDG_SESSION_TYPE = "wayland";
      GDK_BACKEND = "wayland";
      CLUTTER_BACKEND = "wayland";
      SDL_VIDEODRIVER = "wayland";
      XCURSOR_SIZE = "24";
      XCURSOR_THEME = "Bibata-Modern-Ice";
      QT_QPA_PLATFORMTHEME = pkgs.lib.mkDefault "qt5ct";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };
  };

  programs.nushell = {
    enable = true;
    package = pkgs.nushell;
    shellAliases = globalAliases;
  };

  # programs.hyprland = {
  #   enable = true;
  #   package = pkgs.hyprland;
  #   xwayland.enable = true;
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.enable = false;

  system.stateVersion =
    version; # Did you read the comment? Don't change this unless you know what you're doing.
}
