call pathogen#infect()
call pathogen#helptags()

set nocompatible

if version >= 730
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
set wildignore+=*.o,*.obj,.git,*.rbc

" Status bar
set laststatus=2
set ch=1

" Without setting this, ZoomWin restores windows in a way that causes
" equalalways behavior to be triggered the next time CommandT is used.
" This is likely a bludgeon to solve some other issue, but it works
set noequalalways

" NERDTree configuration
let NERDTreeIgnore=['\.rbc$', '\~$']
map <Leader>n :NERDTreeToggle<CR>

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
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru}    set ft=ruby

" md, markdown, and mk are markdown and define buffer-local preview
au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} call s:setupMarkup()

au BufRead,BufNewFile *.txt call s:setupWrapping()

" nginx.conf syntax
au BufRead,BufNewFile nginx.conf set ft=nginx

" make python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
au FileType python  set tabstop=4 textwidth=79

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
nmap <C-Up> [e
nmap <C-Down> ]e
" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv

" Enable syntastic syntax checking
let g:syntastic_enable_signs=1
let g:syntastic_quiet_warnings=1

" Use modeline overrides
set modeline
set modelines=10

" Default color scheme
color desert

" Directories for swp files
if has("win32")
  set backupdir=~/vimfiles/backup
  set directory=~/vimfiles/backup
else
  set backupdir=~/.vim/backup
  set directory=~/.vim/backup
endif

if version >= 730
  " Directory for undo files
  if has("win32")
    set undodir=~/vimfiles/vim/undo
  else
    set undodir=~/.vim/undo
  endif
  set undofile
  set undolevels=1000 "maximum number of changes that can be undone
  set undoreload=10000 "maximum number lines to save for undo on a buffer reload
endif

" Turn off jslint errors by default
let g:JSLintHighlightErrorLine = 0

" % to bounce from do to end etc.
runtime! macros/matchit.vim

" Show/hide Gundo.
nnoremap <F5> :GundoToggle<CR>

" Disable default BufferGator mapping (conflicts with CommandT)
let g:buffergator_suppress_keymaps = 1
nnoremap <Leader>bg :BuffergatorToggle<CR>
" Other Buffergator settings
let g:buffergator_autoexpand_on_split = 0
let g:buffergator_split_size = 10
let g:buffergator_viewport_split_policy = "T"

" Bufexplorer config
let g:bufExplorerShowRelativePath=1

" Turn on folding
function FoldEmUp()
  set fdm=indent
  set fdc=2
endfunction
nnoremap <Leader>f :call FoldEmUp()<CR>

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
