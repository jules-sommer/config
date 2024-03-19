{ lib, pkgs, config, ... }:
let
  inherit (lib) mkEnableOption mkIf types;
  inherit (lib.jules) mkOpt;
  cfg = config.jules.services;
in {
  options.jules.services = {
    enable = mkEnableOption "Enable additional services?";
    xserver = {
      enable = mkEnableOption "Enable X server";
      xkb = {
        layout = mkOpt (types.str) "us" "XKB layout, defaults to: 'us'.";
        variant =
          mkOpt (types.nullOr types.str) "XKB variant, defaults to: null.";
      };
    };
  };

  config = mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;
        autoRepeatDelay = 200;
        autoRepeatInterval = 30;
        autorun = true;
        xautolock.enable = false;

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

      # VM Services
      qemuGuest.enable = true;
      spice-vdagentd.enable = true;
      spice-webdavd.enable = true;

      openssh.enable = true;
      fstrim.enable = true;

      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };

      tumbler.enable = true;
      gnome.gnome-keyring.enable = true;
      blueman.enable = true;

      # Enable CUPS to print documents.
      printing.enable = true;
      gvfs.enable = true;
    };
    programs.gnupg.agent.pinentryPackage = lib.mkForce pkgs.pinentry-gnome3;
    hardware = {
      pulseaudio.enable = false;
      bluetooth.enable = true; # enables support for Bluetooth
      bluetooth.powerOnBoot = true;
    };

    sound.enable = true;
    security.rtkit.enable = true;
    programs.thunar.enable = true;
    security.pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };
  };
}
