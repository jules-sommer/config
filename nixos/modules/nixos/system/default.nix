{ lib, config, inputs, ... }:

let
  inherit (lib) types mkIf;
  inherit (lib.xeta) mkOpt;
  username = config.xeta.user.name;
  home = config.xeta.user.home;
  hostname = config.xeta.hostname;
  cfg = config.xeta.system;
in {
  options.xeta.system = {
    hostname = mkOpt (types.string) "xeta" "System hostname.";
    stateVersion = mkOpt (types.string) "23.11" "State version.";
  };

  config = {
    homes.users."${username}@${hostname}" = {
      modules = with inputs; [
        nixvim.homeManagerModules.nixvim
        hyprland.homeManagerModules.default
      ];
    };

    qt = {
      enable = true;
      platformTheme = "qt5ct";
      style = "adwaita-dark";
    };

    # Refers to home-manager config, here we are just
    # enabling and setting basic config.
    snowfallorg.user.${username}.home.config = {
      programs.home-manager.enable = true;
      home.username = username;
      home.homeDirectory = home;
      home.stateVersion = cfg.stateVersion;
    };

    system.stateVersion = cfg.stateVersion;
  };
}
