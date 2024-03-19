{ lib, config, pkgs, ... }:

let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.jules) mkOpt enabled;

  cfg = config.jules.apps.starship;
in {
  options.jules = {
    apps.starship = {
      enable = mkEnableOption "Enable starship prompt";
      theme = mkOpt types.str "mocha"
        "Starship prompt theme ( one of: `latte`, `frappe`, `macchiato`, or `mocha` )";
    };
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      settings = {
        # Other config here
        format = "$all"; # Remove this line to disable the default prompt format
        palette = "catppuccin_${cfg.theme}";
      } // builtins.fromTOML (builtins.readFile (pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "starship";
        rev = "5629d23";
        sha256 = "nsRuxQFKbQkyEI4TXgvAjcroVdG+heKX5Pauq/4Ota0=";
      } + /palettes/${cfg.theme}.toml));
    };
  };
}
