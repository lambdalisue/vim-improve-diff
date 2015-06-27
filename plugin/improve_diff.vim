let s:save_cpo = &cpo
set cpo&vim

if get(g:, 'improve_diff#enable', 1)
  call improve_diff#enable()
elseif get(g:, 'improve_diff#enable_auto_diffupdate')
  call improve_diff#enable_auto_diffupdate()
elseif get(g:, 'improve_diff#enable_auto_diffoff')
  call improve_diff#enable_auto_diffoff()
endif

if get(g:, 'improve_diff#define_DiffOrig', !exists(':DiffOrig'))
  command! -nargs=? DiffOrig call improve_diff#difforig(<f-args>)
endif

let &cpo = s:save_cpo
" vim:set et ts=2 sts=2 sw=2 tw=0 fdm=marker:
