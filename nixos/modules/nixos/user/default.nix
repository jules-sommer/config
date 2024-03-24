{ lib, config, ... }:

let
  inherit (lib) types mkIf;
  inherit (lib.xeta) mkOpt;

  cfg = config.xeta.user;
in {
  options.xeta = {
    hostname = mkOpt (types.str) "xeta" "System hostname.";
    user = {
      username = mkOpt (types.str) "jules" "The user account.";

      home =
        mkOpt (types.str) "/home/${cfg.name}" "The home directory of the user.";
      dotfiles = mkOpt (types.str) "/home/${cfg.name}/_dotfiles"
        "The dotfiles directory of the user.";
      extraGroups =
        mkOpt (types.listOf types.str) [ ] "Extra groups for the user.";

      fullName = mkOpt (types.str) "Jules Sommer" "The full name of the user.";
      email = mkOpt (types.str) "jules@rcsrc.shop" "The email of the user.";
      uid = mkOpt (types.nullOr types.int) 1000 "The uid for the user account.";
    };
  };

  config = {
    users.users.${cfg.username} = {
      home = cfg.home;
      homeMode = "0755";

      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" ] // cfg.extraGroups;

      # NOTE: Setting the uid here is required for another
      # module to evaluate successfully since it reads
      # `users.users.${xeta.user.name}.uid`.
      uid = mkIf (cfg.uid != null) cfg.uid;
    };

    # Change the default max open file descriptor limit.
    # See the original with: ulimit -Sa, in my case 1024.
    snowfallorg.user.${cfg.username}.home.config = {
      home = {
        file = {
          ".profile".text = ''
            ulimit -n 4096
          '';
        };
      };
    };
  };
}
