{ lib, config, pkgs, ... }:
let
  inherit (lib) types mkOpt mkIf;
  inherit (lib.xeta) mkEnableOption;
  cfg = config.xeta.system.git;
in {
  options.xeta.system.git = {
    enable = mkEnableOption "Enable basic git capabilities.";
    extensions = {
      graphite = mkEnableOption "Enable graphite-cli";
      tui = mkEnableOption "Enable Lazygit and Gitui TUI clients.";
      gix = mkEnableOption "Enable gitoxide (gix) CLI.";
      jujutsu = mkEnableOption "Enable jujutsu (jj) CLI.";
    };
  };

  config = let
    extensions = [
      (cfg.extensions.graphite && pkgs.graphite-cli)
      (cfg.extensions.tui && [ pkgs.lazygit pkgs.gitui ])
      (cfg.extensions.gix && pkgs.gitoxide)
      (cfg.extensions.jujutsu && pkgs.jujutsu)
    ];
  in mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ git ] ++ extensions;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    git = {
      enable = true;
      userName = "jule-ssommer";
      userEmail = config.xeta.user.email;
    };
  };
}
