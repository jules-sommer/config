{ channels, ... }:

(final: prev: {
  # Override for using Vscode Insiders edition, basically nightly/unstable release instead
  vscode-with-extensions =
    (prev.vscode.override { isInsiders = true; }).overrideAttrs (oldAttrs: rec {
      src = (builtins.fetchTarball {
        url = "https://update.code.visualstudio.com/latest/linux-x64/insider";
        sha256 = "0z3gir3zkswcyxg9l12j5ldhdyb0gvhssvwgal286af63pwj9c66";
      });
      version = "latest";
    });
})
