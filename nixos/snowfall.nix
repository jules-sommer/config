{
  description = "My system thaw";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";

    # Snowfall Lib is not required, but will make configuration easier for you.
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-thaw = {
      url = "github:snowfallorg/thaw";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      overlays = with inputs; [
        # Use the overlay provided by this thaw.
        snowfall-thaw.overlays.default

        # There is also a named overlay, though the output is the same.
        snowfall-thaw.overlays."package/thaw"
      ];
    };
}
