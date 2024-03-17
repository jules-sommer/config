{ lib, config, pkgs, ... }:

let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.jules) mkOpt enabled;

  cfg = config.jules.apps.monero;
in {
  options.jules = {
    apps.monero = {
      enable = mkEnableOption
        "Whether or not to enable torrenting utils in home-manager.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      monero-gui
      monero-cli
      electrum
      electrum-ltc
      libsForQt5.kleopatra
      p2pool
      xmrig
      gnupg
      pinentry-qt
      gpg-tui
      gpa
      enc
    ];
  };
}
