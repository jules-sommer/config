{ channels, ... }:

final: prev: {
  # Utilizing 'fenix' and its packages
  # Ensure you have `fenix` as a channel/input within your flake configuration
  myFenixPackage = let
    system = prev.system;
    pkgs = channels.unstable.fenix.inputs.nixpkgs.legacyPackages.${system};
  in channels.unstable.fenix.overlays.default pkgs pkgs;
}
