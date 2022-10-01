	.no $0350
; PC_MAIN 		.eq	$3
; R_CUR_PAGE	.eq	$6
R_DRAW_CAR_PTR	    .eq	$F

DRAW_CAR
	GHI R_CUR_PAGE
	PHI R_DRAW_CAR_PTR
; draw car
    SEX R_DRAW_CAR_PTR
    LDI $FC
    PLO R_DRAW_CAR_PTR
    LDI $08
    OR
    STXD
    LDI $10
    OR
    STR R_DRAW_CAR_PTR
    LDI $F4
    PLO R_DRAW_CAR_PTR
    LDI $F0
    OR
    STXD
    LDI $0F
    OR
    STR R_DRAW_CAR_PTR

    SEP PC_MAIN


