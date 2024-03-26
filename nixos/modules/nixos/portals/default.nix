{ lib, config, pkgs, ... }:
let
  inherit (lib) types;
  inherit (lib.xeta) mkOpt;
  isHyprland = config.users.users.xeta.home.windowManager.hyprland;
  cfg = config.xeta.system.portals;
in {
  options.xeta.system.portals = {
    enable = lib.mkEnableOption
      "Enable various XDG portals for desktop environment app compatibility.";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      xdg-utils
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
    xdg = {
      userDirs = {
        enable = true;
        createDirectories = true;
      };
    };
  };
}

