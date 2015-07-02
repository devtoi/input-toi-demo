" Compile and run
inoremap <F5> <Esc>:wa<CR>:!cd .. && cmake -G "Ninja" . && ninja && cd bin/linux/Debug/ && ./InputTest<CR>
noremap <F5> :wa<CR>:!cd .. && cmake -G "Ninja" . && ninja && cd bin/linux/Debug && ./InputTest<CR>
" Compile
inoremap <F7> <Esc>:wa<CR>:!cd .. && cmake -G "Ninja" . && ninja<CR>
noremap <F7> :wa<CR>:!cd .. && cmake -G "Ninja" . && ninja<CR>
