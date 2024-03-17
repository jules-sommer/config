{ options, config, pkgs, lib, inputs, ... }:
with lib;
with lib.jules;
let
  cfg = config.jules.virtualisation.containers.docker;
  inherit (lib) mkEnableOption mkIf mkMerge;
  inherit (lib.jules) mkOpt enabled joinStrings;
  inherit (lib.types) listOf str;
in {
  options.jules.virtualisation.containers.docker = with lib.types; {
    enable = mkOpt bool false "Enable Docker";
    rootless = mkOpt bool false "Enable rootless Docker";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      docker
      docker-compose
      docker-client
    ];

    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
      rootless = {
        enable = cfg.rootless;
        package = pkgs.docker;
      };
    };

    environment.variables = mkMerge [
      {
        DOCKER_BUILDKIT = "1";
        DOCKER_CLI_EXPERIMENTAL = "enabled";
      }
      (mkIf cfg.rootless {
        DOCKER_HOST = "unix:///run/user/$(id -u)/docker.sock";
      })
    ];

  };
}
