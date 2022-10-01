    .no $0130

; STACK             .eq $2
; PC_MAIN           .eq	$3
; R_VAR_PTR       .eq $8      ; Upper byte = $0D 
; R_WORK_PTR      .eq $9      ; Upper byte = $0D


    ; 3: left, C: right
    ; 0: up(accel), A: down(brake)
    ; variables V_KEY_LEFT, V_KEY_RIGHT, V_KEY_DOWN, V_KEY_UP must be in this order.
GET_KEYS
    LDI #V_KEY_LEFT+3
    PLO R_VAR_PTR
    SEX R_VAR_PTR
    LDI $00
    STXD
    STXD
    STXD
    STR R_VAR_PTR
    SEX STACK
    DEC STACK
    LDI $03
    STR STACK
    OUT 2
    BN3 GET_KEYS_SKIP_LEFT
    STR R_VAR_PTR
GET_KEYS_SKIP_LEFT
    INC R_VAR_PTR
    DEC STACK
    LDI $0C
    STR STACK
    OUT 2
    BN3 GET_KEYS_SKIP_RIGHT
    STR R_VAR_PTR
GET_KEYS_SKIP_RIGHT
    INC R_VAR_PTR
    DEC STACK
    LDI $0A
    STR STACK
    OUT 2
    BN3 GET_KEYS_SKIP_DOWN
    STR R_VAR_PTR
GET_KEYS_SKIP_DOWN
    INC R_VAR_PTR
    DEC STACK
    LDI $00
    STR STACK
    OUT 2
    BN3 GET_KEYS_SKIP_UP
    LDI $10
    STR R_VAR_PTR
GET_KEYS_SKIP_UP
    SEP PC_MAIN


; wait for any key to be pressed
WAIT_ANY_KEY
    SEX STACK
    DEC STACK
    LDI $00
WAIT_ANY_KEY_LOOP
    STR STACK
    OUT 2
    B3 WAIT_ANY_KEY_EXIT
    DEC STACK
    ADI $01
    ANI $0F
    BR WAIT_ANY_KEY_LOOP
WAIT_ANY_KEY_EXIT
    SEP PC_MAIN
