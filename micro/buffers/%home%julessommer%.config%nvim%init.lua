HSerializedBuffer�� EventHandler�� Cursor�� ModTime��   8��EventHandler�� 	UndoStack�� 	RedoStack��   '��TEStack�� Top�� Size   *��Element�� Value�� Next��   B��	TextEvent�� C�� 	EventType Deltas�� Time��   Z��Cursor�� Loc�� LastVisualX CurSelection�� OrigSelection�� Num   ��Loc�� X Y   ��[2]buffer.Loc�� ��  ��[]buffer.Delta�� ��  0��Delta�� Text
 Start�� End��   ��Time��   �xT���� �� �� �� L  �!-- Completion Plugin Setup
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },
  -- Installed sources:
  sources = {
    { name = 'path' },                              -- file paths
    { name = 'nvim_lsp', keyword_length = 3 },      -- from language server
    { name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
    { name = 'nvim_lua', keyword_length = 2},       -- complete neovim's Lua runtime API such vim.lsp.*
    { name = 'buffer', keyword_length = 2 },        -- source current buffer
    { name = 'vsnip', keyword_length = 2 },         -- nvim-cmp source for vim-vsnip 
    { name = 'calc'},                               -- source for math calculation
  },
  window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },
  formatting = {
      fields = {'menu', 'abbr', 'kind'},
      format = function(entry, item)
          local menu_icon ={
              nvim_lsp = 'λ',
              vsnip = '⋗',
              buffer = 'Ω',
              path = '🖫',
          }
          item.menu = menu_icon[entry.source.name]
          return item
      end,
  },
})
�� �^     �>�8L��� �� ���� ���� ���� L  �*--Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
vim.opt.completeopt = {'menuone', 'noselect', 'noinsert'}
vim.opt.shortmess = vim.opt.shortmess + { c = true}
vim.api.nvim_set_option('updatetime', 300) 

-- Fixed column for diagnostics to appear
-- Show autodiagnostic popup on cursor hover_range
-- Goto previous / next diagnostic warning / error 
-- Show inlay_hints more frequently 
vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

�� ��     �>�4i��� �� ���� ���� ���� L  
�� ��     �>�(vVz�� �� ������ ���� ���� L  
�� ��     �>�r
;�� " " *J *J L    J J     �>�(þ�� " " *J *J L    H H     �>�(��� " " *J *J L    F F     �>�({?�� " " *J *J L    D D     �>�(U��� " " *J *J L    B B     �>�(<��� " " *J *J L    @ @     �>�(&��� " " *J *J L    > >     �>�(�� " " *J *J L    : :     �>�(
�i�� " " *J *J L    8 8     �>�(
��� " " *J *J L    4 4     �>�(
�� " " *J *J L    0 0     �>�(
���� " " *J *J L    . .     �>�(
���� " " *J *J L    , ,     �>�(
{2�� " " *J *J L    * *     �>�(
d�� " " *J *J L    ( (     �>�(
K&�� " " *J *J L    & &     �>�(
0n�� " " *J *J L    $ $     �>�(	���� " " *J *J L    " "     �>�(	;��� " " *J *J L   * *     �>�7H���� " " *J *J L   * *     �>�7G�N�� " " ,J ,J L   J J     �>�+Z��� " " .J .J L   J J     �>�+Zϒ�� " " .J .J L   H H     �>�+Z���� " " .J .J L   H H     �>�+Z���� " " .J .J L   F F     �>�+Z]��� " " .J .J L   F F     �>�+Z��� " " .J .J L   D D     �>�+Y���� " " .J .J L   D D     �>�+Y�q�� " " .J .J L   B B     �>�+Y���� " " .J .J L   B B     �>�+Y�,�� " " .J .J L   @ @     �>�+Y�B�� " " .J .J L   @ @     �>�+Yo�� " " .J .J L   > >     �>�+YV��� " " .J .J L   > >     �>�+Y.F�� " " .J .J L   : :     �>�+Y��� " " .J .J L   : :     �>�+X�p�� " " .J .J L   8 8     �>�+X�T�� " " .J .J L   8 8     �>�+X��� " " .J .J L   4 4     �>�+X��� " " .J .J L   4 4     �>�+X���� " " .J .J L   0 0     �>�+X}��� " " .J .J L   0 0     �>�+Xc;�� " " .J .J L   . .     �>�+XM�� " " .J .J L   . .     �>�+X1��� " " .J .J L   , ,     �>�+X��� " " .J .J L   , ,     �>�+W�a�� " " .J .J L   * *     �>�+Wʱ�� " " .J .J L   * *     �>�+WK2�� " " 0J 0J L   J J     �>�u'��� " " 2J 2J L   J J     �>�u2�� " " 2J 2J L   H H     �>�t��� " " 2J 2J L   H H     �>�t�1�� " " 2J 2J L   F F     �>�t���� " " 2J 2J L   F F     �>�t]��� " " 2J 2J L   D D     �>�t5��� " " 2J 2J L   D D     �>�t��� " " 2J 2J L   B B     �>�s��� " " 2J 2J L   B B     �>�sƀ�� " " 2J 2J L   @ @     �>�s��� " " 2J 2J L   @ @     �>�s�`�� " " 2J 2J L   > >     �>�sod�� " " 2J 2J L   > >     �>�sOz�� " " 2J 2J L   : :     �>�s4|�� " " 2J 2J L   : :     �>�s��� " " 2J 2J L   8 8     �>�r���� " " 2J 2J L   8 8     �>�r�a�� " " 2J 2J L   4 4     �>�r���� " " 2J 2J L   4 4     �>�r��� " " 2J 2J L   0 0     �>�ro�� " " 2J 2J L   0 0     �>�rP!�� " " 2J 2J L   . .     �>�r4��� " " 2J 2J L   . .     �>�r��� " " 2J 2J L   , ,     �>�q�c�� " " 2J 2J L   , ,     �>�q�6�� " " 2J 2J L   * *     �>�q���� " " 2J 2J L   * *     �>�q���� " " 2J 2J L   ( (     �>�qk��� " " 2J 2J L   ( (     �>�qP
�� " " 2J 2J L   & &     �>�q9��� " " 2J 2J L   & &     �>�q��� " " 2J 2J L   $ $     �>�p֬�� " " 2J 2J L   $ $     �>�pOq�� " " 2J 2J L   " "     �>�p5c�� " " 2J 2J L   " "     �>�o���� 0J 0  
D L  ,0J 2J     �>�4�� .H .  
D L  ,.H 0H     �>���� ,F ,  
D L  ,,F .F     �>��o�� .F .  
D L   ,F .F     �>�;�k*�� 0F 0  
D L   .F 0F     �>�3���� .D .  
D L  ,.D 0D     �>�2��.�� 0D 0  
D L   .D 0D     �>�$��c�� 2D 2  
D L   0D 2D     �>�+,��� 4D 4  
D L   2D 4D     �>������ 6D 6  
D L   4D 6D     �>����� 8D 8  
D L   6D 8D     �>�;���� :D :  
D L   8D :D     �>�1�2��� <D <  
D L   :D <D     �>�(X��� >D >  
D L   <D >D     �>�v]H�� @D @  
D L   >D @D     �>���O�� BD B  
D L   @D BD     �>����� DD D  
D L   BD DD     �>�B�0�� FD F  
D L   DD FD     �>�s���� HD H  
D L   FD HD     �>������ JD J  
D L   HD JD     �>��b�� LD L  
D L   JD LD     �>�sr�� ND N  
D L   LD ND     �>�	=���� PD P  
D L   ND PD     �>�'	F��� RD R  
D L   PD RD     �>��]�� TD T  
D L   RD TD     �>��M��� VB V  
D L  .TB VB     �>�	�7a�� TB T  
D L  .TB VB     �>�)W��� RB R  
D L  ,RB TB     �>�(�R�� 8@ 8  
D L  .6@ 8@     �>�ȹ2�� 6@ 6  
D L  .6@ 8@     �>�;!`��� 4@ 4  
D L  ,4@ 6@     �>�;Y��� :   
D L  ": 
:     �>�$�_��� :   
D L  ': 
:     �>�Y�M�� 6: 6  
D L  .4: 6:     �>���� 4: 4  
D L  .4: 6:     �>������ 2: 2  
D L  ,2: 4:     �>���2�� 4: 4  
D L  .2: 4:     �>�̾��� 2: 2  
D L  .2: 4:     �>�"�0F�� .: .  
D L  s.: 0:     �>�/,�=�� ,4 ,  
D L  ,,4 .4     �>�.?���� *4 *  
D L  "*4 ,4     �>���2�� ,4 ,  
D L  '*4 ,4     �>�ys�� .4 .  
D L  ",4 .4     �>�Ty�� .4 .  
D L  ".4 04     �>�Q���� .4 .  
D L  ".4 04     �>�%&ˀ�� ,4 ,  
D L  ",4 .4     �>�%#p��� .4 4  
D L   ,4 .4     �>��pT�� 2: 2  
D L  "2: 4:     �>���'�� 4: 4  
D L  '2: 4:     �>�˾�� 2@ 2  
D L  "2@ 4@     �>� pm�� 4@ R  
D L  '2@ 4@     �>�-�h �� PB P  
D L  "PB RB     �>�&��� RB R  
D L  'PB RB     �>�V��� ,D ,  
D L  ",D .D     �>�_���� .D .  
D L  ',D .D     �>�9-0��� *F *  
D L  "*F ,F     �>�#Ep�� ,F ,  
D L  '*F ,F     �>�5��� .F .  
D L   ,F .F     �>�,S@�� 0H 0  
D L  :.H 0H     �>�r|��� .H .  
D L  :.H 0H     �>�.���� ,H ,  
D L  ",H .H     �>�-D��� .H .  
D L  ',H .H     �>�tM��� 0H 0  
D L   .H 0H     �>��m��� .J .  
D L  ".J 0J     �>�,Q
4�� 0J 0  
D L  '.J 0J     �>������ 2J 2  
D L   0J 2J     �>�0���� 4J 4  
D L   2J 4J     �>�7����� 6J 6  
D L   4J 6J     �>�.��J�� 8J 8  
D L   6J 8J     �>�$����� :J :  
D L   8J :J     �>�*���� <J <  
D L   :J <J     �>��o�� >J >  
D L   <J >J     �>�
���� @J @  
D L   >J @J     �>�;����� BJ B  
D L   @J BJ     �>�2���� DJ D  
D L   BJ DJ     �>�'�i��� FJ F  
D L   DJ FJ     �>�&���� HJ H  
D L   FJ HJ     �>�$@�l�� JJ J  
D L   HJ JJ     �>�"s��� LJ L  
D L   JJ LJ     �>� ��p�� NJ N  
D L   LJ NJ     �>��*�� PJ P  
D L   NJ PJ     �>�6Z���� RJ R  
D L   PJ RJ     �>�(�$�� TJ T  
D L   RJ TJ     �>�&K��� VJ V  
D L   TJ VJ     �>�${q�� XJ X  
D L   VJ XJ     �>�"��;�� ZJ Z  
D L   XJ ZJ     �>� ����� \J \  
D L   ZJ \J     �>���)�� ^J ^  
D L   \J ^J     �>�,j��� `J `  
D L   ^J `J     �>�a
K�� bJ b  
D L   `J bJ     �>�9-���� dJ d  
D L   bJ dJ     �>�0���� fJ f  
D L   dJ fJ     �>�'�3d�� hJ h  
D L   fJ hJ     �>���4�� J   
D L  "J 
J     �>�5]B��� 
J 
  
D L  'J 
J     �>�)v\ �� H   
D L  "H 
H     �>�2~�u�� 
H 
  
D L  'H 
H     �>�&%-d�� F   
D L  "F 
F     �>�DV�� 
F 
  
D L  'F 
F     �>�3cZ�� D   D L  "D 
D     �>�<m��� 
D 
  D L  'D 
D     �>�:%���� B   D L  "B 
B     �>�c�h�� 
B 
  D L  'B 
B     �>�)|���� @   D L  "@ 
@     �>����� 
@ 
  D L  '@ 
@     �>�7ȋ�� 4   D L  "4 
4     �>� ��|�� 
4 
  D L  '4 
4     �>�-K��� 4   D L  '
4 4     �>�3��Z�� 
4 
  D L  '
4 4     �>������ 4   D L   4 
4     �>��'v�� 4   D L  e4 
4     �>�%���� 4   D L  s4 
4     �>�#��� 4   D L  u4 
4     �>�OL�� :   D L   : 
:     �>�*���� :   D L  e: 
:     �>�1��� :   D L  s: 
:     �>�	
YJ�� :   D L  u: 
:     �>�;�6�� @   D L   @ 
@     �>�92/n�� @   D L  e@ 
@     �>�/6�{�� @   D L  s@ 
@     �>�%�M��� @   D L  u@ 
@     �>��d��� B   D L   B 
B     �>�6\�V�� B   D L  eB 
B     �>�*�~��� B   D L  sB 
B     �>�$��	�� B   D L  uB 
B     �>�	���� 
F 
  D L  uF 
F     �>�(XF�� F   D L  s
F F     �>�+�d�� F   D L  eF F     �>��_�� F   D L   F F     �>3S��� D   D L   D 
D     �>|"]���� D D D D L  useD D     �>{:J1��� J J J J L  use J J     �>v(/��� J   J N  9    use 'hrsh7th/cmp-buffer'                            
H J     �>p%����� J   J L  9    use 'hrsh7th/cmp-buffer'                            
L N     �>p%��N�� J J J J L  use J J     �>o,};/�� J J J J N  9    use 'hrsh7th/cmp-buffer'                            
L N     �>n)�<L�� H H H H L  9    use 'hrsh7th/cmp-buffer'                            
H J     �>n)�R�� J J J J N  9    use 'hrsh7th/cmp-buffer'                            
H J     �>nnF�� J J J J L  9    use 'hrsh7th/cmp-buffer'                            
L N     �>nmI��� 4   6 6  ��    use 'hrsh7th/nvim-cmp' 

    -- LSP completion source:
    use 'hrsh7th/cmp-nvim-lsp'

    -- Useful completion sources:
    use 'hrsh7th/cmp-nvim-lua'
    use 'hrsh7th/cmp-nvim-lsp-signature-help'
    use 'hrsh7th/cmp-vsnip'                             
    use 'hrsh7th/cmp-path'                              
    use 'hrsh7th/cmp-buffer'                            
    use 'hrsh7th/vim-vsnip'  4 :J     �>i/Y#��� 4   4 4  
4 6     �>iO��� 4   4 4    4 4     �>g�<K�� 4   4 4    4 4     �>f!ܫ��� 4   4 4      2 2     �>e:�$��� 4   4 4      4 4     �>e:��@�� 2   2 2  
2 4     �>e:����� 2   2 2      2 2     �>d:/���� >0 >  >0 >0  
>0 2     �>d:/k}�� 2 >0 2 >0 2  
>0 2     �>d:.�L�� p \ \ \   ��-- LSP Diagnostics Options Setup 
local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({name = 'DiagnosticSignError', text = ''})
sign({name = 'DiagnosticSignWarn', text = ''})
sign({name = 'DiagnosticSignHint', text = ''})
sign({name = 'DiagnosticSignInfo', text = ''})

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])
p ��     �>N79,�� n \ \ \   
n p     �>N-[���� V V V V   �_local rt = require("rust-tools")

rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})
V n     �>?V�e�� T T T T   
T V     �>?=�{�� <0 <<0 <0 <0   ,<0 >0     �>+���� 0 :0 :0 :0   "0 
0     �>)8͹��� 
0 
<0 <0 <0   '0 
0     �>),l�Z�� :0 ::0 :0 :0   ":0 <0     �>'38��� <0 <<0 <0 <0   ':0 <0     �>'$P���� 0 0 0 0   'simrat39/rust-tools.nvim'0 <0     �>&2��+�� 0 0 0 0       0 0     �>&!�P{�� 8. 88. 8. 8.   
8. 0     �>&!����� D   F   

B D     �> �+
��� D 
  F     D D     �> �;'�� D   H   

B D     �> �/ST�� 6   :   ��    ui = {
        icons = {
            package_installed = "",
            package_pending = "",
            package_uninstalled = "",
        },
    }
6 D     �> ���P�� 8   :     6 6     �> �(�L��� 8   :     8 8     �> �(�=*�� 6   8   
6 8     �> �(��j�� 6   6   
6 8     �> ������ 6   6     6 6     �> ��;��� 04 0  44   
04 6     �> ��+�� 44 4  64   {24 44     �> �.�#/�� 44 4  84   }44 64     �> �.�#��� 44 4  64   }44 64     �> �x)C�� 24 2  44   {24 44     �> �wT`�� 24 2  64   }04 24     �> �`�� 04 0  44   }04 24     �> ����� 04 0  24   }04 24     �> ������ .4 .  04   {.4 04     �> ������ 6   6   
04 6     �> ���� 8   8   
6 8     �> ����� 08 08 08 8   require("mason").setup()8 08     �> �3�;(�� FD FHD HD HD   }DD FD     �> ���G�� DD DFD FD FD   }DD FD     �> ������ DD DDD DD DD   }DD FD     �> ��1�� BD BBD BD BD   {BD DD     �> �K��� @D @@D @D @D    @D BD     �> ������ >D >>D >D >D   p>D @D     �> �$��V�� <D <<D <D <D   u<D >D     �> ����� :D ::D :D :D   t:D <D     �> �@r��� 8D 88D 8D 8D   e8D :D     �> �z<��� 6D 66D 6D 6D   s6D 8D     �> �>�� 4D 44D 4D 4D   .4D 6D     �> �0���� 2D 22D 2D 2D   s2D 4D     �> �ʲ��� 0D 00D 0D 0D   l0D 2D     �> ��N�� .D ..D .D .D   p.D 0D     �> ������ ,D ,,D ,D ,D   o,D .D     �> �8+��� *D **D *D *D   g*D ,D     �> �1HSo�� (D ((D (D (D   .(D *D     �> ��׿�� "D "&D &D &D   g"D $D     �> �geQ��  D  $D $D $D   i D "D     �> ��޵�� D "D "D "D   fD  D     �> �	��!�� D  D  D  D   nD D     �> �'��� D D D D   oD D     �> � *==�� D D D D   cD D     �> �7���� D D D D   pD D     �> �#�� �� D D D D   sD D     �> �J�B�� D D D D   lD D     �> ������ D D D D   "D D     �> �$�_�� D D D D   "D D     �> �$姹�� D D D D   )D D     �> �P�I�� D D D D   (D D     �> �OD�� D D D D   eD D     �> �#�r�� 
D 

D 
D 
D   r
D D     �> �E6B�� D D D D   iD 
D     �> ��7�� D D D D   uD D     �> �	=s��� D D D D   qD D     �> �6���� D D D D   qD D     �> �+!�� D D D D   yD D     �> �"F�� 
D 

D 
D 
D   uD 
D     �> �r�M�� D D D D   r
D D     �> �	;E��� D D D D   eD D     �> �+�ˇ�� D D D D   (D D     �> �"��O�� D D D D   )D D     �> �"���� D D D D   )D D     �> �ʜ��� D D D D   (D D     �> ��I(�� D D D D   eD D     �> �.����� 
D 

D 
D 
D   r
D D     �> �,
L�� D D D D   uD 
D     �> �&��L�� D D D D   yD D     �> �"��(�� D D D D   qD D     �> �Ut��� D D D D   eD D     �> �-�=��� D D D D   rD D     �> �&�0#�� @   VB   '-- require("lspconfig").lua_ls.setup {}@ N@     �> �#�I�� H@ H  VB   $require("lspconfig").lua_ls.setup {}@ H@     �> �#���� @   VB   $require("lspconfig").lua_ls.setup {}@ H@     �> ��`��� N@ V  VB   '-- require("lspconfig").lua_ls.setup {}@ N@     �> ��>��� B   B   +require("lspconfig").rust_analyzer.setup {}B VB     �> �X��� \B \  \B   .-- require("lspconfig").rust_analyzer.setup {}B \B     �> �W���� B   B   .-- require("lspconfig").rust_analyzer.setup {}B \B     �> �6����� VB V  VB   +require("lspconfig").rust_analyzer.setup {}B VB     �> �6����� B   B   +require("lspconfig").rust_analyzer.setup {}B VB     �> �.����� \B \  \B   .-- require("lspconfig").rust_analyzer.setup {}B \B     �> �.�r}�� 8   8   ��require("mason").setup()
require("mason-lspconfig").setup()

-- After setting up mason-lspconfig you may set up servers via lspconfig
-- require("lspconfig").lua_ls.setup {}
-- require("lspconfig").rust_analyzer.setup {}8 \B     �> �5�ly�� 04 82( 2( 2(   
04 6     �> `����� * 2( 2( 2(   d    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",* 8.     �> ]���� * 2( 2( 2(     * *     �> ] @�5�� 8( 82( 2( 2(   
8( *     �> ] @lu�� 0. 0     ).. 0.     �> KA��� .. .     ).. 0.     �> K	=)�� .. .     ).. 0.     �> K��@�� ,. ,     (,. ..     �> K���� *. *     p*. ,.     �> IŅ�� (. (     u(. *.     �> I���� &. &     t&. (.     �> IX0�� $. $     e$. &.     �> H;i=�� ". "     s". $.     �> H0t����  .       . . ".     �> H)K���� .      n. .     �> G1_;��� .      o. .     �> G.��i�� .      s. .     �> G"$�+�� .      a. .     �> GU���� .      m. .     �> G"�� .      ". .     �> F9�x�� .      ". .     �> F9QQ�� .      ). .     �> F����� .      (. .     �> F���� .      e. .     �> F�$��� 
. 
     r
. .     �> F*���� .      i. 
.     �> F#G�� .      u. .     �> E9�	��� .      q. .     �> E-���� 
. 
     u. 
.     �> E&�q��� .      i
. .     �> Eb�j�� .      r. .     �> EF(�� .      e. .     �> E ���� .      e. .     �> D4��{�� .      r. .     �> D1`5��� 
. 
     i
. .     �> D/~���� .      u. 
.     �> D)O���� .      q. .     �> DH5�� .      q. .     �> A% ,��� .      e. .     �> @%�|�� .      r. .     �> @�l�� , 8     
, .     �> @2�;�� 6( 6     ,6( 8(     �> >���� (      "williamboman/mason.nvim"( 6(     �> <3J���� (        ( (     �> <#�X�� ,& ,     
,& (     �> <#����       �-- Example using a list of specs with the default options
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

require("lazy").setup({
  "folke/which-key.nvim",
  { "folke/neoconf.nvim", cmd = "Neoconf" },
  "folke/neodev.nvim",
}) (     �=��$T�i��  ,     
      �=���E���       �:local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath) :     �=����Q��                                                                                                                                                                                                                                                                                                                                                                                             ��   �^    �>�`���� 