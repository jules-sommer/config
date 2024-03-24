{ config, lib, pkgs, ... }:
let
  inherit (lib) mkOpt types mkIf;
  cfg = config.xeta.system.nushell.config;
in {
  options.xeta.system.nushell.config = {
    enable = mkOpt (types.bool) true
      "Enable nushell config options, requires nushell to be installed.";
  };

  config = mkIf cfg.enable {

    "$env.config" = {
      show_banner = false;
      ls = {
        use_ls_colors = true;
        clickable_links = true;
      };
      rm = { always_trash = false; };
      table = {
        mode = "rounded";
        index_mode = "always";
        show_empty = true;
        padding = {
          left = 1;
          right = 1;
        };
        trim = {
          methodology = "wrapping";
          wrapping_try_keep_words = true;
          truncating_suffix = "...";
        };
        header_on_separator = false;
      };
      error_style = "fancy";
      datetime_format = {
        # Assuming static values or defaults as Nix can't dynamically switch
        # normal and table formats are commented out to represent "no specific format defined"
        # normal = "%a, %d %b %Y %H:%M:%S %z";
        # table = "%m/%d/%y %I:%M:%S%p";
      };
      explore = {
        status_bar_background = {
          fg = "#1D1F21";
          bg = "#C4C9C6";
        };
        command_bar_text = { fg = "#C4C9C6"; };
        highlight = {
          fg = "black";
          bg = "yellow";
        };
        status = {
          error = {
            fg = "white";
            bg = "red";
          };
          warn = { };
          info = { };
        };
        table = {
          split_line = { fg = "#404040"; };
          selected_cell = { bg = "light_blue"; };
          selected_row = { bg = "magenta"; };
          selected_column = { };
        };
      };
      history = {
        max_size = 100000;
        sync_on_enter = true;
        file_format = "sqlite";
        isolation = false;
      };
      completions = {
        case_sensitive = false;
        quick = true;
        partial = true;
        algorithm = "fuzzy";
        external = {
          enable = true;
          max_results = 100;
          completer = null;
        };
      };
      filesize = {
        metric = true;
        format = "auto";
      };
      cursor_shape = {
        emacs = "line";
        vi_insert = "block";
        vi_normal = "underscore";
      };
      color_config = "dark_theme";
      use_grid_icons = true;
      footer_mode = "25";
      float_precision = 2;
      buffer_editor = "";
      use_ansi_coloring = true;
      bracketed_paste = true;
      edit_mode = "vi";
      shell_integration = true;
      render_right_prompt_on_last_line = true;
      use_kitty_protocol = true;
    };
  };
}
