; this routine runs with P=4, called from P=3

; STACK			.eq $2
; PC_MAIN 		.eq	$3
; PC_SUB	    .eq	$4
; PC_SUBSUB	    .eq	$5
; R_FR_CNT		.eq $7
; R_VAR_PTR     .eq $8      ; Upper byte = $0D 

    .no $06C0
SET_SOUND
    LDI #V_SPEED
    PLO R_VAR_PTR
    LDN R_VAR_PTR
    SDI $80
    DEC STACK
    STR STACK
    SEX STACK
    OUT 3

    SEP PC_MAIN


STARTUP_SOUND
    LDI /WAIT_250MS_ENTRY
    PHI PC_SUBSUB
    LDI #WAIT_250MS_ENTRY
    PLO PC_SUBSUB
    SEX STACK
    DEC STACK
    LDI $80
    STR STACK
    OUT 3
    SEQ
    SEP PC_SUBSUB
    REQ
    SEP PC_SUBSUB
    SEP PC_SUBSUB
    SEP PC_SUBSUB
    SEQ
    SEP PC_SUBSUB
    REQ
    SEP PC_SUBSUB
    SEP PC_SUBSUB
    SEP PC_SUBSUB

    DEC STACK
    LDI $40
    STR STACK
    OUT 3
    SEQ

    SEP PC_MAIN

WAIT_250MS_RET
    SEP PC_SUB
WAIT_250MS_ENTRY
    LDI $00
    PLO R_FR_CNT
WAIT_250MS_LOOP
    GLO R_FR_CNT
    SMI $0F
    BNZ WAIT_250MS_LOOP
    BR WAIT_250MS_RET
