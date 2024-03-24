{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.xeta.system.snowfall;
in {
  options.xeta.system.snowfall = {
    enable = mkEnableOption "Enable Snowfall system packages";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      snowfallorg.drift
      snowfallorg.flake
      snowfallorg.thaw
    ];
  };
}

