{ lib, config, ... }:

let
  inherit (lib) types mkIf;
  inherit (lib.xeta) mkOpt;

  cfg = config.xeta.system;
in {
  options.xeta.system = {
    hostname = mkOpt (types.str) "xeta" "System hostname.";
    stateVersion = mkOpt (types.float) 23.11 "State version.";
  };

  config = {
    # Refers to home-manager config, here we are just
    # enabling and setting basic config.
    snowfallorg.user.${config.xeta.user.name}.home.config = {
      programs.home-manager.enable = true;
      home.username = config.xeta.user.name;
      home.homeDirectory = config.xeta.user.home;
      home.stateVersion = cfg.stateVersion;
    };
    system.stateVersion = cfg.stateVersion;
  };
}
