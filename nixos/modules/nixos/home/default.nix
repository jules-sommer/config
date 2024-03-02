{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.jules;
let cfg = config.jules.home;
in {

  options.jules.home = with types; {
    file = mkOpt attrs { }
      (mdDoc "A set of files to be managed by home-manager's `home.file`.");
    configFile = mkOpt attrs { } (mdDoc
      "A set of files to be managed by home-manager's `xdg.configFile`.");
    extraOptions = mkOpt attrs { } "Options to pass directly to home-manager.";
  };

  config = {
    jules.home.extraOptions = {
      home.stateVersion = config.system.stateVersion;
      home.file = mkAliasDefinitions options.jules.home.file;
      xdg.enable = true;
      xdg.configFile = mkAliasDefinitions options.jules.home.configFile;
    };

    home-manager = {
      useUserPackages = true;

      users.${settings.user} =
        mkAliasDefinitions options.jules.home.extraOptions;
    };
  };
}
