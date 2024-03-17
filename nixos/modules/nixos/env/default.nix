{ options, config, pkgs, lib, ... }:

with lib;
with lib.jules;
let cfg = config.jules.system.env;
in {
  options.jules.system.env = with types;
    mkOption {
      type = attrsOf (oneOf [ str path (listOf (either str path)) ]);
      apply = mapAttrs (n: v:
        if isList v then
          concatMapStringsSep ":" (x: toString x) v
        else
          (toString v));
      default = { };
      description = "A set of environment variables to set.";
    };

  config = {
    environment = {
      sessionVariables = {
        HOME = "${settings.home}";
        XDG_CACHE_HOME = "${settings.home}/.cache";
        XDG_CONFIG_HOME = "${settings.home}/_dev/.config";
        XDG_DATA_HOME = "${settings.home}/.local/share";
        XDG_BIN_HOME = "${settings.home}/.local/bin";
        # To prevent firefox from creating ~/Desktop.
        XDG_DESKTOP_DIR = "${settings.home}";
        XDG_SESSION_TYPE = "wayland";
      };
      variables = {
        # Make some programs "XDG" compliant.
        LESSHISTFILE = "$XDG_CACHE_HOME/less.history";
        WGETRC = "$XDG_CONFIG_HOME/wgetrc";
        NIXOS_OZONE_WL = "1";
        NIXPKGS_ALLOW_UNFREE = "1";
        GDK_BACKEND = "wayland";
        CLUTTER_BACKEND = "wayland";
        SDL_VIDEODRIVER = "wayland";
        POLKIT_BIN =
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        XCURSOR_SIZE = "24";
        XCURSOR_THEME = "Bibata-Modern-Ice";
        QT_QPA_PLATFORMTHEME = "qt5ct";
        QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        MOZ_ENABLE_WAYLAND = "1";
        NIX_PATH = "${settings.home}/.nix-defexpr/channels_root/nixos";
      };
      extraInit = concatStringsSep "\n"
        (mapAttrsToList (n: v: ''export ${n}="${v}"'') cfg);
    };
  };
}
