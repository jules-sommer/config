{ lib, ... }:

with lib; rec {
  ## Create a NixOS module option.
  ##
  ## ```nix
  ## lib.mkOpt nixpkgs.lib.types.str "My default" "Description of my option."
  ## ```
  ##
  #@ Type -> Any -> String
  mkOpt = type: default: description:
    mkOption { inherit type default description; };

  # Checks if a path exists on the filesystem.
  #
  # ```nix
  # lib.pathExists "/etc/passwd"
  # ```
  #
  #@ String -> Bool
  pathExists = path: builtins.pathExists path;

  # Create a NixOS module option that allows user to pass a list of packages.
  #
  # ```nix
  # lib.mkListOf nixpkgs.lib.types.package (with nixpkgs; [git vim])
  # ```
  #
  #@ Type -> Any -> String
  mkListOf = type: default: description:
    mkOption {
      inherit default description;
      type = types.listOf type;
    };

  ## Create a NixOS module option without a description.
  ##
  ## ```nix
  ## lib.mkOpt' nixpkgs.lib.types.str "My default"
  ## ```
  ##
  #@ Type -> Any -> String
  mkOpt' = type: default: mkOpt type default null;

  ## Create a boolean NixOS module option.
  ##
  ## ```nix
  ## lib.mkBoolOpt true "Description of my option."
  ## ```
  ##
  #@ Type -> Any -> String
  mkBoolOpt = mkOpt types.bool;

  ## Create a boolean NixOS module option without a description.
  ##
  ## ```nix
  ## lib.mkBoolOpt true
  ## ```
  ##
  #@ Type -> Any -> String
  mkBoolOpt' = mkOpt' types.bool;

  ## Maps a list of strings to a single whitespace delimited string.
  ##
  ## ```nix
  ## lib.joinStrings ["a" "b" "c"]
  ## ```
  ##
  #@ List String -> String
  joinStrings = strings: builtins.concatStringsSep " " strings;

  enabled = {
    ## Quickly enable an option.
    ##
    ## ```nix
    ## services.nginx = enabled;
    ## ```
    ##
    #@ true
    enable = true;
  };

  disabled = {
    ## Quickly disable an option.
    ##
    ## ```nix
    ## services.nginx = enabled;
    ## ```
    ##
    #@ false
    enable = false;
  };

}
