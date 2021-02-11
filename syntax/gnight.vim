if exists("b:current_syntax")
    finish
endif

syntax keyword gninghtMethodGet GET 
syntax keyword gninghtMethodPost POST
syntax keyword gninghtMethodDelete DELETE
syntax keyword gninghtMethodPatch PATCH
syntax keyword gninghtMethodPut PUT

syntax match gnightComment "\v#.*$"
syntax match gnightLayers "\v^(Header|Body)"
syntax match gnightVars "\v_.[a-z|A-Z|0-1]+"
syntax match gnightHeaderName "\v(Header\s)@<=(.+:)"

highlight gn_get cterm=bold ctermfg=142 gui=bold guifg=#b8bb26
highlight gn_post cterm=bold ctermfg=214 gui=bold guifg=#fabd2f
highlight gn_delete cterm=bold ctermfg=167 gui=bold guifg=#fb4934
highlight gn_patch cterm=bold ctermfg=109 gui=bold guifg=#83a598
highlight gn_put cterm=bold ctermfg=208 gui=bold guifg=#fe8019
highlight gn_layers cterm=bold gui=bold guifg=fg guibg=bg
highlight gn_vars ctermbg=271 guibg=#8400ff

highlight link gnightComment Comment

highlight link gninghtMethodGet gn_get
highlight link gninghtMethodPost gn_post
highlight link gninghtMethodDelete gn_delete
highlight link gninghtMethodPatch gn_patch
highlight link gninghtMethodPut gn_put
highlight link gnightLayers gn_layers
highlight link gnightVars gn_vars
highlight link gnightHeaderName Keyword

let b:current_syntax = "gnight"
