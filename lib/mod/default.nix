{ lib, ... }:
with lib; rec {
  ## Create a NixOS module option, with an optional description.
  ##
  ## Usage without description:
  ## ```nix
  ## lib.mkOpt nixpkgs.lib.types.str "My default"
  ## ```
  ##
  ## Usage with description:
  ## ```nix
  ## lib.mkOpt nixpkgs.lib.types.str "My default" "Description of my option."
  ## ```
  ##
  #@ Type -> Any -> Optional String -> mkOption
  mkOpt = type: default: description:
    lib.mkOption { inherit type default description; };

  mkOpt'' = type: default: description:
    mkOption { inherit type default description; };

  ## Create a NixOS module option without a description.
  ##
  ## ```nix
  ## lib.mkOpt' nixpkgs.lib.types.str "My default"
  ## ```
  ##
  #@ Type -> Any -> String
  mkOpt' = type: default: mkOpt type default null;

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

  # This function takes an attribute set and formats it into a string,
  # with optional prefix and suffix for each attribute.
  # Each attribute is represented as a line in the string, in the format "prefix name=value suffix".
  #
  # Example:
  # If the attribute set is { a = 1; b = "text"; }, and prefix is "export ", and no suffix is provided,
  # the output will be:
  # "export A=1
  #  export B=text"
  #
  # Args:
  #   attrSet: The attribute set to format.
  #   separator: (optional) A string to separate each line.
  #   prefix: (optional) A string to prepend to each line.
  #   suffix: (optional) A string to append to each line.
  #
  # Returns:
  #   A string representing the formatted attribute set.
  serializeAttrSetToStr =
    { attrSet, separator ? "\n", prefix ? "", suffix ? "" }:
    with builtins;
    concatStringsSep separator
    (map (name: "${prefix}${name}=${attrSet.${name}}${suffix}")
      (attrNames attrSet));

  # Helper function to convert string to uppercase
  stringToUpper = s:
    let
      lowercase = "abcdefghijklmnopqrstuvwxyz";
      uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    in foldl' (acc: c:
      let pos = stringPosition (x: x == c) lowercase;
      in acc
      + (if pos == null then toString c else substring (pos) (1) uppercase)) ""
    s;

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
