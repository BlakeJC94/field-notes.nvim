if exists('g:loaded_kettle') | finish | endif " prevent loading file twice

let s:save_cpo = &cpo " save user coptions
set cpo&vim           " reset them to defaults" command to run our plugin

command! Kettle lua require("kettle").say_yo()

let &cpo = s:save_cpo " and restore after
unlet s:save_cpo

let g:loaded_kettle = 1
