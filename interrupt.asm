; R_DMA	.eq 0
; PC_INT	.eq 1
; STACK	.eq 2
; R_CUR_PAGE	.eq	6	; upper byte
; R_FR_CNT	.eq 7

    .no $0B00

INT0_RET
    LDXA
    RET
INT0_ENTRY
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
INT0_DISP
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
    BN1 INT0_DISP
    INC R_FR_CNT
    BR INT0_RET


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
    SEX STACK
    SEX STACK

    SEX STACK
    SEX STACK
    PLO R_DMA

    SEX STACK
    DEC STACK
    PLO R_DMA

    DEC STACK
    DEC STACK
    PLO R_DMA

; this might produce some garbage on the screen 
    OUT 5
    OUT 5
    OUT 5

    SEX STACK
    LDI $08
    PLO R_DMA

    SEX STACK
    SEX STACK
    PLO R_DMA

    SEX STACK
    SEX STACK
    PLO R_DMA

    SEX STACK
    SEX STACK

INT_DISP0
    GLO R_DMA

    SEX STACK
    SEX STACK
    PLO R_DMA

    SEX STACK
    SEX STACK
    PLO R_DMA

    SEX STACK
    PLO R_DMA
    XRI $80
; can't use SMI, since in interrupt routine, DF must be preserved

    SEX STACK
    BNZ INT_DISP0

    GLO R_DMA

    SEX STACK
    SEX STACK
    PLO R_DMA

    SEX STACK
    SEX STACK
    PLO R_DMA

    DEC STACK
    DEC STACK
    PLO R_DMA

    OUT 5
    OUT 5
INT_DISP
    GLO R_DMA

    SEX STACK
    SEX STACK
    PLO R_DMA

    SEX STACK
    SEX STACK
    PLO R_DMA

    SEX STACK
    SEX STACK
    PLO R_DMA

    XRI $F0
    BNZ INT_DISP

    GLO R_DMA

    DEC STACK
    DEC R_DMA
    PLO R_DMA

    DEC STACK
    DEC R_DMA
    PLO R_DMA

    DEC STACK
    DEC R_DMA
    PLO R_DMA

    OUT 5
    OUT 5
    OUT 5

    INC R_FR_CNT
    BR INT_RET
