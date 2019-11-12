" ============================================================================
" File:        Mru.vim
" Description:
" Author:      Yggdroot <archofortune@gmail.com>
" Website:     https://github.com/Yggdroot
" Note:
" License:     Apache License, Version 2.0
" ============================================================================

if leaderf#versionCheck() == 0  " this check is necessary
    finish
endif

exec g:Lf_py "from leaderf.mruExpl import *"

function! leaderf#Mru#Maps()
    nmapclear <buffer>
    nnoremap <buffer> <silent> <CR>          :exec g:Lf_py "mruExplManager.accept()"<CR>
    nnoremap <buffer> <silent> o             :exec g:Lf_py "mruExplManager.accept()"<CR>
    nnoremap <buffer> <silent> <2-LeftMouse> :exec g:Lf_py "mruExplManager.accept()"<CR>
    nnoremap <buffer> <silent> x             :exec g:Lf_py "mruExplManager.accept('h')"<CR>
    nnoremap <buffer> <silent> v             :exec g:Lf_py "mruExplManager.accept('v')"<CR>
    nnoremap <buffer> <silent> t             :exec g:Lf_py "mruExplManager.accept('t')"<CR>
    nnoremap <buffer> <silent> q             :exec g:Lf_py "mruExplManager.quit()"<CR>
    " nnoremap <buffer> <silent> <Esc>         :exec g:Lf_py "mruExplManager.quit()"<CR>
    nnoremap <buffer> <silent> i             :exec g:Lf_py "mruExplManager.input()"<CR>
    nnoremap <buffer> <silent> <Tab>         :exec g:Lf_py "mruExplManager.input()"<CR>
    nnoremap <buffer> <silent> <F1>          :exec g:Lf_py "mruExplManager.toggleHelp()"<CR>
    nnoremap <buffer> <silent> d             :exec g:Lf_py "mruExplManager.deleteMru()"<CR>
    nnoremap <buffer> <silent> s             :exec g:Lf_py "mruExplManager.addSelections()"<CR>
    nnoremap <buffer> <silent> a             :exec g:Lf_py "mruExplManager.selectAll()"<CR>
    nnoremap <buffer> <silent> c             :exec g:Lf_py "mruExplManager.clearSelections()"<CR>
    nnoremap <buffer> <silent> p             :exec g:Lf_py "mruExplManager._previewResult(True)"<CR>
    nnoremap <buffer> <silent> j             j:exec g:Lf_py "mruExplManager._previewResult(False)"<CR>
    nnoremap <buffer> <silent> k             k:exec g:Lf_py "mruExplManager._previewResult(False)"<CR>
    nnoremap <buffer> <silent> <Up>          <Up>:exec g:Lf_py "mruExplManager._previewResult(False)"<CR>
    nnoremap <buffer> <silent> <Down>        <Down>:exec g:Lf_py "mruExplManager._previewResult(False)"<CR>
    nnoremap <buffer> <silent> <PageUp>      <PageUp>:exec g:Lf_py "mruExplManager._previewResult(False)"<CR>
    nnoremap <buffer> <silent> <PageDown>    <PageDown>:exec g:Lf_py "mruExplManager._previewResult(False)"<CR>
    nnoremap <buffer> <silent> <LeftMouse>   <LeftMouse>:exec g:Lf_py "mruExplManager._previewResult(False)"<CR>
    if has_key(g:Lf_NormalMap, "Mru")
        for i in g:Lf_NormalMap["Mru"]
            exec 'nnoremap <buffer> <silent> '.i[0].' '.i[1]
        endfor
    endif
endfunction

function! leaderf#Mru#NormalModeFilter(winid, key) abort
    let key = get(g:Lf_KeyDict, get(g:Lf_KeyMap, a:key, a:key), a:key)

    if key == "j" || key ==? "<Down>"
        call win_execute(a:winid, "norm! j")
        exec g:Lf_py "mruExplManager._cli._buildPopupPrompt()"
        redraw
        exec g:Lf_py "mruExplManager._previewResult(False)"
    elseif key == "k" || key ==? "<Up>"
        call win_execute(a:winid, "norm! k")
        exec g:Lf_py "mruExplManager._cli._buildPopupPrompt()"
        redraw
        exec g:Lf_py "mruExplManager._previewResult(False)"
    elseif key ==? "<PageUp>"
        call win_execute(a:winid, "norm! \<PageUp>")
        exec g:Lf_py "mruExplManager._cli._buildPopupPrompt()"
        exec g:Lf_py "mruExplManager._previewResult(False)"
    elseif key ==? "<PageDown>"
        call win_execute(a:winid, "norm! \<PageDown>")
        exec g:Lf_py "mruExplManager._cli._buildPopupPrompt()"
        exec g:Lf_py "mruExplManager._previewResult(False)"
    elseif key ==? "<LeftMouse>"
        if has('patch-8.1.2266')
            call win_execute(a:winid, "exec v:mouse_lnum")
            call win_execute(a:winid, "exec 'norm!'.v:mouse_col.'|'")
            exec g:Lf_py "mruExplManager._cli._buildPopupPrompt()"
            redraw
            exec g:Lf_py "mruExplManager._previewResult(False)"
        endif
    elseif key ==? "<ScrollWheelUp>"
        call win_execute(a:winid, "norm! 3k")
        exec g:Lf_py "mruExplManager._cli._buildPopupPrompt()"
        redraw
    elseif key ==? "<ScrollWheelDown>"
        call win_execute(a:winid, "norm! 3j")
        exec g:Lf_py "mruExplManager._cli._buildPopupPrompt()"
        redraw
    elseif key == "q" || key ==? "<ESC>"
        exec g:Lf_py "mruExplManager.quit()"
    elseif key == "i" || key ==? "<Tab>"
        call leaderf#ResetPopupOptions(a:winid, 'filter', 'leaderf#PopupFilter')
        exec g:Lf_py "mruExplManager.input()"
    elseif key == "o" || key ==? "<CR>" || key ==? "<2-LeftMouse>"
        exec g:Lf_py "mruExplManager.accept()"
    elseif key == "x"
        exec g:Lf_py "mruExplManager.accept('h')"
    elseif key == "v"
        exec g:Lf_py "mruExplManager.accept('v')"
    elseif key == "t"
        exec g:Lf_py "mruExplManager.accept('t')"
    elseif key == "d"
        exec g:Lf_py "mruExplManager.deleteMru()"
    elseif key == "s"
        exec g:Lf_py "mruExplManager.addSelections()"
    elseif key == "a"
        exec g:Lf_py "mruExplManager.selectAll()"
    elseif key == "c"
        exec g:Lf_py "mruExplManager.clearSelections()"
    elseif key == "p"
        exec g:Lf_py "mruExplManager._previewResult(True)"
    elseif key ==? "<F1>"
        exec g:Lf_py "mruExplManager.toggleHelp()"
    endif

    return 1
endfunction
