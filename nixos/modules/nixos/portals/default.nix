{ lib, config, pkgs, ... }:
let
  inherit (lib) types;
  inherit (lib.xetamine) mkOpt;
  cfg = config.xeta.system.portals;
in {
  options.xeta.system.portals = {
    enable = lib.mkEnableOption
      "Enable various XDG portals for desktop environment app compatibility.";
  };

  isHyprland = config.users.users.xeta.home.windowManager.hyprland;

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
  };
}

