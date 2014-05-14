;   +--------------------------------------------+
;   |          HUNDIR LA FLOTA                   |
;   +--------------------------------------------+
;   | @author Emilio Cobos <emiliocobos@usal.es> |
;   +--------------------------------------------+

;------------------------+
;   LIBS AND CONSTANTS   |
;------------------------+
			.globl	presentation
			.globl	game_generate_map
			.globl	game_shoot_count_reset
			.globl	game_loop
			.globl	FIELD
			.globl	USER_FIELD

PROGRAM_END_CELL	.equ 0xFF01
;			.area PROG(ABS)
;			.org 0x0300
			.globl PROGRAM_START

;--------------------------+
;    PROGRAM-LEVEL VARS    |
;--------------------------+

; The field is 8x8
; Since it just has two states, with 64 bits we have the whole field!
FIELD:
			;.byte 3 ; for testing: one boat in the top right corner
			.byte 0
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
			jsr game_generate_map
			jsr game_shoot_count_reset ; Reset the shoot count (this is a workaround, shouldnt increment when shooting to generate the map, but its easier than creating another subroutine)
			jsr game_loop

PROGRAM_END:
			clra
			sta PROGRAM_END_CELL
			.area PR_END(ABS)
			.org 0xFFFE
			.word PROGRAM_START
