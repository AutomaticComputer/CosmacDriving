; this routine runs with P=5, called from P=4

;  [V_WORK_0]: result (higher, lower), x.xxxxx00 * ssyyyyyyyyyyyyyyy = smmmmmmmmmmmmmmm
; preserve PC_SUBSUB

R_MULTIPLICAND    .eq $E    ; integer; ssyyyyyyyyyyyyyyy
R_MULT_CNT        .eq $F    ; lower byte
R_MULTIPLIER      .eq $F    ; upper 6 bits of lower byte(unsigned fixed point x.xxxxx), last 2 bits ignored
; MULT_START to MULT_END: 105 to 147 instructions

	.no $01B0
MULT_EXIT
    SEP PC_SUB
MULT_ENTRY
    LDI #V_WORK_0
    PLO R_WORK_PTR
    LDI $00
    STR R_WORK_PTR
    INC R_WORK_PTR
    STR R_WORK_PTR
    SEX R_WORK_PTR
    LDI $06
MULT_A
    PLO R_MULT_CNT
    GHI R_MULTIPLIER
    SHL
    PHI R_MULTIPLIER
    BNF MULT_B
    GLO R_MULTIPLICAND
    ADD
    STXD
    GHI R_MULTIPLICAND
    ADC
    STR R_WORK_PTR
    INC R_WORK_PTR
MULT_B
    GHI R_MULTIPLICAND
    SHL
    GHI R_MULTIPLICAND
    SHRC
    PHI R_MULTIPLICAND
    GLO R_MULTIPLICAND
    SHRC
    PLO R_MULTIPLICAND
    DEC R_MULT_CNT
    GLO R_MULT_CNT
    BNZ MULT_A
    BR MULT_EXIT


; MULT_6_16
; R_WORK_PTR        .eq $9  ; upper = $0D

; R_MULTIPLICAND    .eq	$E  16 bits, signed or unsigned
; R_MULT_CNT        .eq $F  lower byte
; R_MULTIPLIER      .eq $F  lower 6 bits of higher byte, unsigned
;  [V_WORK_1]: result (higher, lower)
; destroy PC_SUBSUB
MULT_6_16_ENTRY
    LDI #V_WORK_1
    PLO R_WORK_PTR
    LDI $00
    STR R_WORK_PTR
    INC R_WORK_PTR
    STR R_WORK_PTR
    SEX R_WORK_PTR
    LDI $06
MULT_6_16_A
    PLO R_MULT_CNT
    GHI R_MULTIPLIER
    SHR
    PHI R_MULTIPLIER
    BNF MULT_6_16_B
    GLO R_MULTIPLICAND
    ADD
    STXD
    GHI R_MULTIPLICAND
    ADC
    STR R_WORK_PTR
    INC R_WORK_PTR
MULT_6_16_B
    GLO R_MULTIPLICAND
    SHL
    PLO R_MULTIPLICAND
    GHI R_MULTIPLICAND
    SHLC
    PHI R_MULTIPLICAND
    DEC R_MULT_CNT
    GLO R_MULT_CNT
    BNZ MULT_6_16_A
    SEP PC_SUB
