{ config, lib, inputs, system, pkgs, ... }:
let
  inherit (lib) mkOpt types mkIf;
  cfg = config.xeta.home.apps.gnome;
in {
  options.xeta.home.apps.gnome = {
    enable = lib.mkEnableOption "Enable GNOME applications";
    profile = mkOpt (types.enum [ "minimal" "full" ]) "minimal"
      "GNOME applications profile, must be either 'minimal' or 'full'.";
  };

  config = let
    minimal = with pkgs; [
      gnome.gnome-eog
      gnome.gnome-keyring
      gnome.gnome-font-viewer
      gnome-multi-writer
      gnome.gnome-disk-utility
      gnome.gnome-calculator
      gnome.gnome-nettools
      gnome.gnome-logs
    ];
    full = with pkgs; [
      gnome.gnome-maps
      gnome.gnome-weather
      gnome.gnome-contacts
      gnome.gnome-calendar
      gnome.nautilus
    ];
    gnomePkgs = minimal ++ (mkIf (cfg.profile == "full") full);
  in mkIf cfg.enable { home.packages = gnomePkgs; };
}
