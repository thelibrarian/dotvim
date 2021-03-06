set nocompatible
" Turn 'filetype' on so that we can turn it off without error.
filetype on
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

" Load my bundles
source ~/.vim/vundle.vim
source ~/.vim/vundle-local.vim

filetype plugin indent on

if version >= 703
  set relativenumber
else
  set number
endif
set ruler
syntax on
set hidden
set statusline=%t\ %m[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%r%y%=%c,%l/%L\ %P

" Set encoding
set encoding=utf-8

" Set spelling language
set spelllang=en_au

" Whitespace stuff
set nowrap
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set list listchars=tab:\ \ ,trail:·

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,tmp/cache/**,public/assets/**,*.png,*.jpg

" Status bar
set laststatus=2
set ch=1

" Without setting this, ZoomWin restores windows in a way that causes
" equalalways behavior to be triggered the next time CommandT is used.
" This is likely a bludgeon to solve some other issue, but it works
set noequalalways

" Command-T configuration
let g:CommandTMaxHeight=20

" ZoomWin configuration
map <Leader><Leader> :ZoomWin<CR>

" CTags
map <Leader>rt :!ctags --extra=+f -R *<CR><CR>

" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

function s:setupWrapping()
  set wrap
  set wm=2
  set textwidth=72
endfunction

function s:setupMarkup()
  call s:setupWrapping()
  map <buffer> <Leader>p :Mm <CR>
endfunction

" make uses real tabs
au FileType make                                     set noexpandtab

" Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
au BufRead,BufNewFile {Capfile,Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru}    set ft=ruby

" md, markdown, and mk are markdown and define buffer-local preview
au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} call s:setupMarkup()

au BufRead,BufNewFile *.txt call s:setupWrapping()

" nginx.conf syntax
au BufRead,BufNewFile nginx.conf set ft=nginx

" make python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
au FileType python  set tabstop=4 textwidth=79

" Enable ragtag for haml files
au FileType haml call RagtagInit()

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" load the plugin and indent settings for the detected filetype
filetype plugin indent on

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <Leader>e
map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <Leader>t
map <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Inserts the path of the currently edited file into a command
" Command mode: Ctrl+P
cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

" Unimpaired configuration
" Bubble single lines
nmap <C-k> [e
nmap <C-j> ]e
" Bubble multiple lines
vmap <C-k> [egv
vmap <C-j> ]egv

" Enable syntastic syntax checking
let g:syntastic_enable_signs=1
let g:syntastic_quiet_messages = {'level': 'warnings'}

" Use modeline overrides
set modeline
set modelines=10

" Default color scheme
color gruvbox

" Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup

if version >= 703
  " Directory for undo files
  set undodir=~/.vim/undo
  set undofile
  set undolevels=1000 "maximum number of changes that can be undone
  set undoreload=10000 "maximum number lines to save for undo on a buffer reload
endif

" % to bounce from do to end etc.
runtime! macros/matchit.vim

" Show/hide Gundo.
nnoremap <F5> :GundoToggle<CR>

" Carry out command, preserving cursor position and search buffer
" http://technotales.wordpress.com/2010/03/31/preserve-a-vim-function-that-keeps-your-state/
function! Preserve(command)
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

" Strip trailing whitespace
nmap _$ :call Preserve("%s/\\s\\+$//e")<CR>

" Allow remapping of C-e in insert mode without interfering with
" C-e to abort autocompletion.
function! InsCtrlE()
    try
        norm! i
        return "\<C-o>A"
    catch
        return "\<C-e>"
    endtry
endfunction

" Map C-a and C-e to move to beginning/end of line like Emacs
imap <C-a> <C-o>I
inoremap <C-e> <C-r>=InsCtrlE()<cr>

" Highlight the line the cursor is currently on, but turn it off
" when leaving the current window.
setlocal cursorline
au WinEnter * setlocal cursorline
au WinLeave * setlocal nocursorline

" Start scrolling when within 5 lines near the top/bottom
set scrolloff=5

" Allow freeform selection (i.e. ignoring line endings) in
" visual block mode.
set virtualedit+=block

" Go up/down by screen line, not file line.
nnoremap k gk
nnoremap j gj

" Toggles line number mode.
function! g:ToggleNuMode()
  if(&rnu == 1)
    set nu
  else
    set rnu
  endif
endfunc
nnoremap <C-L> :call g:ToggleNuMode()<cr>

" Map key for Bufferlist
nnoremap <Leader>b :Bufferlist<CR>

" Get Ack.vim to use the_silver_searcher
let g:ackprg='ag --nogroup --nocolor --column'
set fillchars+=stl:\ ,stlnc:\
let g:Powerline_symbols = 'fancy'

" Command-T should only work on the current folder
let g:CommandTTraverseSCM = 'pwd'
