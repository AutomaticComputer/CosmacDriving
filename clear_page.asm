    .no $0100

;   CLEAR_PAGE: 326 instructions = 652 cycles
;   parameter: D: page to clear
;   PC_SUB restored

; PC_MAIN   .eq	$3
R_CLEAR_PTR  .eq $F

CLEAR_PAGE_RET
    SEP PC_MAIN
CLEAR_PAGE_ENTRY
    PHI R_CLEAR_PTR
    LDI $FF
    PLO R_CLEAR_PTR
    SEX R_CLEAR_PTR
CLEAR_PAGE_LOOP
    LDI $00
    STXD
    STXD
    STXD
    STXD
    STXD
    STXD
    STXD
    STXD
    STXD
    STXD
    STXD
    STXD
    STXD
    STXD
    STXD
    STXD
    GLO R_CLEAR_PTR
    XRI $FF
    BNZ CLEAR_PAGE_LOOP
    BR CLEAR_PAGE_RET
