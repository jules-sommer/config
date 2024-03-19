{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.jules.portals;
  inherit (pkgs)
    xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-hyprland
    xdg-desktop-portal-wlr;

in {
  options.jules.portals = {
    enable = mkEnableOption "Enable xdg-portal";
    extraPortals = {
      hyprland = mkEnableOption "Enable Hyprland portals";
      gtk = mkEnableOption "Enable GTK portals";
      wlroots = mkEnableOption "Enable wlroots portals";
    };
  };

  config = mkIf cfg.enable {
    xdg.portal.enable = true;
    xdg.portal.extraPortals = [
      (mkIf cfg.extraPortals.gtk xdg-desktop-portal-gtk)
      (mkIf cfg.extraPortals.wlroots xdg-desktop-portal-wlr)
    ];
    xdg.portal.configPackages = [
      (mkIf cfg.extraPortals.hyprland xdg-desktop-portal-hyprland)
      (mkIf cfg.extraPortals.gtk xdg-desktop-portal-gtk)
      (mkIf cfg.extraPortals.wlroots xdg-desktop-portal-wlr)
    ];
  };
}
