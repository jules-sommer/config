{ lib, config, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.jules) enabled;

  cfg = config.jules.electron-support;
in {
  options.jules.electron-support = {
    enable = mkEnableOption "Enable electron support";
  };

  config = mkIf cfg.enable {
    jules.home.configFile."electron-flags.conf".source = ./electron-flags.conf;
    environment.sessionVariables = { NIXOS_OZONE_WL = "1"; };
  };
}

