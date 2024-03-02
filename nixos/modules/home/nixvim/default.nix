{ pkgs, config, lib, inputs, ... }:
{
  # programs.nixvim = {
  #   enable = true;

  #   colorScheme = "tokyonight";
  #   options = {
  #     number = true;
  #     relativenumber = true;
  #     wrap = false;

  #     shiftwidth = 2;
  #   };

  #   keymaps = [{
  #     action = "<cmd>Telescope live_grep<CR>";
  #     key = "<leader>g";
  #   }];

  #   globals = { mapleader = " "; };

  #   highlight = {
  #     Comment.fg = "#ff00ff";
  #     Comment.bg = "#000000";
  #     Comment.underline = true;
  #     Comment.bold = true;
  #   };

  #   extraPlugins = with pkgs.vimPlugins; [{
  #     plugin = comment-nvim;
  #     config = ''lua require("Comment").setup()'';
  #   }];

  #   plugins.lsp = {
  #     enable = true;
  #     servers = {
  #       tsserver.enable = true;
  #       lua-ls = {
  #         enable = true;
  #         settings.telemetry.enable = false;
  #       };
  #       rust-analyzer = {
  #         enable = true;
  #         installCargo = false;
  #         autostart = true;
  #       };
  #     };
  #   };

  #   plugins = {
  #     oil.enable = true;
  #     telescope = { enable = true; };
  #     treesitter = {
  #       enable = true;
  #       highlight = { enable = true; };
  #     };
  #     luasnip = { enable = true; };
  #     nvim-cmp = {
  #       enable = true;
  #       autoEnableSources = true;
  #       sources = [
  #         { name = "nvim_lsp"; }
  #         { name = "path"; }
  #         { name = "buffer"; }
  #         { name = "luasnip"; }
  #       ];

  #       mapping = {
  #         "<CR>" = "cmp.mapping.confirm({ select = true })";
  #         "<Tab>" = {
  #           action = ''
  #             function(fallback)
  #               if cmp.visible() then
  #                 cmp.select_next_item()
  #               elseif luasnip.expandable() then
  #                 luasnip.expand()
  #               elseif luasnip.expand_or_jumpable() then
  #                 luasnip.expand_or_jump()
  #               elseif check_backspace() then
  #                 fallback()
  #               else
  #                 fallback()
  #               end
  #             end
  #           '';
  #           modes = [ "i" "s" ];
  #         };
  #       };
  #     };
  #   };
  # };
}
