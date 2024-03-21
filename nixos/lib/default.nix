{ lib, inputs, ... }: rec {
  get_theme = { theme ? "someshit" }:
    inputs.nix-colors.colorSchemes.${theme}.palette;
}
