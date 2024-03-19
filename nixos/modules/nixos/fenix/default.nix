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
config, ... }: {

  # packages.x86_64-linux.default =
  #   inputs.fenix.packages.x86_64-linux.minimal.toolchain;
  # nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
  #   inherit system;
  #   modules = [

  #   ];
  # };

  nixpkgs.overlays = [
    (_: super:
      let pkgs = inputs.fenix.inputs.nixpkgs.legacyPackages.${system};
      in inputs.fenix.overlays.default pkgs pkgs)
  ];

  environment.systemPackages = with pkgs; [
    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    # (with pkgs;
    #   vscode-with-extensions.override {
    #     vscodeExtensions =
    #       [ vscode-extensions.rust-lang.rust-analyzer-nightly ];
    #   })
    vscode-extensions.rust-lang.rust-analyzer-nightly
    rust-analyzer-nightly
  ];
}
