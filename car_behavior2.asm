; this routine runs with P=4, called from P=3

; PC_MAIN 		.eq	$3
; PC_SUB 		.eq	$4
; PC_SUBSUB 	.eq	$5
; R_VAR_PTR     .eq $8  ; upper = $0D
; R_WORK_PTR    .eq $9  ; upper = $0D

; in subroutine
; R_MULTIPLICAND    .eq	$E
; R_MULT_CNT        .eq $F  lower byte
; R_MULTIPLIER      .eq $F  lower 6 bits of higher byte

    .no $0600
CAR_BEHAVIOR2

    LDI WORK_PAGE
    PHI R_VAR_PTR
    PHI R_WORK_PTR

; set x_car
;
    LDI #V_DIR_REL
    PLO R_VAR_PTR
    LDN R_VAR_PTR      ; highest byte of dir_rel -> D
    PLO R_MULTIPLICAND

    ANI $80
    BZ CAR_BEHAVIOR2_S0
    LDI $FF
CAR_BEHAVIOR2_S0
    PHI R_MULTIPLICAND

    LDI #V_SPEED
    PLO R_VAR_PTR
    LDN R_VAR_PTR
    PHI R_MULTIPLIER

    LDI /MULT_6_16_ENTRY
    PHI PC_SUBSUB
    LDI #MULT_6_16_ENTRY
    PLO PC_SUBSUB   ; set PC_SUBSUB to MULT_6_16_ENTRY
    SEP PC_SUBSUB

    LDI #V_WORK_1+1
    PLO R_WORK_PTR   ; higher byte of the product
    LDI #V_X_CAR+1
    PLO R_VAR_PTR
    SEX R_VAR_PTR
    LDN R_WORK_PTR
    ADD
    STXD
    DEC R_WORK_PTR
    LDN R_WORK_PTR
    ADC
    STR R_VAR_PTR
    SEP PC_MAIN


