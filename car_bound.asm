; this routine runs with P=4, called from P=3


; PC_MAIN 		.eq	$3
; R_VAR_PTR     .eq $8
; R_WORK_PTR    .eq $9


R_CAR_BOUND_WORK_PTR      .eq $E
R_CAR_BOUND_WORK_TMP      .eq $F

    .no $0640
CAR_BOUND
    LDI WORK_PAGE
    PHI R_CAR_BOUND_WORK_PTR

    LDI #V_DIR_REL
    PLO R_WORK_PTR
    SEX R_WORK_PTR
; if dir_rel < -48, change dir_rel, dir_car.
    LDN R_WORK_PTR
    ADI $30
    ANI $80
    BZ CAR_BOUND_S0
    INC R_WORK_PTR
    LDI $00
    STXD
    LDI $D0             ; -$30
    STR R_WORK_PTR
CAR_BOUND_S0
; if dir_rel >= 48, change dir_rel, dir_car.
    LDN R_WORK_PTR
    SMI $30
    ANI $80
    BNZ CAR_BOUND_S1
    INC R_WORK_PTR
    LDI $FF
    STXD
    LDI $2F
    STR R_WORK_PTR
CAR_BOUND_S1
    INC R_WORK_PTR
    LDI #V_DIR_ROAD+1
    PLO R_CAR_BOUND_WORK_PTR
    LDI #V_DIR_CAR+1
    PLO R_VAR_PTR
    LDN R_CAR_BOUND_WORK_PTR
    ADD
    STR R_VAR_PTR
    DEC R_VAR_PTR
    DEC R_WORK_PTR
    DEC R_CAR_BOUND_WORK_PTR
    LDN R_CAR_BOUND_WORK_PTR
    ADC
    STR R_VAR_PTR

; Bound x_car
    LDI $00
    PLO R_CAR_BOUND_WORK_TMP
    LDI #V_X_CAR
    PLO R_WORK_PTR
    SEX R_WORK_PTR
; if x_car < -28, change x_car, speed.
    LDN R_WORK_PTR
    ADI $1C
    ANI $80
    BZ CAR_BOUND_S2
    INC R_WORK_PTR
    LDI $00
    STXD
    LDI $E4             ; -$1C
    STR R_WORK_PTR
    INC R_CAR_BOUND_WORK_TMP
CAR_BOUND_S2
; if x_car >= 28, change x_car, speed.
    LDN R_WORK_PTR
    SMI $1C
    ANI $80
    BNZ CAR_BOUND_S3
    INC R_WORK_PTR
    LDI $FF
    STXD
    LDI $1B
    STR R_WORK_PTR
    INC R_CAR_BOUND_WORK_TMP
CAR_BOUND_S3
    GLO R_CAR_BOUND_WORK_TMP
    BZ CAR_BOUND_S4
    LDI #V_SPEED
    PLO R_CAR_BOUND_WORK_PTR
    LDN R_CAR_BOUND_WORK_PTR
    SMI $03
    BNF CAR_BOUND_S4
    STR R_CAR_BOUND_WORK_PTR
CAR_BOUND_S4
    SEP PC_MAIN

