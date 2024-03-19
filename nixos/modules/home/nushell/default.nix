{ lib, inputs, config, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf types mkOption;
  inherit (lib.jules) enabled mkOpt mkListOf;

  cfg = config.jules.shells.nushell or [ ];
in {
  options.jules.shells.nushell = with types; {
    enable = mkEnableOption
      "Enable handy Rust CLI utilities system-wide (e.g. ripgrep, fd-find, exa, bat, etc.)";
  };

  config = mkIf cfg.enable { home.packages = with pkgs; [ ]; };
}
