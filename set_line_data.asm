; this routine runs with P=4, called from P=3

; use [STACK] as scratch memory


; R_VAR_PTR         .eq $8    ; upper = $0D
; R_WORK_PTR        .eq $9    ; upper = $0D
; R_TABLE_PTR       .eq $A    ; upper = this page

R_CNT_Y           .eq $B  ; lower byte. Upper: page of LINE_DATA = WORK_PAGE

R_SEGS            .eq $C    ; used in the loop
R_CURV_PTR        .eq $E
R_CURV_DELTA_DIST_PTR .eq $E
R_CENTER_DATA_PTR .eq $E
R_CURV_LABEL      .eq $F    ; lower byte
R_CURV_SIGN       .eq $F    ; higher byte, zero/nonzero

; R_MULTIPLICAND    .eq $E  integer; ssyyyyyyyyyyyyyyy
; R_MULT_CNT        .eq $F    ; lower byte
; R_MULTIPLIER      .eq $F    ; upper 6 bits of lower byte(unsigned fixed point x.xxxxx), last 2 bits ignored

    .no $0700
SET_LINE_DATA
    LDI /MULT_ENTRY
    PHI PC_SUBSUB
    LDI #MULT_ENTRY
    PLO PC_SUBSUB   ; set PC_SUBSUB to MULT_ENTRY
    LDI WORK_PAGE
    PHI R_CNT_Y
    GHI PC_SUB
    PHI R_TABLE_PTR
; set k, s
    SEX R_VAR_PTR
    LDI V_LOCAL_K+1
    PLO R_WORK_PTR    
    LDI V_DIR_REL+1
    PLO R_VAR_PTR
    LDI $00
    SM  R_VAR_PTR
    STR R_WORK_PTR
    DEC R_WORK_PTR
    DEC R_VAR_PTR
    LDI $00
    SMB
    STR R_WORK_PTR

; V_LOCAL_S should be V_LOCAL_K - 2, V_X_CAR should be V_DIR_REL - 2
    DEC R_WORK_PTR
    DEC R_VAR_PTR
    LDI $00
    SM  R_VAR_PTR
    STR R_WORK_PTR
    DEC R_WORK_PTR
    DEC R_VAR_PTR
    LDI $00
    SMB
    STR R_WORK_PTR

    LDI $0F
    PLO R_CNT_Y
SET_LINE_DATA_LOOP
; set R_TABLE_PTR to Y_TO_DIST + 2*y + 1(lower byte)
    GLO R_CNT_Y
    SHL
    ADI #Y_TO_DIST+1
    PLO R_TABLE_PTR
; (y_to_dist[y] + DIST_CAR)/256 ->  R_CURV_PTR.0, /2 -> R(R_SEGS).0
    SEX R_TABLE_PTR
    LDI V_DIST_CAR+1
    PLO R_VAR_PTR
    LDN R_VAR_PTR
    ADD
    DEC R_VAR_PTR
    DEC R_TABLE_PTR
    LDN R_VAR_PTR
    ADC
    PLO R_CURV_PTR
    SHR
    PLO R_SEGS
; curvature_map[D] -> R_CURV_LABEL, R_CURV_SIGN
    LDI /CURVATURE_MAP
    PHI R_CURV_PTR
    LDN R_CURV_PTR
    PLO R_CURV_LABEL
    ANI $08
    PHI R_CURV_SIGN

; (l * 16 + y)*2 -> R_CURV_DELTA_DIST_PTR.0 (bit 4 of l is shifted out anyway)
    GLO R_CNT_Y
    STR STACK
    SEX STACK
    GLO R_CURV_LABEL
    SHL
    SHL
    SHL
    SHL
    ADD
    SHL
    PLO R_CURV_DELTA_DIST_PTR
    LDI /CURV_DELTA_DIST
    PHI R_CURV_DELTA_DIST_PTR
; add curv_delta_dist to k
    INC R_CURV_DELTA_DIST_PTR

    LDI #V_LOCAL_K+1
    PLO R_VAR_PTR
    SEX R_VAR_PTR

    GHI R_CURV_SIGN
    BNZ SET_LINE_DATA_SUB_K
SET_LINE_DATA_ADD_K
    LDN R_CURV_DELTA_DIST_PTR
    ADD
    STXD
    DEC R_CURV_DELTA_DIST_PTR
    LDN R_CURV_DELTA_DIST_PTR
    ADC
    STR R_VAR_PTR
    BR  SET_LINE_DATA_SET_S
SET_LINE_DATA_SUB_K
    LDN R_CURV_DELTA_DIST_PTR
    SD
    STXD
    DEC R_CURV_DELTA_DIST_PTR
    LDN R_CURV_DELTA_DIST_PTR
    SDB
    STR R_VAR_PTR
SET_LINE_DATA_SET_S
; set R_TABLE_PTR to DELTA_OVER_DIST + y
    GLO R_CNT_Y
    ADI #DELTA_OVER_DIST
    PLO R_TABLE_PTR
    LDN R_TABLE_PTR
    PHI R_MULTIPLIER
    LDI #V_LOCAL_K+1
    PLO R_VAR_PTR
    LDI #V_LOCAL_S+1
    PLO R_WORK_PTR
    SEX R_WORK_PTR
    LDN R_VAR_PTR
    SM 
    PLO R_MULTIPLICAND
    DEC R_VAR_PTR
    DEC R_WORK_PTR
    LDN R_VAR_PTR
    SMB
    PHI R_MULTIPLICAND
    SEP PC_SUBSUB       ; PC_SUBSUB preserved
; set s
    LDI #V_LOCAL_S+1
    PLO R_VAR_PTR
    SEX R_VAR_PTR
    LDN R_WORK_PTR
    ADD 
    STXD
    DEC R_WORK_PTR
    LDN R_WORK_PTR
    ADC
    STR R_VAR_PTR
    STR R_CNT_Y
; center_data
    ; if it is in the new segment, store $01
    GLO R_CNT_Y
    SMI $0F
    BZ SET_LINE_DATA_CENTER_FINAL
    ADI #CENTER_DATA+$0F
    PLO R_CENTER_DATA_PTR
    LDI /CENTER_DATA
    PHI R_CENTER_DATA_PTR
    SEX STACK
    GHI R_SEGS
    STR STACK
    GLO R_SEGS
    SM
    STR R_CENTER_DATA_PTR
    BZ SET_LINE_DATA_CENTER_FINAL
    ; if the new seg is 0, store $FF
    GLO R_SEGS
    BNZ SET_LINE_DATA_CENTER_FINAL
    LDI $FF
    STR R_CENTER_DATA_PTR
SET_LINE_DATA_CENTER_FINAL
    GLO R_SEGS
    PHI R_SEGS

SET_LINE_DATA_LOOP_FINAL
    DEC R_CNT_Y
    GLO R_CNT_Y
    SMI $02
    BDF SET_LINE_DATA_LOOP

SET_LINE_DATA_FINAL
    SEP PC_MAIN





    .no $07D0
Y_TO_DIST
    .dw 0, 0, 1261, 1005, 749, 545, 408, 311, 238, 181, 136, 99, 68, 41, 19, 0
DELTA_OVER_DIST     ; 2 lowest bits ignored
    .db 0, 0, 22, 26, 26, 22, 18, 16, 14, 13, 12, 11, 10, 9, 8, 8

	.no $0800
CURV_DELTA_DIST       ; this has to match CURVATURE_SCALED
    .dw 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    .dw 0, 0, 512, 512, 408, 274, 194, 146, 114, 90, 74, 62, 54, 44, 38, 36
    .dw 0, 0, 1024, 1024, 816, 548, 388, 292, 228, 180, 148, 124, 108, 88, 76, 72
    .dw 0, 0, 1536, 1536, 1224, 822, 582, 438, 342, 270, 222, 186, 162, 132, 114, 108
    .dw 0, 0, 2048, 2048, 1632, 1096, 776, 584, 456, 360, 296, 248, 216, 176, 152, 144
    .dw 0, 0, 2560, 2560, 2040, 1370, 970, 730, 570, 450, 370, 310, 270, 220, 190, 180
    .dw 0, 0, 3072, 3072, 2448, 1644, 1164, 876, 684, 540, 444, 372, 324, 264, 228, 216
    .dw 0, 0, 3584, 3584, 2856, 1918, 1358, 1022, 798, 630, 518, 434, 378, 308, 266, 252

	.no $0900
CURVATURE_MAP       ; list of curvature: curvature_list[l] if l < 8, 
                    ; -curvature_list[l-8] if l >= 8
    .db 0, 0, 0, 1, 2, 3, 3, 2 
    .db 1, 0, 0, 0, 0, 0, 0, 0 
    .db 0, 0, 0, 0, 0, 0, 0, 0
    .db 1, 1, 1, 1, 1, 1, 1, 1
    .db 1, 1, 1, 1, 1, 1, 1, 1
    .db 1, 1, 1, 1, 9, 9, 9, 9
    .db 10, 10, 10, 10, 10, 10, 0, 0
    .db 0, 0, 0, 2, 2, 2, 2, 2
    .db 3, 3, 3, 3, 3, 3, 3, 3
    .db 3, 3, 2, 2, 2, 2, 0, 0
    .db 0, 0, 0, 2, 2, 3, 3, 3
    .db 4, 4, 4, 4, 4, 4, 3, 3
    .db 3, 0, 0, 0, 0, 0, 0, 0
    .db 0, 10, 10, 10, 11, 11, 12, 12
    .db 12, 11, 0, 0, 0, 0, 0, 0
    .db 0, 0, 0, 0, 0, 0, 0, 0
    .db 2, 2, 2, 2, 2, 2, 2, 2
    .db 2, 2, 2, 2, 2, 2, 2, 2
    .db 2, 2, 2, 2, 2, 2, 2, 2
    .db 2, 2, 2, 2, 2, 2, 2, 2
    .db 2, 2, 2, 2, 2, 2, 2, 2
    .db 2, 2, 2, 2, 2, 2, 2, 2
    .db 2, 2, 2, 2, 2, 2, 2, 2
    .db 2, 2, 2, 2, 2, 2, 2, 2
    .db 0, 0, 0, 0, 14, 14, 14, 14
    .db 0, 0, 0, 0, 0, 7, 7, 7
    .db 0, 0, 0, 0, 14, 14, 14, 14
    .db 2, 2, 2, 2, 2, 3, 3, 3
    .db 3, 3, 3, 3, 3, 3, 3, 3
    .db 3, 3, 3, 3, 3, 3, 3, 3
    .db 3, 3, 3, 2, 2, 2, 2, 2
    .db 10, 10, 10, 10, 10, 10, 10, 10
