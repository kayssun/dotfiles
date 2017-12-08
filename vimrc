" Sets how many lines of history VIM has to remember
set history=700

" Set to auto read when a file is changed from the outside
set autoread

" Turn on syntax highlighting
syntax on

"Always show current position
set ruler

" Makes search act like search in modern browsers
set incsearch
set hlsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" 1 tab == 4 spaces
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab

let g:ruby_path = "/usr/local/bin"

if has("mouse_sgr")
  set ttymouse=sgr
else
  set ttymouse=xterm2
end

if &shell =~# 'fish$'
  set shell=sh
endif

" Map Shift-Tab to Tab (since normal Tab is mapped to spaces
:inoremap <S-Tab> <C-V><Tab>

" sudo write
ca w!! w !sudo tee >/dev/null "%"
