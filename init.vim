" python3を使わせるために適当にpython3を実行
if !has('nvim')
 python3 0
endif

if !exists('g:vscode')

" setting

"文字コードをUTF-8に設定
set fenc=utf-8
set encoding=utf8

" set <Leader> key
let mapleader = "\<M-m>"

" install dein.vim
if &compatible
  set nocompatible " Be iMproved
endif

" Required:
if has ('nvim')
  let g:dein_dir = stdpath('data') . '/dein'
else
  let g:dein_dir = '~/.vim/dein'
endif

let s:dein_repo_dir = g:dein_dir . '/repos/github.com/Shougo/dein.vim'

" なければgit clone
if !isdirectory(s:dein_repo_dir)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif

execute 'set runtimepath+=' . s:dein_repo_dir

call dein#begin(g:dein_dir)

" manage packages with toml
" reset augroup
augroup toml-config | autocmd! | augroup END
if has('nvim')
  let s:toml_file = stdpath('config') . '/dein.toml'
  call dein#load_toml(s:toml_file, {'lazy': 0})
else
  let s:toml_file = '~/.vim/dein.toml'
  call dein#load_toml(s:toml_file, {'lazy': 0})
endif

" Required:
call dein#end()

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

" remove packages
call map(dein#check_clean(), { _, val -> delete(val, 'rf') })

" Required:
filetype plugin indent on
" シンタックスハイライトの有効化
syntax enable

" fcitx5 (だめだった)
" if isdirectory('/usr/share/fcitx5/lua')
"   set runtimepath+='/usr/share/fcitx5/'
" endif
" augroup fcitx5
"   autocmd!
"   autocmd InsertEnter * lua require('fcitx').ime.setCurrentInputMethod('keyboard-jp')
"   " autocmd InsertLeave * lua require('fcitx').setCurrentInputMethod('mozc')
"   " autocmd vimEnter * lua require('fcitx').setCurrentInputMethod('mozc')
" augroup END

" " insertモードから抜けたときに変換を切る
" if executable('fcitx5')
"    autocmd InsertLeave * :call system('fcitx5-remote -c')
"    autocmd CmdlineLeave * :call system('fcitx5-remote -c')
" elseif executable('fcitx')
"    autocmd InsertLeave * :call system('fcitx-remote -c')
"    autocmd CmdlineLeave * :call system('fcitx-remote -c')
" endif


" command to replace builtin commands
" https://vim.fandom.com/wiki/Replace_a_builtin_command_using_cabbrv
function! CommandCabbr(abbreviation, expansion)
  execute 'cabbr ' . a:abbreviation . ' <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "' . a:expansion . '" : "' . a:abbreviation . '"<CR>'
endfunction
command! -nargs=+ CommandCabbr call CommandCabbr(<f-args>)

" " use buftype=nofile instead
" let s:specialfiletypes = ['vim-plug' , 'denite', 'tagbar']
" " determine if file is not for editing
" function! s:is_specialbuffer() abort
" " return index(s:specialfiletypes, &ft) < 0
" endfunction

" :bd でwindowを閉じずに現在のbufferをdelete
" https://stackoverflow.com/a/19620009
" BufferDeleteNoCloseWindowでbdを置き換え
command! -bang BD buffer#|bdelete<bang>#

" if has("gui_running") || has('g:GuiLoaded')
" カラースキーム
" color scheme koehler
" ダーク系のカラースキームを使う
" set background=dark
" set previewpopup=true

" " fonts
" set guifontwide=NotoSansMonoCJKJP
" set guifont=Inconsolata,NotoSansMonoCJKJP

set guioptions-=T
" set guioptions=m


" 左右のスクロールバーを消す
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L
" endif


let g:plug_window='topleft new'
" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
if has ('nvim')
  call plug#begin(stdpath('data') . '/plugged')
else
  call plug#begin('~/.vim/plugged')
endif
" Make sure you use single quotes

" " themes
" Plug 'joshdick/onedark.vim'
" Plug 'sonph/onehalf', { 'rtp': 'vim' }
" Plug 'jacoborus/tender.vim'
" Plug 'romainl/Apprentice'
" Plug 'drewtempelmeyer/palenight.vim'
" Plug 'ErichDonGubler/vim-sublime-monokai'

" indent guides
Plug 'yggdroot/indentline'

" highlight and remode whitespaces
Plug 'ntpeters/vim-better-whitespace'

" color parenthesizes
Plug 'luochen1990/rainbow'

" colorize color code
" needs go-lang
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }

" good looking modeline
Plug 'itchyny/lightline.vim'

if has('nvim')
  " neovim版previewpopup
  Plug 'ncm2/float-preview.nvim'
endif

" emacsのimenu-listっぽいやつ
" Plug 'preservim/tagbar'
Plug 'liuchengxu/vista.vim'

" ファイルにアイコンをつける
if has('nvim')
  Plug 'kyazdani42/nvim-web-devicons'
else
  Plug 'ryanoasis/vim-devicons'
endif

" . による繰り返し強化
Plug 'tpope/vim-repeat'

" deal with camelCase and snake_case
Plug 'chaoren/vim-wordmotion'

" 括弧関係
Plug 'tpope/vim-surround'

" 閉じ括弧挿入
Plug 'cohama/lexima.vim'

" " e sudo:%
" Plug 'lambdalisue/suda.vim'

" comments
Plug 'tpope/vim-commentary'

" align things like =
Plug 'junegunn/vim-easy-align'

" git情報を左に表示
Plug 'airblade/vim-gitgutter'

" git
Plug 'tpope/vim-fugitive'

" visualize undo-tree
" Plug 'simnalamburt/vim-mundo'
Plug 'mbbill/undotree'

" " The bang version will try to download the prebuilt binary if cargo does not exist.
" Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary!' }

" Plug 'junegunn/fzf.vim'
" Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/rpc' }

" " denite
" if has('nvim')
"   Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
" else
"   Plug 'Shougo/denite.nvim'
"   Plug 'roxma/nvim-yarp'
"   Plug 'roxma/vim-hug-neovim-rpc'
" endif

" 翻訳
if has('nvim')
  Plug 'voldikss/vim-translate-me'
else
  Plug 'skanehira/translate.vim'
endif

" jumping around the code
Plug 'easymotion/vim-easymotion'

" run commands only in visual block with :<,>B
Plug 'vim-scripts/vis'

" " auto-complete
" if has('nvim')
"   Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" else
"   " Plug 'Shougo/deoplete.nvim'
"   " Plug 'roxma/nvim-yarp'
"   " Plug 'roxma/vim-hug-neovim-rpc'
" endif

" " tabnine
" if has('nvim')
"   if has('win32') || has('win64')
"     Plug 'tbodt/deoplete-tabnine', { 'do': 'powershell.exe .\install.ps1' }
"   else
"     Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' }
"   endif
" else
"   Plug 'zxqfl/tabnine-vim'
" endif

" debugger
Plug 'puremourning/vimspector'

" " idris
" Plug 'idris-hackers/idris-vim'

" " lean
" Plug 'leanprover/lean.vim'
" " if has('nvim')
" "   Plug 'Julian/lean.nvim'
" "   Plug 'hrsh7th/nvim-compe'
" " endif

" symbols
Plug 'arthurxavierx/vim-unicoder'

" " Haskell syntax highlighting
" Plug 'neovimhaskell/haskell-vim'

" " rust
" Plug 'rust-lang/rust.vim'

" " R
" Plug 'jalvesaq/Nvim-R', {'branch': 'stable'}

" " fish script
" Plug 'dag/vim-fish'

" lsp
if has('nvim')
  " settings for neovim's builtin lsp client
  Plug 'neovim/nvim-lspconfig'
  " code completion
  Plug 'hrsh7th/nvim-compe'
  " fuzzy-finder, something like ivy
  " Plug 'nvim-lu/plenary.nvim'
  " Plug 'nvim-telescope/telescope.nvim'
else
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif

" if has('nvim')
" " キーバインドを表示
"   Plug 'folke/which-key.nvim'
" endif

" Initialize plugin system
call plug#end()

" colorscheme onedark

" color parentheses
" Plug 'luochen1990/rainbow'
" 抵抗のカラーコード
let s:colorcode_gui = [ '#9a4040', '#ff5e5e', '#ffaa77', '#dddd77', '#80ee80', '#66bbff', '#da6bda', '#afafaf', '#f0f0f0' ]
let s:colorcode_cterm = [ 6, 12, 6, 14, 10, 9, 13, 7, 15]
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle
let g:rainbow_conf = {
      \ 'guifgs' : s:colorcode_gui,
      \ 'ctermfgs' : s:colorcode_cterm,
      \ }


" colorize color code
" needs go-lang
" Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
let g:Hexokinase_highlighters = ['foreground']

" good looking modeline
" Plug 'itchyny/lightline.vim'
let g:lightline = {
      \ 'colorscheme' : 'one'
      \ }
set noshowmode


" " emacsのimenu-listっぽいやつ
" " Plug 'preservim/tagbar'
" let g:tagbar_position='topleft vertical'
" let g:tagbar_width=30
" " Define mappings
" " augroup MyTagbar
"   " autocmd!
"   " autocmd FileType tagbar call s:tagabar_my_settings()
"   " autocmd VimEnter * TagbarOpen
" " augroup END
" " function! s:tagabar_my_settings() abort
" " endfunction

" Vista
let g:vista_sidebar_position='vertical topleft'
let g:vista_sidebar_width = 15
" Ensure you have installed some decent font to show these pretty symbols,
" then you can enable icon for the kind.
let g:vista#renderer#enable_icon = 1
" The default icons can't be suitable for all the filetypes, you can extend it as you wish.
" let g:vista#renderer#icons = {
" \   "function": "\uf794",
" \   "variable": "\uf71b",
" \  }

" " neovim版previewpopup
" Plug 'ncm2/float-preview.nvim'
" let g:float_preview#docked = 0

" " 閉じ括弧挿入
" " Plug 'jiangmiao/auto-pairs'
" let g:AutoPairsFlyMode = 1


" " 括弧関係
" Plug 'tpope/vim-surround'
let g:surround_no_insert_mappings = 1


" e sudo:%
" Plug 'lambdalisue/suda.vim'
let g:suda_smart_edit = 1

" comments
" Plug 'tpope/vim-commentary'


" align things like =
" Plug 'junegunn/vim-easy-align'
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(LiveEasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(LiveEasyAlign)

" visualize undo-tree
" Plug 'simnalamburt/vim-mundo'
" C-zでmundo
" nnoremap <C-z> :MundoShow<CR>
nnoremap <C-z> :UndotreeToggle<CR>
" C-zでinser中にundo
inoremap <C-z> <C-G>u<C-R>

" git
" Plug 'tpope/vim-fugitive'

" " fuzzy finder, something like ivy
" Plug 'junegunn/fzf.vim'

" " denite
" " Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
" " Define mappings
" augroup MyDenite
"   autocmd!
"   autocmd FileType denite call s:denite_my_settings()
" augroup END
" function! s:denite_my_settings() abort
"   nnoremap <silent><buffer><expr> <CR>
"   \ denite#do_map('do_action')
"   nnoremap <silent><buffer><expr> d
"   \ denite#do_map('do_action', 'delete')
"   nnoremap <silent><buffer><expr> p
"   \ denite#do_map('do_action', 'preview')
"   nnoremap <silent><buffer><expr> <Esc>
"   \ denite#do_map('quit')
"   nnoremap <silent><buffer><expr> /
"   \ denite#do_map('open_filter_buffer')
"   nnoremap <silent><buffer><expr> <Space>
"   \ denite#do_map('toggle_select').'j'
" endfunction
" " Change denite default options
" if has('nvim')
"   call denite#custom#option('_', {
"         \ 'split' : 'floating',
"         \ 'vertical-preview' : v:true,
"         \ 'floating-preview' : v:true,
"         \ 'start_filter' : v:false
"         \ })
" endif


" 翻訳
if has('nvim')
  " Plug 'voldikss/vim-translate-me'
  let g:translator_source_lang='ja'
  let g:vtm_target_lang = 'en'
  let g:vtm_default_engines = ['google']
else
  " Plug 'skanehira/translate.vim'
  vmap t <Plug>(VTranslate)
  let g:translate_source = 'ja'
  let g:translate_target = 'en'
  let g:translate_popup_window = 1
endif

" jumping around the code
" Plug 'easymotion/vim-easymotion'
let g:EasyMotion_do_mapping = v:false " Disable default mappings
" 日本語対応
let g:EasyMotion_use_migemo = 1
" move to {char}
map f <Plug>(easymotion-bd-f)
map 2f <Plug>(easymotion-bd-f2)
" Move to word
map  gw <Plug>(easymotion-bd-w)
" Move to line
map gj <Plug>(easymotion-bd-jk)


" if has('nvim')
" " 補完
"   let g:deoplete#enable_at_startup = 1
"   " don't insert enter when confirming completion
"   let g:deoplete#on_insert_enter = v:false
"   " " <TAB>: completion.
"   " function! s:check_back_space() abort "{{{
"   "   let col = col('.') - 1
"   "   return !col || getline('.')[col - 1]  =~ '\s'
"   " endfunction"}}}
"   " inoremap <silent><expr> <TAB>
"   "       \ pumvisible() ? "\<C-n>" :
"   "       \ <SID>check_back_space() ? "\<TAB>" :
"   "       \ deoplete#manual_complete()
" endif

" haskell syntax highlighting
" Plug 'neovimhaskell/haskell-vim'


" debugger
" Plug 'puremourning/vimspector'
let g:vimspector_enable_mappings = 'VISUAL_STUDIO'

" idris
" Plug 'idris-hackers/idris-vim'
let g:idris_indent_if = 0
let g:idris_indent_case = 2
let g:idris_indent_let = 2
let g:idris_indent_where =2
let g:idris_indent_do = 2
let g:idris_indent_rewrite = 2

" " lean
" let g:compe = {}
" let g:compe.enabled = v:true
" let g:compe.autocomplete = v:true
" let g:compe.debug = v:false
" let g:compe.min_length = 1
" let g:compe.preselect = 'enable'
" let g:compe.throttle_time = 80
" let g:compe.source_timeout = 200
" let g:compe.incomplete_delay = 400
" let g:compe.max_abbr_width = 100
" let g:compe.max_kind_width = 100
" let g:compe.max_menu_width = 100
" let g:compe.documentation = v:true

" let g:compe.source = {}
" let g:compe.source.path = v:true
" let g:compe.source.buffer = v:true
" let g:compe.source.calc = v:true
" let g:compe.source.nvim_lsp = v:true
" let g:compe.source.nvim_lua = v:true
" let g:compe.source.vsnip = v:true
" let g:compe.source.ultisnips = v:true


" neovim builtin lsp client
if has('nvim')

" format on save
autocmd BufWritePre *.hs lua vim.lsp.buf.formatting_sync(nil, 1000)
autocmd BufWritePre *.hs.in lua vim.lsp.buf.formatting_sync(nil, 1000)

autocmd BufWritePre *.elm lua vim.lsp.buf.formatting_sync(nil, 1000)
autocmd BufWritePre *.elm.in lua vim.lsp.buf.formatting_sync(nil, 1000)

" keybinds
lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<Leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<Leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<Leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<Leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'z=', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<Leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<Leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<Leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

nvim_lsp.hls.setup{on_attach = on_attach}
nvim_lsp.elmls.setup{on_attach = on_attach}
EOF

" auto completion by compe
set completeopt=menuone,noselect
lua << EOF
-- Compe setup
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
  };
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

--This line is important for auto-import
vim.api.nvim_set_keymap('i', '<cr>', 'compe#confirm("<cr>")', { expr = true })
vim.api.nvim_set_keymap('i', '<c-space>', 'compe#complete()', { expr = true })
EOF

" NOTE: Order is important. You can't lazy loading lexima.vim.
let g:lexima_no_default_rules = v:true
call lexima#set_default_rules()
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm(lexima#expand('<LT>CR>', 'i'))
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })


" " " fuzzy-finder,Plug 'nvim-lua/plenary.nvim'
" " Plug 'nvim-telescope/telescope.nvim' something like ivy
" " Find files using Telescope command-line sugar.
" nnoremap <leader><C-f> <cmd>Telescope file_browser <cr>
" nnoremap <leader>fg <cmd>Telescope live_grep <cr>
" nnoremap <leader>b <cmd>Telescope buffers <cr>
" nnoremap <leader>fh <cmd>Telescope help_tags <cr>
" lua << EOF
" require('telescope').setup{
"   defaults = {
"     sorting_strategy = "ascending",
"     layout_strategy = "vertical",
"     -- externalize = true,
"     picker ={
"       theme = "dropdown",
"     },
"   }
" }
" EOF

endif


" " coc
" " Use space d to show documentation in preview window.
" nnoremap <silent> <space>d :call <SID>show_documentation()<CR>
" " space e for codeLens action
" nmap <silent> <space>e <Plug>(coc-codelens-action)

" function! s:show_documentation()
"   if (index(['vim','help'], &filetype) >= 0)
"     execute 'h '.expand('<cword>')
"   elseif (coc#rpc#ready())
"     call CocActionAsync('doHover')
"   else
"     execute '!' . &keywordprg . " " . expand('<cword>')
"   endif
" endfunction


" " キーバインドを表示
" Plug 'folke/which-key.nvim'
" lua << EOF
"   require("which-key").setup {
"     -- your configuration comes here
"     -- or leave it empty to use the default settings
"     -- refer to the configuration section below
"   }
" EOF

" yank from clipboard
set clipboard=unnamedplus


" undo履歴保持
if has('persistent_undo')
  if has('nvim')
    let s:undo_path=stdpath('data') . '/undo'
  else
    let s:undo_path=expand('~/.vim/undo')
  endif
  exe 'set undodir=' .. s:undo_path
  set undofile
endif


function! s:on_vim_enter() abort
  " Vista
endfunction

function! s:on_vim_leave() abort
  " Vista!
endfunction


" セッション自動保存
augroup SessionAutocommands
  autocmd!
  autocmd VimEnter * nested call <SID>RestoreSessionWithConfirm() | call s:on_vim_enter()
  autocmd VimLeave * nested call <SID>SaveSessionWithConfirm() | call s:on_vim_leave()
  " autocmd VimLeave * call s:on_vim_leave() | SaveSession
augroup END

if has ('nvim')
  command! RestoreSession :source ~/.local/share/nvim/.session
  command! SaveSession    :mksession! ~/.local/share/nvim/.session
else
  command! RestoreSession :source ~/.vim/.session
  command! SaveSession    :mksession! ~/.vim/.session
endif
" Restore session with confirm
function! s:RestoreSessionWithConfirm()
  let msg = 'Do you want to restore previous session?'

  if !argc() && confirm(msg, "&Yes\n&No", 1, 'Question') == 1
    execute 'RestoreSession'
  endif
endfunction
" Save session with confirm
function! s:SaveSessionWithConfirm()
  let msg = 'Do you want to save this session?'

  if !argc() && confirm(msg, "&Yes\n&No", 1, 'Question') == 1
    execute 'SaveSession'
  endif
endfunction


else

" ESC連打でハイライト解除
" nnoremap <Esc><Esc> :nohlsearch<CR><Esc>
nnoremap <silent> <Esc><Esc> :let @/ = ""<CR><Esc>

" C-g を Escape の代わりに
inoremap <C-g> <Esc>
cnoremap <C-g> <C-C>

" yank from clipboard
set clipboard=unnamedplus

let g:plug_window='topleft new'
" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin(stdpath('data') . '/plugged-vscode')
" Make sure you use single quotes

" 括弧関係
Plug 'tpope/vim-surround'

" deal with camelCase and snake_case
Plug 'chaoren/vim-wordmotion'

" jumping around the code
Plug 'asvetliakov/vim-easymotion'
call plug#end()

" jumping around the code
" Plug 'easymotion/vim-easymotion'
let g:Easymotion_do_mapping = 0
" move to {char}
map f <Plug>(easymotion-bd-f)
map 2f <Plug>(easymotion-bd-f2)
" Move to word
map  gw <Plug>(easymotion-bd-w)
" Move to line
map gj <Plug>(easymotion-bd-jk)

" comments using vscode features
xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

endif

