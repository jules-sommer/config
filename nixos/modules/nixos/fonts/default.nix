{ lib, config, pkgs, ... }:
let
  inherit (lib) types mkOpt;
  inherit (lib.xeta) mkEnableOption enabled;
  cfg = config.xeta.system.fonts;
in {
  options.xeta.system.fonts = {
    enable = mkEnableOption "Enable theming and fonts";
    fonts = mkOpt (types.enum [ "JetBrainsMono" "FiraCode" ]) "JetBrainsMono"
      "Which Nerdfonts to install on the system. Default is JetBrainsMono";
  };

  config = lib.mkIf cfg.enable {
    # Enable the user's custom fonts
    # in the user's home configuration
    snowfallorg.user.xeta.home.config = { fonts.fontconfig = enabled; };

    fonts = {
      enableDefaultPackages = true;
      fontDir.enable = true;

      packages = with pkgs; [ ubuntu_font_family jetbrains-mono fira-code ];

      fontconfig = {
        defaultFonts = {
          serif = [ "Ubuntu" ];
          sansSerif = [ "Ubuntu" ];
          monospace = [ "JetBrains Mono Nerd Font" ];
        };
      };
    };

    environment.systemPackages = with pkgs; [
      jetbrains-mono
      fira-code
      nerdfonts.override
      { fonts = [ "JetBrainsMono" "FiraCode" ]; }
    ];
  };
}
