{ lib, inputs, config, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf types mkOption;
  inherit (lib.jules) enabled mkOpt mkListOf;

  cfg = config.jules.gitea or [ ];
in {
  options.jules.gitea = with types; {
    enable = mkOpt bool false "Enable Gitea";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ gitea ];
    services.gitea = {
      enable = true;
      package = pkgs.gitea;
    };
  };
}

