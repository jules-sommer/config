{ lib, inputs, snowfall-inputs, ... }:
with lib; rec {
  # (note): available as: `lib.my-helper-function`.
  my-helper-function = x: inputs.nix-colors.colorSchemes."${x}";

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
      hm = "cd ${home}";
      dev = "cd ${home}/_dev";
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

  };

  color = color_name:
    inputs.nix-colors.colorSchemes.gigavolt.palette.${color_name};

  theme = "gigavolt";
  get_theme = inputs.nix-colors.colorSchemes.gigavolt.palette;

  my-scope = {
    # This will be available as `lib.my-scope.my-scoped-helper-function`.
    my-scoped-helper-function = x: x;
  };
}
