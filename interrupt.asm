; R_DMA	.eq 0
; PC_INT	.eq 1
; STACK	.eq 2
; R_CUR_PAGE	.eq	7	; upper byte
; R_FR_CNT	.eq 8


    .no $00E0
INT_RET
    LDXA
    RET
INT_ENTRY
    NOP
    DEC STACK
    SAV
    DEC STACK
    STR STACK
    GHI R_CUR_PAGE
    XRI $01
    PHI R_DMA
    LDI $00
    PLO R_DMA   ; R_DMA = ((current page) xor 1) << 8
    SEX STACK
    SEX STACK
INT_DISP
    SEX STACK
    GLO R_DMA
    SEX STACK
    DEC R_DMA
    PLO R_DMA
    SEX STACK
    DEC R_DMA
    PLO R_DMA
    SEX STACK
    DEC R_DMA
    PLO R_DMA
    BN1 INT_DISP
    INC R_FR_CNT
    BR INT_RET
