let s:save_cpo = &cpo
set cpo&vim

function! improve_diff#diffoff(...) abort " {{{
  let expr = get(a:000, 0, '%')
  if getwinvar(bufwinnr(expr), '&l:diff')
    diffoff
    " check the number of diff buffer in the current tab page
    let n = 0
    for winnum in range(winnr('$'))
      if getwinvar(winnum, '&l:diff')
        let n += 1
      endif
    endfor
    " call diffoff if only a single buffer is in diff mode
    if n == 1
      diffoff!
    endif
  endif
endfunction " }}}
function! improve_diff#diffupdate(...) abort " {{{
  let expr = get(a:000, 0, '%')
  if getwinvar(bufwinnr(expr), '&l:diff')
    diffupdate
  endif
endfunction " }}}
function! improve_diff#difforig(...) abort " {{{
  let horizontal = get(a:000, 0, 0)
  let bufnum = bufnr('%')
  let filetype = &filetype
  let filename = expand('%')
  let sep = has('unix') ? ':' : '-'
  if horizontal
    noautocmd execute printf('new ORIG%s%s', sep, filename)
  else
    noautocmd execute printf('vnew ORIG%s%s', sep, filename)
  endif
  r # | normal! 1Gdd
  silent execute printf('setlocal filetype=%s', filetype)
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
  setlocal readonly nomodifiable
  diffthis
  silent execute printf('%swincmd w', bufwinnr(bufnum))
  diffthis
  diffupdate
endfunction " }}}

function! improve_diff#enable_auto_diffupdate() abort " {{{
  augroup vim-improve-diff-auto-diffupdate
    autocmd! *
    autocmd InsertLeave * call improve_diff#diffupdate()
  augroup END
endfunction " }}}
function! improve_diff#enable_auto_diffoff() abort " {{{
  augroup vim-improve-diff-auto-diffoff
    autocmd! *
    autocmd BufUnload * call improve_diff#diffoff(expand('<afile>'))
  augroup END
endfunction " }}}
function! improve_diff#enable() abort " {{{
  call improve_diff#enable_auto_diffupdate()
  call improve_diff#enable_auto_diffoff()
endfunction " }}}

function! improve_diff#disable_auto_diffupdate() abort " {{{
  augroup vim-improve-diff-auto-diffupdate
    autocmd! *
  augroup END
endfunction " }}}
function! improve_diff#disable_auto_diffoff() abort " {{{
  augroup vim-improve-diff-auto-diffoff
    autocmd! *
  augroup END
endfunction " }}}
function! improve_diff#disable() abort " {{{
  call improve_diff#disable_auto_diffupdate()
  call improve_diff#disable_auto_diffoff()
endfunction " }}}


nnoremap <silent> <Plug>(improve-diff-diffupdate)
      \ :<C-u>call improve_diff#diffupdate()<CR>
nnoremap <silent> <Plug>(improve-diff-diffoff)
      \ :<C-u>call improve_diff#diffoff()<CR>
nnoremap <silent> <Plug>(improve-diff-difforig-h)
      \ :<C-u>call improve_diff#difforig(1)<CR>
nnoremap <silent> <Plug>(improve-diff-difforig-v)
      \ :<C-u>call improve_diff#difforig(0)<CR>


let &cpo = s:save_cpo
" vim:set et ts=2 sts=2 sw=2 tw=0 fdm=marker:
