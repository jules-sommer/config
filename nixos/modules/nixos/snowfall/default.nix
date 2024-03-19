{ config, lib, pkgs, ... }:
with lib;
with lib.jules;
let
  cfg = config.jules.flake;
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.jules) mkBoolOpt;
in {
  options.jules.flake = {
    thaw = {
      enable = mkEnableOption "Whether or not to enable Snowfallorg Thaw.";
    };
    flake-cli = {
      enable = mkEnableOption "Whether or not to enable Snowfallorg Flake CLI.";
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      (mkIf cfg.thaw.enable snowfallorg.thaw)
      (mkIf cfg.flake-cli.enable snowfallorg.flake)
    ];
  };
}
