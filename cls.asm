    .no $0100

;   CLEAR_PAGE: 326 instructions = 652 cycles
;   parameter: D: page to clear

R_TMP_ADDR  .eq $E

CLS_RET
    SEP PC_MAIN
CLS_ENTRY
    PHI R_TMP_ADDR
    LDI $FF
    PLO R_TMP_ADDR
    SEX R_TMP_ADDR
CLS_LOOP
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
    GLO R_TMP_ADDR
    XRI $FF
    BNZ CLS_LOOP
    BR CLS_RET
    