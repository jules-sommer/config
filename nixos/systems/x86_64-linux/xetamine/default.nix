{ pkgs, lib, config, ... }:
let inherit (lib) types;
in {

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.${config.snowfallorg.xeta.name} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  environment.systemPackages = with pkgs; [ neovim firefox ];

  # Configure Home-Manager options from NixOS.
  snowfallorg.user.xeta.home.config = {
    programs.home-manager.enable = true;
    home.username = config.snowfallorg.user.xeta.name;
    home.homeDirectory = config.snowfallorg.user.xeta.home;
    home.stateVersion = config.system.stateVersion;
  };

  system.stateVersion = "23.11";
}
