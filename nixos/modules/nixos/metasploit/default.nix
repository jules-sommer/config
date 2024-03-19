{ config, pkgs, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf types mkOption;
  inherit (lib.jules) enabled mkOpt mkListOf;
  cfg = config.jules.utils.metasploit;
in {
  options.jules.utils.metasploit = {
    enable = mkOpt types.bool "Enable Metasploit" false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ metasploit armitage ];
  };
}
