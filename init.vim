" python3を使わせるために適当にpython3を実行
if !has('nvim')
  python3 0
endif


" setting
"文字コードをUTF-8に設定
set fenc=utf-8
set encoding=utf8
" " バックアップファイルを作らない
" set nobackup
set backup
" " スワップファイルを作らない
" set noswapfile
set swapfile
if has('nvim')
  execute 'set backupdir=' . stdpath('data') . '/backup'
  execute 'set directory=' . stdpath('data') . '/backup'
else
  set backupdir=~/.vim/backup
  set directory=~/.vim/backup
endif
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" バッファが編集中でもその他のファイルを開けるように
set hidden
" 入力中のコマンドをステータスに表示する
set showcmd


" 見た目系
" 行番号を表示_
set number
" 現在の行を強調表示
set cursorline
" 現在の行を強調表示（縦）
set cursorcolumn
" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore
" インデントはスマートインデント
set smartindent
" ビープ音を可視化
set visualbell
" 括弧入力時の対応する括弧を表示
set showmatch
" ステータスラインを常に表示
set laststatus=2
" コマンドラインの補完
set wildmode=list:longest
" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk
" シンタックスハイライトの有効化
syntax enable


" Tab系
" 不可視文字を可視化(タブが「▸-」と表示される)
set list listchars=tab:\▸\-
" Tab文字を半角スペースにする
set expandtab
" 行頭以外のTab文字の表示幅（スペースいくつ分）
set tabstop=2
" 行頭でのTab文字の表示幅
set shiftwidth=2


" 検索系
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
" set ignore case
" 検索文字列に大文字が含まれている場合は区別して検索する
" set smart case
" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
" 検索時に最後まで行ったら最初に戻る
set wrapscan
" 検索語をハイライト表示
set hlsearch
" ESC連打でハイライト解除
" nnoremap <Esc><Esc> :nohlsearch<CR><Esc>
nnoremap <Esc><Esc> :let @/ = ""<CR><Esc>

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


" enable mouse
set mouse=a


" nice terminal color
set termguicolors


" automaticly cd to opened file
if has('autochdir')
  set autochdir
endif


" comple for command mode
set wildmenu
set wildmode=full


" spellcheck
" set spell
" ignore Japanese
set spelllang=en,cjk
nmap z= :Denite spell<CR>


" " use popup window instead of preview window
" set completeopt=menu,popup
" set previewpopup=height:10,width:60


" line wrap with indent
set breakindent

" terminal関係
" shellをfishに
set shell=fish
if !has('nvim')
  " :etermで現在のwindowで開く
  command! ETerm terminal! ++curwin ++noclose
  CommandCabbr eterm ETerm
endif


" C-sで保存
noremap <C-s> :w<CR>
nnoremap <C-s> :w<CR>
inoremap <C-s> <ESC>:w<CR>a


" normal modeでEnterで一文字入力
nnoremap <CR> i_<Esc>r


" Esc for escaping terminal
if has('nvim')
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-\><Esc> <Esc>
endif

" :bd でwindowを閉じずに現在のbufferをdelete
" https://stackoverflow.com/a/19620009
" BufferDeleteNoCloseWindowでbdを置き換え
command! -bang BufferDeleteNoCloseWindow buffer#|bdelete<bang>#
CommandCabbr bd BufferDeleteNoCloseWindow


if has("gui_running") || has('g:GuiLoaded')
  " カラースキーム
  " color scheme koehler
  " ダーク系のカラースキームを使う
  " set background=dark
  " set previewpopup=true

  " fonts
  set guifontwide=NotoSansMonoCJK
  set guifont=Inconsolata


  set guioptions-=T
  " set guioptions=m


  " 左右のスクロールバーを消す
  set guioptions-=r
  set guioptions-=R
  set guioptions-=l
  set guioptions-=L
endif


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

" themes
Plug 'joshdick/onedark.vim'
Plug 'sonph/onehalf', { 'rtp': 'vim' }
Plug 'jacoborus/tender.vim'
Plug 'romainl/Apprentice'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'ErichDonGubler/vim-sublime-monokai'

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

" . による繰り返し強化
Plug 'tpope/vim-repeat'

" deal with camelCase and snake_case
Plug 'chaoren/vim-wordmotion'

" 括弧関係
Plug 'tpope/vim-surround'

" 閉じ括弧挿入
Plug 'jiangmiao/auto-pairs'

" e sudo:%
Plug 'lambdalisue/suda.vim'

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

" denite
if has('nvim')
  Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/denite.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

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

" idris
Plug 'idris-hackers/idris-vim'

" Haskell syntax highlighting
Plug 'neovimhaskell/haskell-vim'

" rust
Plug 'rust-lang/rust.vim'

" R
Plug 'jalvesaq/Nvim-R', {'branch': 'stable'}

" fish script
Plug 'dag/vim-fish'

" lsp
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Initialize plugin system
call plug#end()

colorscheme onedark

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
      \ 'colorscheme' : 'onehalfdark'
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
" Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
let g:vista#renderer#enable_icon = 1
" The default icons can't be suitable for all the filetypes, you can extend it as you wish.
" let g:vista#renderer#icons = {
" \   "function": "\uf794",
" \   "variable": "\uf71b",
" \  }

" " neovim版previewpopup
" Plug 'ncm2/float-preview.nvim'
" let g:float_preview#docked = 0

" 閉じ括弧挿入
" Plug 'jiangmiao/auto-pairs'
let g:AutoPairsFlyMode = 1

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

" denite
" Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
" Define mappings
augroup MyDenite
  autocmd!
  autocmd FileType denite call s:denite_my_settings()
augroup END
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> /
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select').'j'
endfunction
" Change denite default options
if has('nvim')
  call denite#custom#option('_', {
        \ 'split' : 'floating',
        \ 'vertical-preview' : v:true,
        \ 'floating-preview' : v:true,
        \ 'start_filter' : v:false
        \ })
endif


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
let g:Easymotion_do_mapping = 0
" <C-Tab>{char} to move to {char}
map <C-Tab> <Plug>(easymotion-bd-f)
nmap <C-Tab> <Plug>(easymotion-overwin-f)
" " reaplace search
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)


if has('nvim')
" 補完
  let g:deoplete#enable_at_startup = 1
  " don't insert enter when confirming completion
  let g:deoplete#on_insert_enter = v:false
  " " <TAB>: completion.
  " function! s:check_back_space() abort "{{{
  "   let col = col('.') - 1
  "   return !col || getline('.')[col - 1]  =~ '\s'
  " endfunction"}}}
  " inoremap <silent><expr> <TAB>
  "       \ pumvisible() ? "\<C-n>" :
  "       \ <SID>check_back_space() ? "\<TAB>" :
  "       \ deoplete#manual_complete()
endif

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


" coc
" Use space d to show documentation in preview window.
nnoremap <silent> <space>d :call <SID>show_documentation()<CR>
" space e for codeLens action
nmap <silent> <space>e <Plug>(coc-codelens-action)

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction


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
  Vista
endfunction

function! s:on_vim_leave() abort
  Vista!
endfunction


" セッション自動保存
augroup SessionAutocommands
  autocmd!
  autocmd VimEnter * nested call <SID>RestoreSessionWithConfirm() | call s:on_vim_enter()
  autocmd VimLeave * call s:on_vim_leave() | SaveSession
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
