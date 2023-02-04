    .no $0010

; PC_INT	        .eq $1
; STACK	            .eq $2
; PC_SUB	        .eq	$4
; R_CUR_PAGE	    .eq	$6	; upper byte
; R_FR_CNT	        .eq $7
; R_VAR_PTR         .eq $8    ; higher = $0D always
; R_WORK_PTR        .eq $9    ; higher = $0D always

MAIN

; set up interrupt handler, stack and R_VAR_PTR.1, R_WORK_PTR.1
    LDI /INT0_ENTRY
    PHI PC_INT
    LDI #INT0_ENTRY
    PLO PC_INT      ; PC_INT = INT0_ENTRY
    LDI /STACK_INITIAL
    PHI STACK
    LDI #STACK_INITIAL
    PLO STACK       ; STACK = STACK_INITIAL
    SEX STACK
    LDI WORK_PAGE
    PHI R_VAR_PTR
    PHI R_WORK_PTR

; title
    LDI VIDEO_PAGE0
    PHI R_CUR_PAGE  ; set R_CUR_PAGE to VIDEO_PAGE0
    LDI /DO_TITLE
    PHI PC_SUB
    LDI #DO_TITLE
    PLO PC_SUB
    SEP PC_SUB

; start display
    LDI VIDEO_PAGE1
    PHI R_CUR_PAGE  ; set R_CUR_PAGE to VIDEO_PAGE1
    INP 1           ; video on

; wait for a key
    LDI /WAIT_ANY_KEY
    PHI PC_SUB
    LDI #WAIT_ANY_KEY
    PLO PC_SUB
    SEP PC_SUB

; clear WORK_PAGE
    LDI /CLEAR_PAGE_ENTRY
    PHI PC_SUB
    LDI #CLEAR_PAGE_ENTRY
    PLO PC_SUB
    LDI WORK_PAGE
    SEP PC_SUB   

; clear screen
    LDI VIDEO_PAGE0
    SEP PC_SUB   

    .do FLAG_COLOR<>0
; set color
    DEC STACK
    OUT 5
    LDI /SET_COLOR_ENTRY
    PHI PC_SUB
    LDI #SET_COLOR_ENTRY
    PLO PC_SUB
    SEP PC_SUB   

; set address of interrupt routine(color)
    LDI #INT_ENTRY
    PLO PC_INT      ; PC_INT = INT_ENTRY
    .fi

; main game loop
MAIN_LOOP
; calculate the x coordinates of the center for each line in the screen
    LDI /SET_LINE_DATA
    PHI PC_SUB
    LDI #SET_LINE_DATA
    PLO PC_SUB
    SEP PC_SUB

; clear the current page
    LDI /CLEAR_PAGE_ENTRY
    PHI PC_SUB
    LDI #CLEAR_PAGE_ENTRY
    PLO PC_SUB
    GHI R_CUR_PAGE
    SEP PC_SUB

; call DRAW_ROAD
    LDI /DRAW_ROAD
    PHI PC_SUB
    LDI #DRAW_ROAD
    PLO PC_SUB
    SEP PC_SUB

; call DRAW_BUILDINGS
    LDI /DRAW_BUILDINGS
    PHI PC_SUB
    LDI #DRAW_BUILDINGS
    PLO PC_SUB
    SEP PC_SUB

; call DRAW_CAR
    LDI /DRAW_CAR
    PHI PC_SUB
    LDI #DRAW_CAR
    PLO PC_SUB
    SEP PC_SUB

; call PRINT_TIME
    LDI /PRINT_TIME
    PHI PC_SUB
    LDI #PRINT_TIME
    PLO PC_SUB
    SEP PC_SUB

; switch the displayed/drawn(current) pages
    GHI R_CUR_PAGE
    XRI $01
    PHI R_CUR_PAGE

; process STATE_STARTUPSOUND0, STATE_STARTUPSOUND1
    LDI WORK_PAGE
    PHI R_VAR_PTR
    LDI #V_STATE
    PLO R_VAR_PTR
    LDN R_VAR_PTR
    SMI STATE_STARTUPSOUND0
    BNZ MAIN_SKIP_STARTUPSOUND0

; call STARTUP_SOUND
    LDI /STARTUP_SOUND
    PHI PC_SUB
    LDI #STARTUP_SOUND
    PLO PC_SUB
    SEP PC_SUB

    LDI #V_STATE
    PLO R_VAR_PTR
    LDI STATE_STARTUPSOUND1
    STR R_VAR_PTR

    LDI $00
    PLO R_FR_CNT
    BR MAIN_PROCESS_TIME

MAIN_SKIP_STARTUPSOUND0
    SMI STATE_STARTUPSOUND1-STATE_STARTUPSOUND0
    BNZ MAIN_SKIP_STARTUPSOUND1

    LDI #V_TIME_1       ; seconds
    PLO R_VAR_PTR
    LDN R_VAR_PTR
    BZ MAIN_SKIP_SOUND
    LDI #V_STATE
    PLO R_VAR_PTR
    LDI STATE_RUNNING
    STR R_VAR_PTR
    BR MAIN_PROCESS_TIME

MAIN_SKIP_STARTUPSOUND1
    LDI /SET_SOUND
    PHI PC_SUB
    LDI #SET_SOUND
    PLO PC_SUB
    SEP PC_SUB      ; call SET_SOUND
    SEQ             ; sound on

MAIN_SKIP_SOUND

    LDI /GET_KEYS
    PHI PC_SUB
    LDI #GET_KEYS
    PLO PC_SUB
    SEP PC_SUB      ; call GET_KEYS

    LDI /CAR_BEHAVIOR
    PHI PC_SUB
    LDI #CAR_BEHAVIOR
    PLO PC_SUB
    SEP PC_SUB      ; call CAR_BEHAVIOR

    LDI /CAR_BEHAVIOR2
    PHI PC_SUB
    LDI #CAR_BEHAVIOR2
    PLO PC_SUB
    SEP PC_SUB      ; call CAR_BEHAVIOR2

    LDI /CAR_BOUND
    PHI PC_SUB
    LDI #CAR_BOUND
    PLO PC_SUB
    SEP PC_SUB      ; call CAR_BOUND

MAIN_PROCESS_TIME
    LDI /PROCESS_TIME
    PHI PC_SUB
    LDI #PROCESS_TIME
    PLO PC_SUB
    SEP PC_SUB      ; call PROCESS_TIME

; check if V_STATE is STATE_END
    LDI #V_STATE
    PLO R_VAR_PTR
    LDN R_VAR_PTR
    SMI STATE_END
    BNZ MAIN_LOOP

    REQ             ; sound off
MAIN_STOP
    BR MAIN_STOP
