" Detect Dlang files by extension
augroup filetypedetect
  autocmd!
  autocmd BufNewFile,BufRead *.d set filetype=dlang
augroup END
