    .no $0140

    ; 3: left, C: right
    ; 0: up(accel), A: down(brake)
    ; variables V_KEY_LEFT, V_KEY_RIGHT, V_KEY_DOWN, V_KEY_UP must be in this order.
GET_KEYS
    LDI WORK_PAGE
    PHI R_VAR_PTR
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
