; Only fold markdown sections (heading + content), not other treesitter nodes
; `#trim!` prevents trailing empty lines from being included in the fold
((section
    (atx_heading)) @fold
    (#trim! @fold))
