{ lib, config, pkgs, ... }:
let cfg = config.xeta.home.apps.development.jetbrains;
in {
  options.xeta.home.apps.development.jetbrains = {
    enable = lib.mkEnableOption "Enable JetBrains IDEs";
    edition = lib.mkOption {
      type = lib.types.enum [ "community" "ultimate" ];
      default = "community";
      description = "The edition of JetBrains IDE to install";
    };
  };

  config = let
    optionalPkgs = with pkgs;
      (if cfg.edition == "community" then [
        jetbrains.pycharm-community
        jetbrains.intellij-idea-community
      ] else [
        jetbrains.pycharm-professional
        jetbrains.intellij-idea-ultimate
      ]);
  in lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        jetbrains.rust-rover
        jetbrains.pycharm-community
        jetbrains.pycharm-professional
        jetbrains.goland
        jetbrains.clion
      ] ++ optionalPkgs;
  };
}
