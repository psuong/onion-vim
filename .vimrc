call plug#begin()

"------------------------------------------------------------------------------------------------
" Autocompletion
"------------------------------------------------------------------------------------------------
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

Plug 'dense-analysis/ale'
Plug 'nickspoons/vim-sharpenup'
Plug 'OmniSharp/omnisharp-vim'

" File options
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Color options, plug whatever colorscheme you want 
" Plug 'gruvbox-community/gruvbox'

call plug#end()

"----------------------------------------------------------------------
" Color Options (Set your default colorscheme here)
"----------------------------------------------------------------------
" colorscheme gruvbox

"----------------------------------------------------------------------
" Some Editor Stuff
"----------------------------------------------------------------------
filetype plugin on           " Enable plugins based on their extension
filetype plugin indent on    " Allow different indents per filetypes

set expandtab                " Tabs are spaces
set tabstop=4                " Number of visual spaces per tabs
set softtabstop=4            " Number of spaces in tabs when editing
set shiftwidth=4             " Number of spaces text is indented
set smartindent              " Automate indenting on a new line
set signcolumn=yes           " Always enable the sign column

set number                   " Show number lines
set cursorline               " Highlight the current line number
set showcmd                  " Show the vim commands
set wrap                     " Wrap horizontally long lines
set encoding=utf-8           " Default to UTF-8

" ----------------------------------------------------------------------
" File Browsing options
" ----------------------------------------------------------------------
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
" TODO: Remap this to whatever you want, right now its ctrl p so you can search up a file
nnoremap <c-p> :FZF<CR>

augroup fzf
  autocmd!
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup END

" ----------------------------------------------------------------------
" Tabbing support
" ----------------------------------------------------------------------
if has('python3')
    " Force ultisnippets to expand using Ctrl O, so that we can tab to complete.
    let g:UltiSnipsExpandTrigger="<c-o>"
endif

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"

autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

imap <c-r> <Plug>(asyncomplete_force_refresh)

"------------------------------------------------------------------------
" Linting Hints
"------------------------------------------------------------------------
let g:ale_linters_explicit = 1
let g:ale_sign_error = '->'
let g:ale_sign_warning = '‼'
let g:ale_linters = {
    \ 'cs': ['OmniSharp'],
\}

" -----------------------------------------------------------------------
" OmniSharp Global Options
" -----------------------------------------------------------------------
let g:OmniSharp_server_stdio = 1
let g:OmniSharp_want_snippet = 1

" TODO: Remove popups here
" let g:OmniSharp_popup = 0

if has('macunix')
    " TODO: Make sure you have mono installed in your mac machine
    " You can use home brew
    " brew install mono
    let g:OmniSharp_server_use_mono = 1
endif

let g:sharpenup_codeactions_autocmd = 'CursorHold,CursorMoved,BufEnter'

let g:OmniSharp_typeLookupInPreview = 1
let g:OmniSharp_selector_ui = 'fzf'
let g:OmniSharp_selector_findusages = 'fzf'

if has('patch-8.1.1880')
  " -----------------------------------------------------------------------
  " OmniSharp Popup Options
  " -----------------------------------------------------------------------
  let g:OmniSharp_popup_options = {
  \ 'highlight': 'Normal',
  \ 'padding': [1],
  \ 'border': [1]
  \}

  let g:OmniSharp = {
    \ 'popup': {
    \   'mappings': {
    \     'sigNext': '<C-j>',
    \     'sigPrev': '<C-k>',
    \     'lineDown': ['<C-e>', 'j'],
    \     'lineUp': ['<C-y>', 'k']
    \   },
    \ }
  \ }

  set completeopt=longest,menuone,popuphidden
  " Highlight the completion documentation popup background/foreground the same as
  " the completion menu itself, for better readability with highlighted
  " documentation.
  set completepopup=highlight:Pmenu,border:off
else
  set completeopt=longest,menuone,preview
  " Set desired preview window height for viewing documentation.
  set previewheight=5
endif

" -----------------------------------------------------------------------
" OmniSharp commands
" -----------------------------------------------------------------------
augroup omnisharp_commands
    autocmd!
    " Show type information automatically when the cursor stops moving.
    " Note that the type is echoed to the Vim command line, and will overwrite
    " any other messages in this space including e.g. ALE linting messages.
    autocmd CursorHold *.cs OmniSharpTypeLookup

    " ----------------------------------------------------------------------
    " Code Actions (Configure here to whatever you want)
    " ----------------------------------------------------------------------
    " TODO: Change the key bindings to whatever you want

    " Lets you jump to the definition by pressing \gd
    autocmd FileType cs nmap <silent> <buffer> gd <Plug>(omnisharp_go_to_definition)

    " Lets you find usages of the var/type by pressing \fu
    autocmd FileType cs nmap <silent> <buffer> <Leader>fu <Plug>(omnisharp_find_usages)

    " Lets you find usages of the implementation by pressing \fi
    autocmd FileType cs nmap <silent> <buffer> <Leader>fi <Plug>(omnisharp_find_implementations)

    " Lets you quickly view the original source of a method/var/class/struct by pressing \pd
    autocmd FileType cs nmap <silent> <buffer> <Leader>pd <Plug>(omnisharp_preview_definition)

    " View docStrings quickly with \td
    autocmd FileType cs nmap <silent> <buffer> <Leader>td <Plug>(omnisharp_documentation)

    " Remove unncessary imports by pressing \fx
    autocmd FileType cs nmap <silent> <buffer> <Leader>fx <Plug>(omnisharp_fix_usings)

    " Run optional code actions like fix usings, move class to another file, etc by pressing \ra
    autocmd FileType cs nmap <silent> <buffer> <Leader>ra <Plug>(omnisharp_code_actions)

    " Run a global code check, this takes a while using \gc
    autocmd FileType cs nmap <silent> <buffer> <Leader>gc <Plug>(omnisharp_global_code_check)

    " Format the code by pressing \cf
    " You also need to define a config file for this if you want braces on the same line.
    autocmd FileType cs nmap <silent> <buffer> <Leader>cf <Plug>(omnisharp_code_format)

    " Rename a class/variable/method using \nm
    autocmd FileType cs nmap <silent> <buffer> <Leader>nm <Plug>(omnisharp_rename)

    " Press F5 to restart the server
    autocmd FileType cs nmap <silent> <buffer> <F5> <Plug>(omnisharp_restart_server)

    " Press F6 to start a server manually, typically you don't need to do this
    autocmd FileType cs nmap <silent> <buffer> <F6> <Plug>(omnisharp_start_server)

    " Press F7 to stop a server manually, typically you don't need to do this
    autocmd FileType cs nmap <silent> <buffer> <F7> <Plug>(omnisharp_stop_server)
augroup END