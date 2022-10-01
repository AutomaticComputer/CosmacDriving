    .no $0000
; PC_MAIN       .eq	$3

    LDI $00
    PHI PC_MAIN
    LDI #MAIN
    PLO PC_MAIN     ; PC_MAIN = MAIN
    SEP PC_MAIN     ; to MAIN
