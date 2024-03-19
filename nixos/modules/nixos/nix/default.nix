{ options, config, pkgs, lib, inputs, ... }:
with lib;
with lib.jules;
let
  cfg = config.jules.nix;
  inherit (lib) mkEnableOption mkIf mkDefault;
  inherit (lib.jules) mkOpt enabled joinStrings;
  inherit (lib.types) listOf str;
in {
  options.jules.nix = {
    warn-dirty = mkBoolOpt false "Warn when the Nix store is dirty.";
    auto-optimise-store =
      mkBoolOpt false "Automatically optimize the Nix store.";
    experimental-features = mkOpt (listOf str) [ ] "Experimental Nix features.";
  };

  config = {
    nix = let users = [ "root" lib.jules.settings.user ];
    in {
      # Additional optimizations below from this nix-starter config
      # https://github.com/Misterio77/nix-starter-configs/blob/main/minimal/nixos/configuration.nix

      # This will add each flake input as a registry
      # To make nix3 commands consistent with your flake
      registry = (lib.mapAttrs (_: flake: { inherit flake; }))
        ((lib.filterAttrs (_: lib.isType "flake")) inputs);

      # This will additionally add your inputs to the system's legacy channels
      nixPath = [ "/home/jules/.nix-defexpr/channels_root/nixos" ];

      settings = {
        auto-optimise-store = cfg.auto-optimise-store;
        experimental-features = joinStrings cfg.experimental-features;
        warn-dirty = cfg.warn-dirty;

        cores = 12;
        http-connections = 50;
        log-lines = 50;
        sandbox = "relaxed";
        trusted-users = users;
        allowed-users = users;

        keep-outputs = true;
        keep-derivations = true;

        substituters = [ "https://hyprland.cachix.org" ];
        trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];
      };
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 7d";
      };
    };
    environment.systemPackages = with pkgs; [
      deploy-rs
      nixfmt
      nix-index
      nix-prefetch-git
      nix-output-monitor
      flake-checker
    ];
    environment.etc = lib.mapAttrs' (name: value: {
      name = "/home/jules/.nix-defexpr/channels_root/nixos/${name}";
      value.source = value.flake;
    }) config.nix.registry;
  };
}
