{ config, lib, pkgs, ... }:
let
  inherit (lib) mkOpt types;
  cfg = config.xeta.system.environment;
  default = {
    variables = {
      HOME = "/home/jules";
      XDG_CONFIG_HOME = "/home/jules/_dotfiles";
      XDG_DATA_HOME = "/home/jules/_data";
      XDG_CACHE_HOME = "/home/jules/_cache";
      POLKIT_BIN =
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    };
  };
in with lib; {
  options.xeta.system.environment = {
    variables = mkOpt (attrsOf (either str (listOf str))) default
      "Environment variables to set";
  };

  config = {
    environment = { variables = default // cfg.variables; };
    snowfallorg.user.xeta.home.config = {
      sessionVariables = default // cfg.variables;
    };
  };

}
