" -*- mode: vimrc -*-
"vim: ft=vim

" dotspaceneovim/auto-install {{{
  "Automatic installation of spaceneovim.
  let s:config_dir = $HOME . '/.config/nvim'
  let s:autoload_spaceneovim = expand(resolve(s:config_dir . '/autoload/spaceneovim.vim'))
  if empty(glob(s:autoload_spaceneovim))
    let s:install_spaceneovim = jobstart([
    \  'curl', '-fLo', s:autoload_spaceneovim, '--create-dirs',
    \  'https://raw.githubusercontent.com/tehnix/spaceneovim/master/autoload/spaceneovim.vim'
    \])
    let s:waiting_for_install = jobwait([s:install_spaceneovim])
  endif
" }}}

" dotspaceneovim/layers {{{
  "Configuration Layers declaration.
  "You should not put any user code in this block.

  let g:dotspaceneovim_configuration_layers = [
  \  '+nav/buffers'
  \, '+nav/files'
  \, '+nav/quit'
  \, '+nav/windows'
  \, '+nav/start-screen'
  \, '+nav/text'
  \, '+checkers/neomake'
  \, '+completion/deoplete'
  \, '+tools/terminal'
  \, '+ui/airline'
  \, '+ui/toggles'
  \]

  let g:dotspaceneovim_additional_packages = [
  \  {'name': 'flazz/vim-colorschemes', 'config': {}}
  \]

  let g:dotspaceneovim_excluded_packages = []
  " let g:dotspaceneovim_escape_key_sequence = 'fd'
" }}}

" dotspaceneovim/init {{{
  "Initialization block.
  "This block is called at the very startup of Spacemacs initialization
  "before layers configuration.
  "You should not put any user code in there besides modifying the variable
  "values.
  " Map the leader key to <Space>
  let g:mapleader = ','
  " Shorten the time before the vim-leader-guide buffer appears
  set timeoutlen=100
  " Enable line numbers
  " Set 7 lines to the cursor - when moving vertically using j/k
  set scrolloff=7
  " Use relative line numbers. Options are:
  " - relativenumber/norelativenumber
  " - number/nonumber
  set relativenumber
  " Always show the status line
  set laststatus=2
" }}}

" dotspaceneovim/user-init {{{
  "Initialization block for user code.
  "It is run immediately after `dotspaceneovim/init', before layer
  "configuration executes.
  "This block is mostly useful for variables that need to be set
  "before packages are loaded. If you are unsure, you should try in setting
  "them in`dotspaceneovim/user-config' first."

  " Load external user-init if found
  if filereadable(s:config_dir . '/user-init.vim')
    execute 'source ' . s:config_dir . '/user-init.vim'
  endif
" }}}

call spaceneovim#bootstrap()

" dotspaceneovim/user-config {{{
  "Configuration block for user code.
  "This function is called at the very end of SpaceNeovim initialization after
  "layers configuration.
  "This is the place where most of your configurations should be done. Unless
  "it is explicitly specified that a variable should be set before a package is
  "loaded, you should place your code here."
  " Set default colorscheme to wombat256mod and the background to dark
  set background=dark
  try | colorscheme wombat256mod | catch | endtry

  " Load external user-config if found
  if filereadable(s:config_dir . '/user-config.vim')
    execute 'source ' . s:config_dir . '/user-config.vim'
  endif
" }}}

call plug#begin('~/.config/nvim/plugged')
Plug 'neomake/neomake'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'rking/ag.vim'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'fatih/vim-go'
Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-fugitive'
call plug#end()

nnoremap <C-p> :FZF<CR>

" Plugins
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

" Style
syntax on
colorscheme onedark

set tabstop=2
set shiftwidth=2

" Spacing
autocmd FileType * set tabstop=2|set shiftwidth=2|set expandtab
autocmd FileType php set tabstop=4|set shiftwidth=4|set expandtab
autocmd FileType python set tabstop=4|set shiftwidth=4|set expandtab
autocmd FileType go set tabstop=4|set shiftwidth=4|set expandtab

" Misc
set nohlsearch
set showcmd
set showmode
set linespace=0
set number
set expandtab
set splitbelow          " Horizontal split below current.
set splitright          " Vertical split to right of current.

" Set clipboard
set clipboard=unnamed

" Open buffer menu
nnoremap <Leader>b :CtrlPBuffer<CR>
" Open most recently used files
nnoremap <Leader>f :CtrlPMRUFiles<CR>

let g:airline#extensions#tabline#enabled = 2
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#right_sep = ' '
let g:airline#extensions#tabline#right_alt_sep = '|'
let g:airline_left_sep = ' '
let g:airline_left_alt_sep = '|'
let g:airline_right_sep = ' '
let g:airline_right_alt_sep = '|'
let g:airline_theme= 'onedark'

function! DefaultWorkspace()

    " Rough num columns to decide between laptop and big monitor screens
    let numcol = 3

		autocmd VimEnter * NERDTree
		autocmd VimEnter * wincmd p

		sp term://zsh
    resize 8
		file Shell

endfunction

:au BufEnter * if &buftype == 'terminal' | :startinsert | endif

command! -register DefaultWorkspace call DefaultWorkspace()
