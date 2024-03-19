{ options, config, pkgs, lib, inputs, ... }:
with lib;
with lib.jules;
let
  cfg = config.jules.virtualisation.containers.podman;
  inherit (lib) mkEnableOption mkIf mkDefault mkMerge;
  inherit (lib.jules) mkOpt enabled joinStrings;
  inherit (lib.types) listOf str;
in {
  options.jules.virtualisation.containers = with lib.types; {
    enable = mkOpt bool false "Enable Podman and related services";
    podman = {
      enable = mkOpt bool false "Enable Podman";
      rootless = mkOpt bool false "Enable rootless Podman";
      apps = {
        tui = mkOpt bool false "Enable TUI";
        desktop = mkOpt bool false "Enable desktop integration";
        pods = mkOpt bool false "Enable pod management";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      podman
      podman-compose
      podman-tui
      podman-desktop
      pods
    ];

    virtualisation.containers.enable = cfg.enable;

    virtualisation.containers.cdi.dynamic.nvidia.enable = true;
    virtualisation.podman = { enable = true; };

    systemd.user.services.podman = {
      enable = true;
      description = "Podman system service";
      wantedBy = [ "default.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.podman}/bin/podman system service";
        Restart = "on-failure";
      };
    };

    users.users.rootless = {
      isNormalUser = true;
      extraGroups = [ "rootless" ];
    };
  };
}
