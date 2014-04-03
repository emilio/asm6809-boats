;	+--------------------------------------------+
;	|          HUNDIR LA FLOTA                   |
;	+--------------------------------------------+
;	| @author Emilio Cobos <emiliocobos@usal.es> |
;	+--------------------------------------------+

;------------------------+
;	LIBS AND CONSTANTS   |
;------------------------+
;					.include	"IO.asm"
;					.include 	"presentation.asm"
;					.include 	"game.asm"
					.globl		presentation
					.globl		game_print_map
					.globl		FIELD
					.globl		USER_FIELD

PROGRAM_END_CELL	.equ 0xFF01

	                .area PROG(ABS)
    	            .org 0x0300


        	        .globl PROGRAM_START

;--------------------------+
;    PROGRAM-LEVEL VARS    |
;--------------------------+

; The field is 8x8
; Since it just has two states, with 64 bits we have the whole field!
FIELD:
;					.byte 0
					.byte 3 ; for testing: one boat in the top right corner
					.byte 0
					.byte 0
					.byte 0
					.byte 0
					.byte 0
					.byte 0
					.byte 0

; If the user already checked a field then a `1` is stored here
USER_FIELD:
					.byte 0
					.byte 0
					.byte 0
					.byte 0
					.byte 0
					.byte 0
					.byte 0
					.byte 0

PROGRAM_START:
					ldu #0xFF00 ; init user stack
					jsr presentation
					jsr game_print_map

PROGRAM_END:
					clra
					sta PROGRAM_END_CELL
					.org 0xFFFE
					.word PROGRAM_START
