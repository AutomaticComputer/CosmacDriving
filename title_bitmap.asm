    .no $a00

TITLE_BITMAP
    .db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $80
    .db $C3, $C3, $FF, $FF, $07, $FF, $FC, $00
    .db $81, $81, $FF, $E0, $00, $7F, $E0, $00
    .db $71, $71, $FF, $80, $00, $0F, $00, $00
    .db $09, $49, $FF, $40, $04, $04, $00, $00
    .db $89, $49, $FE, $00, $08, $03, $C0, $00
    .db $B9, $49, $FD, $00, $00, $01, $F8, $00
    .db $89, $49, $E0, $00, $00, $01, $F8, $00
    .db $09, $49, $CC, $00, $10, $07, $38, $00
    .db $73, $73, $3F, $80, $00, $3E, $10, $00
    .db $07, $04, $FF, $F0, $23, $FC, $80, $00
    .db $FF, $F3, $FF, $FE, $4F, $FD, $40, $00
    .db $FF, $CF, $FF, $FF, $FF, $FD, $C0, $00
    .db $FF, $3F, $FF, $FF, $FF, $F8, $80, $00
    .db $FE, $3F, $FF, $FD, $FF, $E0, $00, $00
    .db $FE, $8F, $FF, $FF, $FF, $80, $00, $00
    .db $F0, $C3, $FF, $CF, $8E, $00, $00, $00
    .db $00, $C0, $7F, $FE, $00, $00, $00, $00
    .db $00, $40, $1E, $FC, $80, $00, $00, $00
    .db $00, $80, $23, $FB, $1C, $E5, $2A, $4E
    .db $00, $10, $3B, $FB, $52, $95, $2B, $50
    .db $00, $00, $39, $F1, $92, $95, $2B, $50
    .db $00, $02, $3B, $E0, $12, $E5, $4A, $D6
    .db $00, $01, $03, $00, $12, $A5, $4A, $D2
    .db $00, $00, $38, $00, $1C, $94, $8A, $4C
    .db $00, $00, $00, $00, $00, $00, $00, $00
    .db $00, $00, $00, $00, $00, $00, $00, $00

    .do TARGET=TARGET_VIP
    .db $21, $80, $86, $00, $00, $47, $01, $0E
    .db $22, $41, $C9, $00, $00, $80, $80, $90
    .db $AA, $42, $A9, $00, $01, $F7, $07, $D0
    .db $73, $C0, $89, $00, $00, $80, $80, $90
    .db $22, $40, $86, $00, $00, $47, $01, $0E
    .fi
    .do TARGET=TARGET_ELF
    .db $20, $80, $86, $00, $00, $45, $01, $0C
    .db $21, $81, $C9, $00, $00, $85, $00, $90
    .db $A8, $82, $A7, $00, $01, $F5, $07, $DC
    .db $70, $80, $81, $00, $00, $87, $80, $92
    .db $20, $80, $86, $00, $00, $41, $01, $0C
    .fi
