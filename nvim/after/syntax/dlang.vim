" nvim/after/syntax/dlang.vim
" Dlang (.d) syntax highlighting

if exists("b:current_syntax")
  finish
endif

" ------------------------
" Comments: -- to end of line
syntax match dlangComment "--.*$"
highlight link dlangComment Comment

" ------------------------
" Strings: double quotes
syntax region dlangString start=/"/ end=/"/ keepend
highlight link dlangString String

" ------------------------
" Numbers: integers (with optional + or -)
syntax match dlangNumber "\v[\+\-]?\d+"
highlight link dlangNumber Number

" ------------------------
" Keywords
syntax keyword dlangKeyword int bool const if then elif else fi while do for assert in out
highlight link dlangKeyword Keyword

" ------------------------
" Boolean literals
syntax keyword dlangBoolean true false
highlight link dlangBoolean Boolean

" ------------------------
" Built-in functions
syntax keyword dlangFunc ABS
highlight link dlangFunc Function

" ------------------------
" Operators
syntax match dlangOperator "[-+*/%^&|!<>=]+"
highlight link dlangOperator Operator

" ------------------------
" Braces
syntax match dlangBraces "[{}]"
highlight link dlangBraces Delimiter

" ------------------------
" Semicolons
syntax match dlangSemicolon ";"
highlight link dlangSemicolon Delimiter

let b:current_syntax = "dlang"
