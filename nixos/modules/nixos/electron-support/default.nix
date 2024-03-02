{ options, config, lib, pkgs, ... }:

with lib;
with lib.jules;
let cfg = config.jules.electron-support;
in {
  # options.jules.electron-support =
  #   mkOpt types.bool false "Enable support for Electron applications";

  jules.home.configFile."electron-flags.conf".source = ./electron-flags.conf;
  environment.sessionVariables = { NIXOS_OZONE_WL = "1"; };
}
