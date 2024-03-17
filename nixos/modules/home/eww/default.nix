

{ inputs, lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.jules) enabled mkOpt mkBoolOpt;
  cfg = config.jules.window-manager.hyprland.plugins;
in with lib;
with lib.jules; {
  options = {
    jules.window-manager.hyprland.plugins.eww = mkBoolOpt "Enable eww" false;
  };
  config = mkIf (cfg.eww == true) {
    home.packages = with pkgs; [
      eww
      pamixer
      brightnessctl
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    # configuration
    home.file.".config/modules/home/eww/eww.scss".source = ./eww.scss;
    home.file.".config/modules/home/eww/eww.yuck".source = ./eww.yuck;

    # scripts
    home.file.".config/modules/home/eww/scripts/battery.sh" = {
      source = ./scripts/battery.sh;
      executable = true;
    };

    home.file.".config/modules/home/eww/scripts/wifi.sh" = {
      source = ./scripts/wifi.sh;
      executable = true;
    };

    home.file.".config/modules/home/eww/scripts/brightness.sh" = {
      source = ./scripts/brightness.sh;
      executable = true;
    };

    home.file.".config/modules/home/eww/scripts/workspaces.sh" = {
      source = ./scripts/workspaces.sh;
      executable = true;
    };

    home.file.".config/modules/home/eww/scripts/workspaces.lua" = {
      source = ./scripts/workspaces.lua;
      executable = true;
    };
  };
}
