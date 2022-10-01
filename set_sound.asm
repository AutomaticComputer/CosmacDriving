; this routine runs with P=4, called from P=3

    .no $07C0
SET_SOUND
    LDI WORK_PAGE
    PHI R_VAR_PTR
    LDI #V_SPEED
    PLO R_VAR_PTR
    LDN R_VAR_PTR
    SDI $80
    DEC STACK
    STR STACK
    SEX STACK
    OUT 3

    SEP PC_MAIN
