{ config, lib, inputs, system, pkgs, ... }:
let
  inherit (lib) mkOpt types mkIf;
  cfg = config.xeta.home.apps.development.helix;
in {
  options.xeta.home.apps.development.helix = {
    enable = lib.mkEnableOption "Enable Helix, vim-like TUI text editor";
  };

  config = mkIf cfg.enable {
    helix = {
      enable = true;
      package = inputs.helix.packages.${system}.default;
      defaultEditor = true;
      settings = {
        theme = "github_dark_high_contrast";
        editor.cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
      };

      # Language settings
      languages.language = [
        {
          name = "rust";
          comment-token = "//";
          auto-format = true;
          formatter.command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        }
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
        }
        {
          name = "html";
          indent = {
            tab-width = 2;
            unit = "  ";
          };
          language-servers = [ "emmet-ls" ];
          formatter = {
            command = "emmet-ls";
            args = [ "--stdin" ];
          };
        }
        {
          name = "css";
          indent = {
            tab-width = 2;
            unit = "  ";
          };
          language-servers = [ "css-languageserver" ];
          formatter = {
            command = "css-languageserver";
            args = [ "--stdin" ];
          };
        }
        {
          name = "json";
          indent = {
            tab-width = 2;
            unit = "  ";
          };
          language-servers = [ "json-languageserver" ];
          formatter = {
            command = "json-languageserver";
            args = [ "--stdin" ];
          };
        }
        {
          name = "go";
          scope = "source.go";
          injection-regex = "go";
          file-types = [ "go" ];
          roots = [ "Gopkg.toml" "go.mod" ];
          auto-format = true;
          comment-token = "//";
          language-servers = [ "gopls" ];
          indent = {
            tab-width = 4;
            unit = "	";
          };
        }
        {
          name = "astro";
          language-servers = [ "astro-ls" ];
          formatter = {
            command = "astro-ls";
            args = [ "--stdin" ];
          };
        }
        {
          name = "typescript";
          language-servers = [ "deno" ];
        }
      ];

      # Language server settings
      languages.language-server = {
        rust = {
          config = {
            check = {
              command = "clippy";
              features = "all";
            };
            diagnostics = { experimental = { enable = true; }; };
            hover = { actions = { enable = true; }; };
            typing = { "autoClosingAngleBrackets" = { enable = true; }; };
            cargo = { "allFeatures" = true; };
            procMacro = { enable = true; };
          };
        };
        "emmet-ls" = {
          command = "emmet-ls";
          args = [ "--stdio" ];
        };
        "css-languageserver" = {
          command = "css-languageserver";
          args = [ "--stdio" ];
        };
        "json-languageserver" = {
          command = "json-languageserver";
          args = [ "--stdio" ];
        };
        gopls = {
          command = "gopls";
          args = [ "" ];
        };
        "astro-ls" = {
          command = "astro-ls";
          args = [ "--stdio" ];
        };
        deno = {
          command = "deno";
          args = [ "lsp" ];
        };
      };
    };
  };
}
