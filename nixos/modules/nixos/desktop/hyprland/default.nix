{ lib, pkgs, config, inputs, ... }:
let
  inherit (lib) types mkEnableOption mkIf mkOpt;
  cfg = config.xeta.desktop.hyprland;
in {
  options.xeta.desktop.hyprland = {
    enable = mkEnableOption "Enable Fenix overlay of Rust toolchain.";
  };
  config = mkIf cfg.enable {
    hyprland = {
      enable = true;
      package = lib.xeta.getHyprlandPkg;
      xwayland.enable = true;
      enableNvidiaPatches = true;
    };
  };
}
