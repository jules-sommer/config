{
# Snowfall Lib provides a customized `lib` instance with access to your flake's library
# as well as the libraries available from your flake's inputs.
lib,
# An instance of `pkgs` with your overlays and packages applied is also available.
pkgs,
# You also have access to your flake's inputs.
inputs,

# Additional metadata is provided by Snowfall Lib.
system, # The system architecture for this host (eg. `x86_64-linux`).
target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
format, # A normalized name for the system target (eg. `iso`).
virtual
, # A boolean to determine whether this system is a virtual target using nixos-generators.
systems, # An attribute map of your defined hosts.

# All other arguments come from the module system.
config, ... }:
with lib.jules; {
  # nixpkgs = {
  #   config = {
  #     # Disable if you don't want unfree packages
  #     allowUnfree = true;
  #     permittedInsecurePackages = [ "electron-25.9.0" ];
  #   };
  # };

  # Additional optimizations below from this nix-starter config
  # https://github.com/Misterio77/nix-starter-configs/blob/main/minimal/nixos/configuration.nix

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: { inherit flake; }))
    ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = [ "/home/jules/.nix-defexpr/channels_root/nixos" ];
  environment.etc = lib.mapAttrs' (name: value: {
    name = "/home/jules/.nix-defexpr/channels_root/nixos/${name}";
    value.source = value.flake;
  }) config.nix.registry;

  # Configure the Nix package manager
  nix = {
    settings = {
      warn-dirty = false;
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
      # Use binary caches
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

}
