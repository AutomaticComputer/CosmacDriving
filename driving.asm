; 3D driving for Cosmac VIP.
;

; How to modify: 
;
; To change how the car reacts to steering, see SPEED_TO_DIR in car_behavior.asm. 
;
; The course data is in CURVATURE_MAP in set_line_data.asm. 
; A data l < 8 corresponds to CURVATURE_SCALED[l] in car_behavior.asm, 
; and a data l > 8 means -CURVATURE_SCALED[l-8]. 
; CURV_DELTA_DIST in set_line_data.asm has to match CURVATURE_SCALED: 
; roughly, CURV_DELTA_DIST = CURVATURE_SCALED * (differences of Y_TO_DIST)

	.cr 1802

TARGET_VIP		.eq 0
TARGET_ELF		.eq 1

; TARGET			.eq TARGET_VIP
TARGET			.eq TARGET_ELF

	.do TARGET=TARGET_VIP
FLAG_4KB		.eq 0
; FLAG_4KB		.eq 1		; only for VIP
FLAG_COLOR		.eq 0
; FLAG_COLOR		.eq 1		; only for VIP
	.el
FLAG_4KB		.eq 0
FLAG_COLOR		.eq 0
	.fi

	.do TARGET=TARGET_VIP
	.do FLAG_COLOR=0
	.do FLAG_4KB=1
	.tf driving_vip_4kb.bin,bin
	.el
	.tf driving_vip.bin,bin
	.fi
	.el	; with color

	.do FLAG_4KB=1
	.tf driving_vip_color_4kb.bin,bin
	.el
	.tf driving_vip_color.bin,bin
	.fi
	.fi
	.fi

	.do TARGET=TARGET_ELF
	.tf driving_elf.bin,bin
	.fi


R_DMA			.eq $0
PC_INT			.eq $1
STACK			.eq $2		; Also used in interrupt handler. 
							; In subroutines, the M(STACK) can be used as a scratch memory
PC_MAIN 		.eq	$3
PC_SUB			.eq	$4
PC_SUBSUB 		.eq $5
R_CUR_PAGE		.eq	$6		; Upper byte must always point to the page currently drawn
							; (used in interrupt handler)
R_FR_CNT		.eq $7

R_VAR_PTR       .eq $8      ; Upper byte must always be $0D 
R_WORK_PTR      .eq $9      ; Upper byte must always be $0D
R_TABLE_PTR     .eq $A

WORK_PAGE		.eq $0D		; contains variables and stack area
VIDEO_PAGE0		.eq $0E
VIDEO_PAGE1		.eq $0F
STACK_INITIAL	.eq $0DFF
LINE_DATA		.eq $0D00	; ... but hardcoded in set_line_data.asm and draw_road.asm
CENTER_DATA 	.eq $0D10	; whether center line(dot) is to be drawn

COLOR_PAGE		.eq $D0

V_X_CAR		  	.eq $40		; 2 byte 
V_DIR_REL	  	.eq $42		; 2 byte 
V_DIR_CAR     	.eq $44   	; 2 bytes
V_DIST_CAR    	.eq $46   	; 2 bytes
V_DIR_ROAD	  	.eq $48   	; 2 bytes
V_SPEED		  	.eq $4A		; 1 byte 
V_STATE		  	.eq $4B		; 1 byte

STATE_STARTUPSOUND0	.eq 0
STATE_STARTUPSOUND1	.eq 1
STATE_RUNNING		.eq 2
STATE_END			.eq 3

V_KEY_LEFT    	.eq $50		; 0/non-0
V_KEY_RIGHT	  	.eq $51		; 0/non-0
V_KEY_DOWN    	.eq $52		; 0/non-0
V_KEY_UP	  	.eq $53		; 0/non-0

V_LAST_FRAME  	.eq $54
V_ELAPSED     	.eq $55
V_TIME_3	  	.eq $56		; 100s
V_TIME_2	  	.eq $57		; 10s
V_TIME_1	  	.eq $58		; s
V_TIME_0	  	.eq $59		; 1/10 s
V_TIME_FRAC	  	.eq $5A		; 1/60 s


V_LOCAL_S   	.eq $60     ; 2 bytes
V_LOCAL_K   	.eq $62     ; 2 bytes
V_WORK_0   		.eq $70
V_WORK_1    	.eq $72

; stack up to $0DFF (but only a few bytes are actually used)

	.in startup.asm
	.in main.asm

	.in clear_page.asm
	.in keys.asm
	.in title.asm
	.in mult.asm
	.in draw_road.asm
	.in draw_buildings.asm
	.in draw_car.asm
	.in process_time.asm
	.in car_behavior.asm
	.in car_behavior2.asm
	.in car_bound.asm
	.in sound.asm
	.in set_line_data.asm
	.in title_bitmap.asm
	.in interrupt.asm

	.do FLAG_COLOR=1
	.in color.asm
	.fi

	.do TARGET=TARGET_VIP
	.do FLAG_4KB=1
	.no $0FFF				; for building 4KB bin file
	.db $00
	.fi
	.fi
