{ lib, inputs, config, pkgs, ... }:
let cfg = config.jules.fonts;
in with lib; {
  options.jules.fonts = with types; { enable = mkEnableOption "Enable fonts"; };
  config = mkIf cfg.enable {
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
  };
}
