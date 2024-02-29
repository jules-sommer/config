{ pkgs, inputs }: {
  nixpkgs.overlays = [
    (_: super:
      let pkgs = inputs.fenix.inputs.nixpkgs.legacyPackages.${super.system};
      in inputs.fenix.overlays.default pkgs pkgs)
  ];

  environment.systemPackages = with pkgs; [
    (inputs.fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    (with pkgs;
      vscode-with-extensions.override {
        vscodeExtensions =
          [ vscode-extensions.rust-lang.rust-analyzer-nightly ];
      })
    rust-analyzer-nightly
  ];
}
