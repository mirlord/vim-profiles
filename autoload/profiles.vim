" profiles.vim - vim plugin profiles (bundle sets) runtime loader
"
" Maintainer: Vladimir Chizhov
" Version:    1.0.0
" Contacts:   master@mirlord.com
" License:    The MIT license.
"             https://github.com/mirlord/vim-profiles/blob/master/LICENSE
"
" Installation:
" 1. Copy profiles.vim to:
"    ~/.vim/autload/
" 2. Add to your ~/.vimrc:
"    exec profiles#init()
"
" Usage:
" 1. Place your bundles (vim plugins) into separate directories
"    under `~/.vim/profiles/anyname/`.
" 2. Run command:
"    :LoadProfiles anyname
"
" For more details see bundled README file.
" README is also available online at:
" https://github.com/mirlord/vim-profiles/blob/master/README.md

if (exists('g:loaded_profiles'))
  finish
endif
let g:loaded_profiles = 1

if (!exists('g:profiles_path'))
  let g:profiles_path = 'profiles'
endif

if (!exists('g:profiles_default'))
  let g:profiles_default = []
endif

"" Built-in augroups
let s:profiles_augroups = {
  \ 'loaded_airline'          : 'airline',
  \ 'loaded_fugitive'         : 'fugitive',
  \ 'loaded_localvimrc'       : 'localvimrc',
  \ 'loaded_nerd_tree'        : 'NERDTree',
  \ }

if ($VIM_PROFILES != '')
  let g:profiles_env = split($VIM_PROFILES)
else
  let g:profiles_env = []
endif

"" ===========================================================================

let g:profiles_loaded = []

let g:activation_modules = ['plugin', 'ftdetect']

"" Activate loaded bundles.
""
function! s:activate(activations)

  let l:sep = pathogen#separator()

  " source bundle files
  for l:bundle in a:activations['before'] + a:activations['after']
    for l:module in g:activation_modules
      let l:module_files = pathogen#glob(l:bundle . l:sep . l:module . '**' . l:sep . '*.vim')
      for l:mf in l:module_files
        execute 'source ' . fnameescape(l:mf)
      endfor
    endfor
  endfor
  call s:exec_augroups()
endfunction

"" Execute groups of autocommands on VimEnter event.
""
function! s:exec_augroups()
  for l:var in keys(s:profiles_augroups)
    let l:gvar = l:var =~# '^g:' ? l:var : 'g:' . l:var
    if (exists(l:gvar))
      let l:groups = remove(s:profiles_augroups, l:var)
      for l:grp in type(l:groups) == type([]) ? l:groups : [l:groups]
        execute 'silent doautocmd ' . l:grp . ' VimEnter'
        execute 'silent doautocmd ' . l:grp . ' WinEnter'
      endfor
    endif
  endfor
endfunction

"" Load a single profile.
""
"" This will also activate loaded profile. It should be used only to load
"" profiles *after* the vim startup. To load profiles on vim initialization
"" phase use `#do_preload`
""
function! s:do_load(...)
  for l:p_name in a:000
    call s:activate(s:do_preload(l:p_name))
  endfor
endfunction

"" Preload profile on vim startup.
""
"" This will NOT try to activate loaded bundles.
""
function! s:do_preload(p_name)
  let l:sep = pathogen#separator()
  let l:activations = {'before' : [], 'after' : []}
  if (index(g:profiles_loaded, a:p_name) < 0)
    let l:p_path = g:profiles_path . l:sep . a:p_name . l:sep . '{}'
    let l:activations = pathogen#infect(l:p_path)
    let g:profiles_loaded = add(g:profiles_loaded, a:p_name)
    execute 'let g:profiles_loaded#' . a:p_name . ' = 1'
  endif
  return l:activations
endfunction

command! -nargs=* LoadProfiles call s:do_load(<f-args>)
command! -nargs=* LP LoadProfiles <args>

"" Init profiles.
""
function! profiles#init()
  " load default profiles
  for l:p_name in g:profiles_default + g:profiles_env
    call s:do_preload(l:p_name)
  endfor
  " merge built-in and user-defined autocommand groups
  if (exists('g:profiles_augroups'))
    call extend(s:profiles_augroups, g:profiles_augroups)
  endif
endfunction

