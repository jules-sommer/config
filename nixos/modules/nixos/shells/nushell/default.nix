{ lib, config, pkgs, ... }:
let
  inherit (lib) types;
  inherit (lib.xeta) mkOpt;
  cfg = config.xeta.system.shells.nushell;
in {
  options.xeta.system.shells.nushell = {
    enable =
      lib.mkEnableOption "Enable nushell, a modern shell written in Rust.";
    aliases = mkOpt (types.attrsOf types.str) { } "Shell aliases for nushell.";
    rootDir = mkOpt types.path;
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ nushell alacritty kitty ];
    programs.nushell = {
      configFile.source = "${cfg.rootDir}/_dev/.config/nushell/config.nu";
      envFile.source = "${cfg.rootDir}/_dev/.config/nushell/env.nu";
      loginFile.source = "${cfg.rootDir}/_dev/.config/nushell/login.nu";
      environmentVariables = {
        # Add personal environment variables here
      };
      shellAliases = cfg.aliases;
    };
  };
}

