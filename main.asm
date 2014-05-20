;   +------------------------------------------------------+
;   |                    HUNDIR LA FLOTA                   |
;   +------------------------------------------------------+
;   | @author Emilio Cobos <emiliocobos@usal.es>           |
;   | @author Eduardo Alonso Robles <edualorobles@usal.es> |
;   +------------------------------------------------------+

;------------------------+
;   LIBS AND CONSTANTS   |
;------------------------+
			.globl	presentation
			.globl	game_generate_map
			.globl	game_reset_shoot_count
			.globl	game_loop

PROGRAM_END_CELL	.equ 0xFF01
;			.area PROG(ABS)
;			.org 0x0300
			.globl PROGRAM_START

PROGRAM_START:
			ldu #0xFF00 ; init user stack
			jsr presentation
			jsr game_generate_map
			; Reset the shoot count
			; this is a workaround, shouldnt increment when shooting to generate the map
			; but its easier than creating another subroutine
			jsr game_reset_shoot_count
			jsr game_loop

PROGRAM_END:
			clra
			sta PROGRAM_END_CELL
			.area PR_END(ABS)
			.org 0xFFFE
			.word PROGRAM_START
