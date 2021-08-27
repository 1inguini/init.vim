" python3を使わせるために適当にpython3を実行
if !has('nvim')
 python3 0
endif

if !exists('g:vscode')

" setting

"文字コードをUTF-8に設定
set fenc=utf-8
set encoding=utf8

augroup config | autocmd! | augroup END

" Keybindings
" ----------------------------------------

" set <Leader> key
let mapleader = "\<Space>"

map <M-m> <Leader>

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

" use 'm' for 'Macro' for defining macros
nnoremap <unique> m q
nnoremap q <NOP>

" use 'qq' as <Esc>
map <unique><nowait> qq <Esc>
inoremap <unique> qq <Esc>
inoremap <unique> q<Space> q

" remap hjkl u to hjuk l
map <unique> u <Up>
map <unique> k <Right>
map <unique> U <S-Up>
map <unique> K <S-Right>
map <unique> <C-u> <C-Up>
map <unique> <C-k> <C-Right>
" nnoremap <S-Down> J
" nmap h <Left>
" nmap <unique> k <Right>
nnoremap <unique> <C-w>u <C-w>k
nnoremap <unique> <C-w>k <C-w>l
nnoremap <unique> <C-w>U <C-w>K
nnoremap <unique> <C-w>K <C-w>L
noremap <unique> l u
noremap <unique> L U

" 折り返し時に表示行単位での移動できるようにする
noremap <Up> g<Up>
noremap <Down> g<Down>

" " 行末が改行を含まないようにする
" noremap $ g_

" cut won't de pasted on default
noremap P "+p
" noremap "+p p

" ESC連打でハイライト解除
" nnoremap <Esc><Esc> <CMD>nohlsearch<CR><Esc>
nnoremap <unique><silent> <Esc> <CMD>cclose <BAR> let @/ = ''<CR>
nnoremap <unique><silent> qc <CMD>cclose<CR>

" visual / で選択中のものを検索、* でハイライト
vnoremap / y/\V<C-R>=escape(@",'/\')<CR><CR>
vnoremap * y/\V<C-R>=escape(@",'/\')<CR><CR><CR>

nnoremap <unique> n <CMD>cnext<CR>
nnoremap <unique> N <CMD>cprevious<CR>

" C-s で保存、ついでに再描画
nnoremap <silent> <C-s> <CMD>w<CR>
inoremap <silent> <C-s> <ESC><CMD>w<CR>a

" normal modeでEnterで1行入力
nnoremap <CR> o<Esc>
nnoremap <S-CR> o<Esc>

" Esc for escaping terminal
if has('nvim')
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-\><Esc> <Esc>
endif

" ウィンドウを移動したら行頭にスクロール
autocmd config WinLeave * normal 200zh
autocmd config WinEnter * normal 201zh

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

" g     rep after incsearch
function! s:grep_incsearch(cmdtype) abort
  echo a:cmdtype
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

 " auto QuickFix
 autocmd QuickfixCmdPost make,*grep* copen

" UI
" ----------------------------------------

" width of sidebars(defined by me:linguini)
let g:sidebar_width = 30

" 文字の折返しの無効化
set nowrap

" remove -- INSERT -- because it will be shown in statusline
set noshowmode

set foldmethod=syntax

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

  " send command with <C-Enter>
  nnoremap <buffer> <C-CR> <C-c>
  inoremap <buffer> <C-CR> <C-c>

  " disable line numbers
  setlocal nonumber
endfunction
autocmd config CmdWinEnter * call s:cmdwin_local()


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


" " マルチバイト文字の表示をいい感じに
set ambiwidth=double


" enable mouse
set mouse=a


" nice terminal color
set termguicolors


" automaticly cd to opened file
if has('autochdir')
  set autochdir
endif

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


" terminal関係
" shellをfishに
set shell=fish


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
if has('nvim')
  let s:toml_file = stdpath('config') . '/dein.toml'
  call dein#load_toml(s:toml_file)
else
  let s:toml_file = '~/.vim/dein.toml'
  call dein#load_toml(s:toml_file)
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


" function! s:clean_misc(buf) abort
"   if empty(&filetype) || &filetype == 'help'
"     execute 'bdelete ' . a:buf
"   endif
" endfunction
" autocmd config SessionLoadPost * call s:clean_misc(expand('<afile>'))  

autocmd config VimLeave * if &buftype == 'nofile' | execute 'bdelete '  . expand('<afile>') | endif



" sessions settings
set sessionoptions=buffers,curdir,folds,resize,tabpages,terminal,winsize

" セッション自動保存
augroup SessionAutocommands
  autocmd!
  autocmd VimEnter * nested call <SID>RestoreSessionWithConfirm()
  autocmd VimLeave * nested call <SID>SaveSessionWithConfirm()
  " autocmd VimLeave * call s:on_vim_leave() | SaveSession
augroup END

if has ('nvim')
  command! RestoreSession source ~/.local/share/nvim/.session
  command! SaveSession    mksession! ~/.local/share/nvim/.session
else
  command! RestoreSession source ~/.vim/.session
  command! SaveSession    mksession! ~/.vim/.session
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

