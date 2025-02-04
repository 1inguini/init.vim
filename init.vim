" " python3を使わせるために適当にpython3を実行
" if !has('nvim')
"  python3 0
" endif

" setting

augroup config | autocmd! | augroup END

" yank from clipboard
set clipboard=unnamedplus

"文字コードをUTF-8に設定
set fenc=utf-8
set encoding=utf8


" Keybindings
" ----------------------------------------

" set <Leader> key
let mapleader = "\<Space>"

map <M-m> <Leader>

" normal modeでEnterで1行入力
nnoremap <CR> o<Esc>

" ESC連打でハイライト解除
nnoremap <unique><silent> <Esc> <CMD>let @/ = '' <BAR> cclose<CR>

" visual / で選択中のものを検索、* でハイライト
vnoremap / y/\V<C-R>=escape(@",'/\')<CR><CR>
vnoremap * y/\V<C-R>=escape(@",'/\')<CR><CR><CR>
nnoremap * */<Up><CR>

" C-s で保存、ついでに再描画
nnoremap <silent> <C-s> <CMD>w<CR>
inoremap <silent> <C-s> <ESC><CMD>w<CR>a


" " バックアップファイルを作る
set backup
" " スワップファイルを作る
set swapfile
if has('nvim')
  execute 'set backupdir=' . stdpath('data') . '/backup'
  execute 'set directory=' . stdpath('data') . '/backup'
else
  set backupdir=~/.vim/backup
  set directory=~/.vim/backup
endif


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

" vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync
endif


if !exists('g:vscode')

" 端末のVimでもAltキーとC-Spaceを使えるように
" https://thinca.hatenablog.com/entry/20101215/1292340358
if has('unix') && !has('gui_running')
  " Use meta keys in console.
  function! s:use_meta_keys()  " {{{
    for i in map(
    \   range(char2nr('a'), char2nr('z'))
    \ + range(char2nr('A'), char2nr('Z'))
    \ + range(char2nr('0'), char2nr('9'))
    \ , 'nr2char(v:val)')
      " <ESC>O do not map because used by arrow keys.
      if i != 'O'
        execute 'nmap <ESC>' . i '<M-' . i . '>'
      endif
    endfor
  endfunction  " }}}

  call s:use_meta_keys()
  map <NUL> <C-Space>
  map! <NUL> <C-Space>
endif

" use 'qq' as <Esc>
" inoremap <unique><nowait> <qq> <Esc>
" take care of this in lexima

" " remap hjkl u to hjuk l
" map <unique> u <Up>
" map <unique> k <Right>
" map <unique> U <S-Up>
" map <unique> K <S-Right>
" map <unique> <C-u> <C-Up>
" map <unique> <C-k> <C-Right>
" map <unique> <C-j> <C-Down>
" " nnoremap <S-Down> J
" nmap h <Left>
" nnoremap <unique> <C-w>u <C-w>k
" nnoremap <unique> <C-w>k <C-w>l
" nnoremap <unique> <C-w>U <C-w>K
" nnoremap <unique> <C-w>K <C-w>L
" noremap <unique> l u
" noremap <unique> L U

" 折り返し時に表示行単位での移動できるようにする
noremap <Up> g<Up>
noremap <Down> g<Down>

" <C-Up|Down>でページめくり
nnoremap <unique> <C-Up> <C-u>
nnoremap <unique> <C-Down> <C-d>

" " 行末が改行を含まないようにする
" noremap $ g_

" cut won't de pasted on default
noremap P \"+p
" noremap \"+p p

" Esc for escaping terminal
if has('nvim')
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-\><Esc> <Esc>
endif

inoremap <C-v>u <C-r>=nr2char(0x)<Left>

"" ウィンドウを移動したら行頭にスクロール
"autocmd config WinLeave * normal 200zh
"autocmd config WinEnter * normal 201zh

" command to abbreviate commands
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
command! -bang Bd buffer#|bdelete<bang>#

" grep after incsearch
function! s:grep_incsearch(cmdtype) abort
  if a:cmdtype == '/' || a:cmdtype == '?'
    let l:cmdline = getcmdline()
    if !empty(l:cmdline)
      execute 'silent vimgrep "' . escape(l:cmdline, '"') . '" %'
    endif
  endif
endfunction
autocmd config CmdlineLeave * execute 'call s:grep_incsearch(''' . expand('<afile>') . ''')'

" use ripgrep if avaliable
if executable('rg')
  set grepprg=rg\ --vimgrep
  set grepformat=%f:%l:%c:%m
endif

" UI
" ----------------------------------------

" width of sidebars(defined by me:linguini)
let g:sidebar_width = 30

" 文字の折返しの無効化
" set nowrap

" remove -- INSERT -- because it will be shown in statusline
" set noshowmode

set foldmethod=syntax
set foldcolumn=3
set foldlevel=100
set fillchars=foldopen:,foldsep:┊,foldclose:

" make comments italic
autocmd config ColorScheme * highlight Comment term=italic cterm=italic gui=italic

" Quickfix
" ----------------------------------------

" autocmd config QuickfixCmdPost make,*grep* copen

nnoremap <unique><silent> qc <CMD>cclose<CR>
nnoremap <unique><silent> qo <CMD>copen<CR>

function s:quickfix_init() abort
  nnoremap n <CMD>cnext<CR>
  nnoremap N <CMD>cprevious<CR>
endfunction

function s:quickfix_clean() abort
  nnoremap n n
  nnoremap N N
endfunction

autocmd config BufWinEnter quickfix call s:quickfix_init()
autocmd config BufWinLeave quickfix call s:quickfix_clean()

" Command Line Window
" ----------------------------------------

" open commandline window with :
nnoremap : q:i
vnoremap : q:i

" make it bigger
set cmdwinheight=20

function! s:cmdwin_local() abort

  " search backwords with current line
  nnoremap <buffer> / yy?<C-r>"

  " close commandline window with qq
  nnoremap <buffer> qq <CMD>q<CR>
  vnoremap <buffer> qq <Esc><CMD>q<CR>
  " inoremap <buffer> <C-c> <Esc><CMD>q<CR>

  " send command with <Enter>
  nnoremap <buffer> <CR> <C-c><CR>
  inoremap <buffer> <CR> <Esc><C-c><CR>

  " disable line numbers
  setlocal nonumber
endfunction
autocmd config CmdWinEnter * call s:cmdwin_local()



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
set nowildmenu
set wildmode=list:longest,full

" Tab系
" 不可視文字を可視化(タブが「▸-」と表示される)
set list listchars=tab:\▸\-
" Tab文字を半角スペースにする
set expandtab
" 行頭以外のTab文字の表示幅（スペースいくつ分）
set tabstop=8
" 行頭でのTab文字の表示幅
set shiftwidth=2




" " マルチバイト文字の表示をいい感じに
" set ambiwidth=double


" enable mouse
set mouse=a


" nice terminal color
set termguicolors


" " automaticly cd to opened file
" if has('autochdir')
"   set autochdir
" endif

" spellcheck
" set spell
" ignore Japanese
set spelllang=en,cjk

" " use popup window instead of preview window
" set completeopt=menu,popup
" set previewpopup=height:10,width:60


" line wrap with indent
set breakindent

set colorcolumn=80,+1
set textwidth=99
set formatoptions=jqlt


" 言語ごとに別のインデント
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
"    autocmd InsertLeave * call system('fcitx5-remote -c')
"    autocmd CmdlineLeave * call system('fcitx5-remote -c')
" elseif executable('fcitx')
"    autocmd InsertLeave * call system('fcitx-remote -c')
"    autocmd CmdlineLeave * call system('fcitx-remote -c')
" endif

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


" function! s:clean_misc(buf) abort
"   if empty(&filetype) || &filetype == 'help'
"     execute 'bdelete ' . a:buf
"   endif
" endfunction
" autocmd config SessionLoadPost * call s:clean_misc(expand('<afile>'))

autocmd config VimLeave * if &buftype == 'nofile' | execute 'bdelete '  . expand('<afile>') | endif

" sessions settings
set sessionoptions=buffers,curdir,folds,resize,tabpages,terminal,winsize

" " セッション自動保存
" augroup SessionAutocommands
"   autocmd!
"   autocmd VimEnter * nested call <SID>RestoreSessionWithConfirm()
"   autocmd VimLeave * nested call <SID>SaveSessionWithConfirm()
"   " autocmd VimLeave * call s:on_vim_leave() | SaveSession
" augroup END

" if has ('nvim')
"   command! RestoreSession source ~/.local/share/nvim/.session
"   command! SaveSession    mksession! ~/.local/share/nvim/.session
" else
"   command! RestoreSession source ~/.vim/.session
"   command! SaveSession    mksession! ~/.vim/.session
" endif
" " Restore session with confirm
" function! s:RestoreSessionWithConfirm()
"   let msg = 'Do you want to restore previous session?'

"   if !argc() && confirm(msg, "&Yes\n&No", 1, 'Question') == 1
"     execute 'RestoreSession'
"   endif
" endfunction
" " Save session with confirm
" function! s:SaveSessionWithConfirm()
"   let msg = 'Do you want to save this session?'

"   if !argc() && confirm(msg, "&Yes\n&No", 1, 'Question') == 1
"     execute 'SaveSession'
"   endif
" endfunction

" Plugins
call plug#begin()

if has("nvim")
  Plug 'kyazdani42/nvim-web-devicons'
endif

" Colorschemes
" ----------------------------------------
if has("nvim")
  Plug 'navarasu/onedark.nvim'
else
  Plug 'joshdick/onedark.vim'
endif
Plug 'ayu-theme/ayu-vim'
Plug 'sonph/onehalf', { 'rtp': 'vim' }
Plug 'jacoborus/tender.vim'
Plug 'romainl/Apprentice'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'ErichDonGubler/vim-sublime-monokai'

" visualize undo-tree
Plug 'mbbill/undotree'

" indent guides
Plug 'yggdroot/indentline'

" highlight and remove whitespaces
Plug 'ntpeters/vim-better-whitespace'

" color parenthesizes
Plug 'luochen1990/rainbow'

" show the color of colorcodes
if executable('go')
  Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
endif

" deal with camelCase and snake_case
Plug 'chaoren/vim-wordmotion'

" comment out things
Plug 'tomtom/tcomment_vim'

" align things like =
Plug 'junegunn/vim-easy-align'

" run commands only in visual block with :<,>B
Plug 'vim-scripts/vis'

" surround textobjects with parentheses
Plug 'machakann/vim-sandwich'

" 閉じ括弧挿入
Plug 'cohama/lexima.vim'

" git情報を左に表示
Plug 'airblade/vim-gitgutter'

" キーバインドを表示
if has("nvim")
  Plug 'folke/which-key.nvim'
else
  Plug 'liuchengxu/vim-which-key'
endif

" edit with sudo
Plug 'lambdalisue/suda.vim'

" 現在のカーソル位置のコンテキストによって filetype を切り換える為のプラグイン
Plug 'osyo-manga/vim-precious'

" カーソル位置のコンテキストのftを判定するライブラリ
Plug 'Shougo/context_filetype.vim'

call plug#end()

" onedark
autocmd config VimEnter * nested
      \ set background=dark |
      \ colorscheme onedark


" Undotree: visualize undo-tree
" ----------------------------------------

" toggle Undotree (Sidebar Log)
nnoremap sl :UndotreeToggle<CR>

" buffer init hook
function! g:Undotree_CustomMap() abort
  nmap <buffer> ? <Plug>UndoreeHelp
  " <Plug>UndotreeFocusTarget is equal to UndotreeClose in my config
  nmap <buffer><nowait> q <Plug>UndotreeClose
  nmap <buffer><nowait> <Esc> <Plug>UndotreeClose
  nmap <buffer> <CR> <Plug>UndotreeClose
  nunmap <buffer> <Tab>
  " remove <Plug>UndotreeClearHistory
  nunmap <buffer> C
  " 't' for 'Timestamp'
  nmap <buffer> t <Plug>UndotreeTimestampToggle
  " 'd' for 'Diff'
  nmap <buffer> d <Plug>UndotreeDiffToggle
  nmap <buffer> <Up> <Plug>UndotreeNextState
  nmap <buffer> <Down> <Plug>UndotreePreviousState
  nmap <buffer> <S-Up> <Plug>UndotreeNextSavedState
  nmap <buffer> <S-Down> <Plug>UndotreePreviousSavedState
  " 'u' for <Plug>UndotreeUndo interferes with 'u' for 'Up'
  nunmap <buffer> u
  nmap <buffer> l <Plug>UndotreeUndo
  nmap <buffer> <C-r> <Plug>UndotreeRedo
  " Move to current state
  nmap <buffer> % <Plug>UndotreeEnter

  " automaticly close on WinLeave
  augroup undotree-autoclose
    autocmd!
    autocmd InsertEnter * UndotreeHide
  augroup END

endfunction

let g:undotree_SplitWidth = g:sidebar_width

" tree at the left, diff at the under
let g:undotree_WindowLayout = 2

" focus on open
let g:undotree_SetFocusWhenToggle = v:true

" clean leftover suda window from last session
"
autocmd config SessionLoadPost * silent! bdelete undotree


" indentline
let g:indentLine_char_list = ['┊']

" vim-sandwich
let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)

" rainbow
" 抵抗のカラーコード
let s:colorcode_gui = [
      \ '#9a4040', '#ff5e5e', '#ffaa77', '#dddd77',
      \ '#80ee80', '#66bbff', '#da6bda', '#afafaf', '#f0f0f0'
      \ ]
let s:colorcode_cterm = [ 6, 12, 6, 14, 10, 9, 13, 7, 15]

let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle
let g:rainbow_conf = {
      \ 'guifgs' : s:colorcode_gui,
      \ 'ctermfgs' : s:colorcode_cterm,
      \ }
augroup config Colorschemes * RainbowToggleOn

" vim-hexokinase
let g:Hexokinase_highlighters = ['foreground']

" tcomment_vim
let g:tcomment#blank_lines = 0

" vim-easy-align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(LiveEasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(LiveEasyAlign)

" lexima.vim
let g:lexima_enable_basic_rules = v:true
let g:lexima_enable_newline_rules = v:true
let g:lexima_enable_endwise_rules = v:true
" use '<Enter>' as <Esc>
let g:lexima_map_escape = 'qq'

if has("nvim")
  noremap ? :WhichKey<CR>

  lua << EOF
require('which-key').setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    plugins = {
      spelling = {
        enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      },
    },
  }
EOF
endif

" suda.vim
let g:suda_smart_edit = 1
" clean leftover suda window from last session
autocmd config SessionLoadPost * silent! bdelete suda

" vim-precious
" NORMALモードのカーソル移動中に頻繁に切り替わるとうざいのでデフォは無効化しておく(helpは例外)
let g:precious_enable_switch_CursorMoved = { '*': 0, 'help': 1, 'git': 1}
" INSERTモードのON／OFFに合わせてトグル
autocmd config InsertEnter * PreciousSwitch
autocmd config InsertLeave * PreciousReset

else

" Plugins
call plug#begin()

" deal with camelCase and snake_case
Plug 'chaoren/vim-wordmotion'

" align things like =
Plug 'junegunn/vim-easy-align'

" surround textobjects with parentheses
Plug 'machakann/vim-sandwich'

call plug#end()

" vim-sandwich
let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)


endif

