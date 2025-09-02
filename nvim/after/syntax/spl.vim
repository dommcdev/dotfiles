" Neovim syntax file for Simple Programming Language (SPL)
" Language:   spl
" Maintainer: You!

" Prevent loading this file twice
if exists("b:current_syntax")
  finish
endif

" SPL is case-neutral
syn case ignore

" Comments
" MODIFIED: Both comment types now use the 'splComment' group for consistent, subtle highlighting.
syn region  splComment   start="/\*" end="\*/" contains=@splCommentGroup
syn match   splComment   ";.*$"

" Literals
syn region  splString    start=/"/  end=/"/ skip=/\\"/
syn region  splCharacter start=/'/  end=/'/
syn match   splInteger   "\<\d\+\>"
syn match   splFloat     "\<\d\+\.\d\+\(E-\?\d\+\)\?\>"
syn keyword splBoolean   true false

" Data Types
syn keyword splType      INT FLT BOOL CHR

" Module and Data Definitions
syn keyword splModule    PROGRAM PROCEDURE FUNCTION HANDLER END
syn keyword splStorage   VAR CON

" Parameter Modes
syn keyword splParameter IN OUT IO REF

" Control Flow Statements
syn keyword splStatement PRINT INPUT CALL RETURN RAISE EXIT RESUME PRAGMAS ENDL
syn keyword splConditional IF THEN ELIF ELSE
syn keyword splLoop      FOR TO BY DO WHILE

" Operators
syn match   splOperator  ":=\|+=\|-=\|*=\|/=\|%="
syn match   splOperator  "\%(++\|--\)"
syn match   splOperator  "\%(\^\|**\)"
syn match   splOperator  "\%(<=\|>=\|!=\|<>\)"
syn match   splOperator  "\*\|/\|%\|+\|-"
syn match   splOperator  "<\|>\|="
syn keyword splOperator  AND NAND OR NOR XOR NOT
syn keyword splOperator  ABS ORD CHR INT FLT UP LOW ISUP ISLOW PRED SUCC LB UB

" --- Highlight Linking ---
" Link our custom groups to standard Neovim highlight groups

" MODIFIED: Removed the special link for line comments.
" Now, all comments will use your theme's default, subtle comment color.
hi def link splComment      Comment

hi def link splString       String
hi def link splCharacter    Character
hi def link splInteger      Number
hi def link splFloat        Float
hi def link splBoolean      Boolean

hi def link splType         Type
hi def link splStorage      StorageClass
hi def link splModule       Structure
hi def link splParameter    Label

hi def link splStatement    Statement
hi def link splConditional  Conditional
hi def link splLoop         Repeat
hi def link splOperator     Operator

" Set the current syntax
let b:current_syntax = "spl"
