
"===============================================================================
" Autocommands
"===============================================================================
" Set augroup
augroup MyAutoCmd
  autocmd!
augroup END


" Turn on cursorline only on active window
augroup MyAutoCmd
  autocmd WinLeave * setlocal nocursorline
  autocmd WinEnter,BufRead * setlocal cursorline
augroup END

" in quickfix
autocmd MyAutoCmd FileType qf nnoremap <silent> <buffer> q :q<CR>
autocmd MyAutoCmd FileType qf nnoremap <silent> <buffer> <C-c> :q<CR>

" json = javascript syntax highlight
autocmd MyAutoCmd FileType json setlocal syntax=javascript

" Ctrl-y: Yanks
nmap <c-y> [unite]y

" Enable omni completion
augroup MyAutoCmd
  autocmd FileType css,less setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType ejs,jst setlocal omnifunc=htmlcomplete#CompleteTags

  if neobundle#is_installed('marijnh/tern_for_vim')
    autocmd FileType javascript setlocal omnifunc=tern#Complete
  else
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  endif

  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
  autocmd FileType java setlocal omnifunc=eclim#java#complete#CodeComplete
  autocmd  FileType  php setlocal omnifunc=phpcomplete_extended#CompletePHP
augroup END

" Diff mode settings
" au MyAutoCmd FilterWritePre * if &diff | exe 'nnoremap <c-p> [c' | exe 'nnoremap <c-n> ]c' | endif

autocmd BufNewFile,BufRead requirements.txt,requirements.pip setlocal ft=python

autocmd FileType * noremap <silent><leader>f :call Preserve("normal gg=G")<CR>
" JS Beautify / Formatting{{{
" rm below: vim-javascript.vim indentation superior
if neobundle#is_sourced('maksimr/vim-jsbeautify')
  autocmd FileType javascript noremap <buffer> <leader>f :call JsBeautify()<CR>
  autocmd FileType html,mustache,jinja,hbs noremap <buffer> <leader>f :call HtmlBeautify()<CR>

else
  autocmd FileType javascript noremap <silent><leader>f :call Preserve("normal gg=G")<CR>
  autocmd FileType html,mustache,hbs noremap <silent><leader>f :call Preserve("normal gg=G")<CR>
endif


if neobundle#is_sourced('maksimr/vim-jsbeautify')
autocmd FileType javascript vnoremap <buffer>  <leader>f :call RangeJsBeautify()<cr>
autocmd FileType html,mustache,jinja,hbs vnoremap <buffer> <leader>f :call RangeHtmlBeautify()<cr>
autocmd FileType css vnoremap <buffer> <leader>f :call RangeCSSBeautify()<cr>
endif

" ejs gets screwy with htmlbeautify
autocmd FileType ejs,jst noremap <silent><leader>f :call Preserve("normal gg=G")<CR>


"autocmd FileType mustache noremap <buffer> <leader>f :call HtmlBeautify()<CR>

" for css or scss
autocmd FileType css noremap <buffer> <leader>f :call CSSBeautify()<CR>
" still get this issue: https://github.com/einars/js-beautify/pull/353
autocmd FileType less noremap <silent><leader>f :call Preserve("normal gg=G")<CR>


" Reload vimrc when edited, also reload the powerline color
" autocmd MyAutoCmd BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc
      " \ so $MYVIMRC | call Pl#Load() | if has('gui_running') | so $MYGVIMRC | endif


if has("autocmd")
  autocmd BufNewFile,BufRead *.ejs,*.jst setlocal  filetype=html.jst  " https://github.com/briancollins/vim-jst/blob/master/ftdetect/jst.vim
  autocmd BufNewFile,BufRead *.handlebars setlocal  filetype=html.mustache
  autocmd! BufNewFile,BufRead *.js.php,*.json set filetype=javascript
  autocmd FileType javascript  setlocal  ts=2 sw=2 sts=2 expandtab
  autocmd FileType vim  setlocal ai et sta sw=2 sts=2 keywordprg=:help
  autocmd FileType html,mustache,jst,ejs  setlocal  ts=2 sw=2 sts=2 expandtab

  autocmd FileType sh,csh,tcsh,zsh        setlocal ai et sta sw=4 sts=4
  autocmd BufWritePost,FileWritePost ~/.Xdefaults,~/.Xresources silent! !xrdb -load % >/dev/null 2>&1

  autocmd FileType git,gitcommit setlocal foldmethod=syntax foldlevel=1
  autocmd FileType gitcommit setlocal spell
  autocmd FileType gitrebase nnoremap <buffer> S :Cycle<CR>

  " Keep vim's cwd (Current Working Directory) set to current file.
  autocmd BufEnter * silent! lcd %:p:h

  " map :BufClose to :bq and configure it to open a file browser on close
  let g:BufClose_AltBuffer = '.'
  cnoreabbr <expr> bq 'BufClose'

  " Colorcolumns
  if version >= 730
    autocmd FileType * setlocal colorcolumn=0
    autocmd FileType ruby,python,javascript,c,cpp,objc setlocal colorcolumn=79
  endif

  " man
  " ---

  autocmd FileType man IndentLinesToggle " no indent lines pls

  " python support
  " --------------
  "  don't highlight exceptions and builtins. I love to override them in local
  "  scopes and it sucks ass if it's highlighted then. And for exceptions I
  "  don't really want to have different colors for my own exceptions ;-)
  autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8
  autocmd FileType python setlocal textwidth=80
  \ formatoptions+=croq softtabstop=4 smartindent
  \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
  let python_highlight_all=1
  let python_highlight_exceptions=0
  let python_highlight_builtins=0
  let python_slow_sync=1
  autocmd FileType pyrex setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4 smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with
  let g:pymode_lint_ignore = "E501,W"
  autocmd FileType python set foldlevelstart=0

  " ruby support
  " ------------
  autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2

  " go support
  " ----------
  autocmd BufNewFile,BufRead *.go setlocal ft=go
  autocmd FileType go setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4

  " php support
  " -----------
  autocmd FileType php setlocal shiftwidth=4 tabstop=8 softtabstop=4 expandtab

  " template language support (SGML / XML too)
  " ------------------------------------------
  " and disable taht stupid html rendering (like making stuff bold etc)

  fun! s:SelectHTML()
  let n = 1
  while n < 50 && n < line("$")
    " check for jinja
    if getline(n) =~ '{%\s*\(extends\|block\|macro\|set\|if\|for\|include\|trans\)\>'
      set ft=jinja.html
      return
    endif
    " check for mako
      if getline(n) =~ '<%\(def\|inherit\)'
        set ft=mako
        return
      endif
      " check for genshi
      if getline(n) =~ 'xmlns:py\|py:\(match\|for\|if\|def\|strip\|xmlns\)'
        set ft=genshi
        return
      endif
      let n = n + 1
    endwhile
    " go with html
    set ft=html
  endfun


  autocmd FileType html,xhtml,xml,htmldjango,jinja.html,jinja,eruby,mako setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
  autocmd bufnewfile,bufread *.rhtml setlocal ft=eruby
  autocmd BufNewFile,BufRead *.mako setlocal ft=mako
  autocmd BufNewFile,BufRead *.tmpl,*.jinja2 setlocal ft=jinja.html
  autocmd BufNewFile,BufRead *.py_tmpl setlocal ft=python
  autocmd BufNewFile,BufRead *.html,*.htm  call s:SelectHTML()
  let html_no_rendering=1

  let g:closetag_default_xml=1
  let g:sparkupNextMapping='<c-l>'
  autocmd FileType html,htmldjango,jinja.html,eruby,mako let b:closetag_html_style=1
  autocmd FileType html,xhtml,xml,htmldjango,jinja.html,eruby,mako source ~/.vim/bundle/closetag.vim/plugin/closetag.vim

  " GLSL
  " ----
  autocmd bufnewfile,bufread *.frag,*.fragment,*.vert,*.vertex,*.shader,*.glsl setlocal ft=glsl
  autocmd FileType glsl setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4

  " Verilog
  " -------
  autocmd FileType verilog setlocal expandtab shiftwidth=2 tabstop=8 softtabstop=2

  " CSS
  " ---
  autocmd FileType css setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4

  " Java
  " ----
  autocmd FileType java setlocal shiftwidth=2 tabstop=8 softtabstop=2 expandtab

  " rst
  " ---
  " autocmd BufNewFile,BufRead *.txt setlocal ft=rst
  autocmd FileType rst setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
  \ formatoptions+=nqt textwidth=74

  " C#
  autocmd FileType cs setlocal tabstop=8 softtabstop=4 shiftwidth=4 expandtab

  " C/Obj-C/C++
  autocmd FileType c setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
  autocmd FileType cpp setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
  autocmd FileType objc setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
  let c_no_curly_error=1

  " Octave/Matlab
  autocmd FileType matlab setlocal tabstop=8 softtabstop=2 shiftwidth=2 expandtab

  " vim
  " ---
  autocmd FileType vim setlocal expandtab shiftwidth=2 tabstop=8 softtabstop=2

  " Javascript
  " ----------
  autocmd FileType javascript setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
  autocmd BufNewFile,BufRead *.json setlocal ft=javascript
  let javascript_enable_domhtmlcss=1

  " CoffeeScript
  " ------------
  autocmd FileType coffee setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2

  " D
  " -
  autocmd FileType d setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4

  " cmake support
  " -------------
  autocmd BufNewFile,BufRead CMakeLists.txt setlocal ft=cmake

  " Erlang support
  " --------------
  autocmd FileType erlang setlocal expandtab shiftwidth=2 tabstop=8 softtabstop=2
  autocmd BufNewFile,BufRead rebar.config setlocal ft=erlang

  " YAML support
  " ------------
  autocmd FileType yaml setlocal expandtab shiftwidth=2 tabstop=8 softtabstop=2
  autocmd BufNewFile,BufRead *.sls setlocal ft=yaml

  " Lua support
  " -----------
  autocmd FileType lua setlocal shiftwidth=2 tabstop=2 softtabstop=2

  " rust
  " ----
  autocmd FileType rust setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4

  " ocaml
  " -----
  autocmd FileType ocaml exec ":source " . substitute(
    \ system("opam config var share"), '[\r\n]*$', '', ''
  \) . "/vim/syntax/ocp-indent.vim"

endif

