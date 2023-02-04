; this routine runs with P=4, called from P=3

; PC_MAIN 		.eq	$3
; PC_SUB 		.eq	$4
; R_VAR_PTR     .eq $8  ; upper = $0D
; R_WORK_PTR    .eq $9  ; upper = $0D
; R_TABLE_PTR   .eq $A

; in subroutine...
; R_MULTIPLICAND    .eq	$E
; R_MULT_CNT        .eq $F  lower byte
; R_MULTIPLIER      .eq $F  lower 6 bits of higher byte

R_BEH_CURV_PTR      .eq $B
R_BEH_CURV_SIGN     .eq $C    ; upper byte
R_BEH_CURV_LABEL    .eq $C    ; lower byte

R_BEH_WORK_PTR      .eq $D

    .no $0500
CAR_BEHAVIOR

    LDI WORK_PAGE
    PHI R_BEH_WORK_PTR
    GHI PC_SUB
    PHI R_TABLE_PTR
; accel
    LDI #V_KEY_UP
    PLO R_WORK_PTR
    LDN R_WORK_PTR
    BZ CAR_ACCEL_SKIP
    LDI #V_SPEED
    PLO R_VAR_PTR
    LDN R_VAR_PTR
    SMI $3F
    BDF CAR_ACCEL_SKIP
    ADI $40
    STR R_VAR_PTR
CAR_ACCEL_SKIP
; brake
    LDI #V_KEY_DOWN
    PLO R_WORK_PTR
    LDN R_WORK_PTR
    BZ CAR_BRAKE_SKIP
    LDI #V_SPEED
    PLO R_VAR_PTR
    LDN R_VAR_PTR
    BZ CAR_BRAKE_SKIP
    SMI $01
    STR R_VAR_PTR
CAR_BRAKE_SKIP
; left and right
    SEX R_VAR_PTR
    LDI #V_DIR_CAR+1
    PLO R_VAR_PTR
    LDI #V_SPEED
    PLO R_WORK_PTR
    LDN R_WORK_PTR
    ADI #SPEED_TO_DIR
    PLO R_TABLE_PTR
; left
    LDI #V_KEY_LEFT
    PLO R_WORK_PTR
    LDN R_WORK_PTR
    BZ CAR_LEFT_SKIP

    LDN R_TABLE_PTR
    SD
    STXD
    LDI $00
    SDB
    STR R_VAR_PTR

;    DEC R_VAR_PTR
;    LDI $01
;    SDB
;    STR R_VAR_PTR

    BR CAR_RIGHT_SKIP
CAR_LEFT_SKIP
; right
    LDI #V_KEY_RIGHT
    PLO R_WORK_PTR
    LDN R_WORK_PTR
    BZ CAR_RIGHT_SKIP

    LDN R_TABLE_PTR
    ADD
    STXD
    LDI $00
    ADC
    STR R_VAR_PTR

;    DEC R_VAR_PTR
;    LDI $01
;    ADC
;    STR R_VAR_PTR


CAR_RIGHT_SKIP

; set DIR_ROAD
;
    LDI #V_DIST_CAR
    PLO R_VAR_PTR
    LDN R_VAR_PTR       ; highest byte of dist_car
    PLO R_BEH_CURV_PTR
; curvature_scaled[curvature_map[D](-8)] -> R_MULTIPLIER, sign -> R_BEH_CURV_SIGN.1
    LDI /CURVATURE_MAP
    PHI R_BEH_CURV_PTR
    LDN R_BEH_CURV_PTR
    PLO R_BEH_CURV_LABEL
    ANI $08
    PHI R_BEH_CURV_SIGN
    GLO R_BEH_CURV_LABEL
    ANI $07
    ADI #CURVATURE_SCALED
    PLO R_TABLE_PTR
    LDN R_TABLE_PTR
    PHI R_MULTIPLIER
    LDI $00
    PHI R_MULTIPLICAND
    LDI #V_SPEED
    PLO R_VAR_PTR
    LDN R_VAR_PTR
    PLO R_MULTIPLICAND
    LDI /MULT_6_16_ENTRY
    PHI PC_SUBSUB
    LDI #MULT_6_16_ENTRY
    PLO PC_SUBSUB   ; set PC_SUBSUB to MULT_6_12_ENTRY
    SEP PC_SUBSUB

    LDI #V_WORK_1+1
    PLO R_WORK_PTR
    LDI #V_DIR_ROAD+1
    PLO R_VAR_PTR
    SEX R_VAR_PTR
    GHI R_BEH_CURV_SIGN
    BNZ CAR_CURV_NEGATIVE

    LDN R_WORK_PTR
    ADD
    STXD
    DEC R_WORK_PTR
    LDN R_WORK_PTR
    ADC
    STR R_VAR_PTR
    BR CAR_CURV_END
CAR_CURV_NEGATIVE
    LDN R_WORK_PTR
    SD
    STXD
    DEC R_WORK_PTR
    LDN R_WORK_PTR
    SDB
    STR R_VAR_PTR
CAR_CURV_END
CAR_DIR_REL
    SEX R_BEH_WORK_PTR
    LDI #V_DIR_REL+1
    PLO R_VAR_PTR
    LDI #V_DIR_CAR+1
    PLO R_WORK_PTR
    LDI #V_DIR_ROAD+1
    PLO R_BEH_WORK_PTR
    LDN R_WORK_PTR
    SM
    STR R_VAR_PTR
    DEC R_VAR_PTR
    DEC R_WORK_PTR
    DEC R_BEH_WORK_PTR
    LDN R_WORK_PTR
    SMB
    STR R_VAR_PTR
CAR_DIST
    LDI #V_SPEED
    PLO R_WORK_PTR
    LDI #V_DIST_CAR+1
    PLO R_VAR_PTR
    SEX R_VAR_PTR
    LDN R_WORK_PTR
    ADD
    STXD
    LDI $00
    ADC
    STR R_VAR_PTR
    BNF CAR_DIST_SKIP
    LDI #V_STATE
    PLO R_VAR_PTR
    LDI STATE_END
    STR R_VAR_PTR
CAR_DIST_SKIP

    SEP PC_MAIN

    .no $05B8
CURVATURE_SCALED
    .db 0, 2, 4, 6, 8, 10, 12, 14
    .no $05C0
SPEED_TO_DIR
;    .db 128, 133, 138, 143, 147, 152, 156, 161, 165, 169, 173, 177, 180, 184, 187, 190
;    .db 194, 197, 199, 202, 205, 207, 210, 212, 214, 216, 218, 220, 221, 223, 224, 225
;    .db 226, 227, 228, 229, 229, 230, 230, 230, 230, 230, 230, 230, 229, 229, 228, 227
;    .db 226, 225, 224, 223, 221, 220, 218, 216, 214, 212, 210, 207, 205, 202, 199, 197

    .db 192, 194, 196, 198, 200, 202, 204, 206, 208, 210, 212, 214, 216, 218, 220, 222
    .db 224, 226, 228, 230, 232, 234, 236, 238, 240, 242, 244, 246, 248, 250, 252, 254
    .db 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255
    .db 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255
