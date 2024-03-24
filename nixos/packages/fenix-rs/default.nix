{ lib, pkgs, ... }:

pkgs.stdenv.mkDerivation {
  name = "fenix-rs";
  buildInputs = [
    (pkgs.fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    (pkgs.vscode-with-extensions.override {
      vscodeExtensions =
        [ pkgs.vscode-extensions.rust-lang.rust-analyzer-nightly ];
    })
    pkgs.rust-analyzer-nightly
  ];

  # You might not need `builder` or `installPhase` if you're just aggregating existing packages
  # But if you need to perform custom setup steps, you can define those phases here.

  meta = {
    description = "Fenix Rust development overlay applied to a custom package.";
    # Add other meta fields as necessary
  };
}
