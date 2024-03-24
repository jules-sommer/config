{ lib, config, pkgs, ... }:
let cfg = config.apps.development.jetbrains;
in {
  options.apps.development.jetbrains = {
    enable = lib.mkEnableOption "Enable JetBrains IDEs";
    edition = lib.mkOption {
      type = lib.types.enum [ "community" "ultimate" ];
      default = "community";
      description = "The edition of JetBrains IDE to install";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.variables = { SNOWFALLORG_EXAMPLE = "enabled"; };
  };
}
