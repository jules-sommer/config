{ lib, inputs, snowfall-inputs, ... }:
with lib; rec {
  settings = {
    # (note): available as: `lib.settings.home`.
    home = "/home/jules";
    user = "jules";
    host = "ishottt";
    dotfiles = "${settings.home}/_dev/.config";
    flake = "${settings.home}/_dev/.config/nixos";
    version = "24.05";
    theme = "gigavolt";
    aliases = {
      m = "micro";
      nano = "micro";
      cpa = "cp -rviup";
      l = "ls -la";
      hm = "cd ${settings.home}";
      dev = "cd ${settings.home}/_dev";
      z = "zellij";
      ass = "atuin search -i";
      nf =
        "neofetch --gap 15 --color_blocks off --memory_percent on --disk_percent on";
      br = "broot -hips";
      hx_conf = "hx $nu.config-path";
      hx_env = "hx $nu.env-path";
      cd = "z";
      cdi = "zi";
      copy = "wl-copy";
      paste = "wl-paste";
      sync = "rsync -avh --progress";
      mirror_sync = "rsync -avzHAX --delete --numeric-ids --info=progress2";
    };

    env_vars = {
      NIXOS_OZONE_WL = "1";
      NIXPKGS_ALLOW_UNFREE = "1";
      XDG_CONFIG_HOME = "${settings.home}/_dev/.config";
      XDG_SESSION_TYPE = "wayland";
      GDK_BACKEND = "wayland";
      CLUTTER_BACKEND = "wayland";
      SDL_VIDEODRIVER = "wayland";
      POLKIT_BIN =
        "${inputs.unstable.pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      XCURSOR_SIZE = "24";
      XCURSOR_THEME = "Bibata-Modern-Ice";
      QT_QPA_PLATFORMTHEME = lib.pkgs.lib.mkDefault "qt5ct";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      MOZ_ENABLE_WAYLAND = "1";
      NIX_PATH = "${lib.settings.home}/.nix-defexpr/channels_root/nixos";
    };
  };

  color = color_name:
    inputs.nix-colors.colorSchemes.gigavolt.palette.${color_name};

  theme = "gigavolt";
  get_theme = inputs.nix-colors.colorSchemes.gigavolt.palette;

}
