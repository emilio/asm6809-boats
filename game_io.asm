;   +--------------------------------------------+
;   |                  GAME IO                   |
;   +--------------------------------------------+
;   | @author Emilio Cobos <emiliocobos@usal.es> |
;   +--------------------------------------------+

			.module	flota_io
			.globl	game_print_map_solved
			.globl	game_print_map_current
			.globl	STDOUT
			.globl	FIELD
			.globl	USER_FIELD

;---------------+
;   READ-ONLY   |
;---------------+

GAME_UNKNOWN_CHAR:	.byte	#'-
GAME_WATER_CHAR:	.byte	#'~
GAME_BOAT_CHAR:		.byte	#'x

;----------------+
;   READ-WRITE   |
;----------------+
TEMP_BYTE:		.byte 0
SOLVED:			.byte 0


;   +--------------------------------------------+
;   |                game_print_map              |
;   +--------------------------------------------+
;   | Prints the map, either solved or not       |
;   +--------------------------------------------+
;   | @param SOLVED show it solved or not        |
;   +--------------------------------------------+
game_print_map:
			pshu	a, b
			; print the first row: tab, number, tab...
			lda	#'1	; from one to 8
game_print_first_row:
			cmpa	#'9
			beq	game_print_rows
			; we put a tab an the number
			ldb	#'\t
			stb	STDOUT
			sta	STDOUT
			inca
			bra	game_print_first_row
game_print_rows:
			ldb	#'\n
			stb	STDOUT
			; 'A' == 65
			lda	#0 ; From A to H
game_print_rows_loop:
			cmpa	#8
			beq	game_print_end
game_print_row:
			; put the letter and a tab
			adda	#65
			sta	STDOUT
			suba	#65
			ldb	#'\t
			stb	STDOUT

			; loop from 0 to 7
			ldb	#0
game_print_row_loop:
			cmpb	#8
			beq	game_print_row_end

			; Here we have, in a and b the (x, y) coordinates
			pshu	a, b, x
			; we want to rescue a two times
			pshu	a

			; field_row = FIELD + a
			; Here we choose the char to show
			; we generate a mask like 0x00000001
			; to invert it, later make the or, and check for the bit we are interested in
			; 2^(7-b)
			; we calculate 7-b y lo store it in a
			lda	#7
			stb	TEMP_BYTE
			suba	TEMP_BYTE

			; we loop `b` times multiplying b * 2
			; (shifting the byte to the left)
			ldb	#1
game_print_row_mask:
			cmpa	#0
			beq	game_print_row_mask_end
			rolb
			deca
			bra	game_print_row_mask

game_print_row_mask_end:
			; store mask in TEMP_BYTE
			stb	TEMP_BYTE

			lda	SOLVED
			beq	game_print_char_method_current

			pulu	a
			jsr	choose_char
			bra 	game_print_char_method_end

game_print_char_method_current:
			pulu	a
			jsr	choose_uchar

game_print_char_method_end:
			stb	STDOUT
			ldb	#'\t
			stb	STDOUT

			pulu	a, b, x

			incb
			bra	game_print_row_loop
game_print_row_end:
			ldb	#'\n
			stb	STDOUT
			inca
			bra	game_print_rows_loop
game_print_end:
			pulu	a, b
			rts

;   +--------------------------------------------+
;   |                choose_char                 |
;   +--------------------------------------------+
;   | Chooses the correct char given             |
;   | map row in `a` and mask in TEMP_BYTE       |
;   +--------------------------------------------+
;   | @param a x coordinate                      |
;   | @param TEMP_BYTE the mask generated        |
;   | @modifies b where char is stored           |
;   +--------------------------------------------+
choose_char:
			pshu	a

			ldx	#FIELD
			lda	a, x
			bita	TEMP_BYTE

			; if result is 0, the interesting bit was 1, so we choose the boat char
			beq	choose_char_water

			; else we choose the water char
			ldb	GAME_BOAT_CHAR
			bra	choose_char_end

choose_char_water:
			ldb	GAME_WATER_CHAR
choose_char_end:
			pulu a
			rts

;   +--------------------------------------------+
;   |                choose_uchar                |
;   +--------------------------------------------+
;   | Chooses the correct char given             |
;   | map row in `a` and mask in TEMP_BYTE       |
;   +--------------------------------------------+
;   | @param a x coordinate                      |
;   | @param TEMP_BYTE the mask generated        |
;   | @modifies b where char is stored           |
;   +--------------------------------------------+
choose_uchar:
			pshu	a
			; load the user map row in a
			ldx	#USER_FIELD
			lda	a, x

			; apply the mask (deactivate all the bits except the interesting one)
			bita	TEMP_BYTE

			beq	choose_uchar_unknown

			ldx	#FIELD
			lda	a, x
			bita	TEMP_BYTE

			; if result is 0, the interesting bit was 1, so we choose the boat char
			beq	choose_uchar_water

			; else we choose the water char
			ldb	GAME_BOAT_CHAR
			bra	choose_uchar_end

choose_uchar_water:
			ldb	GAME_WATER_CHAR
			bra	choose_uchar_end
choose_uchar_unknown:
			ldb	GAME_UNKNOWN_CHAR
choose_uchar_end:
			pulu a
			rts

;   +--------------------------------------------+
;   |            game_print_map_solved           |
;   +--------------------------------------------+
;   | Prints the map solved                      |
;   +--------------------------------------------+
game_print_map_solved:
			pshu	a
			lda	#1
			sta	SOLVED
			pulu	a
			jsr	game_print_map
			rts

;   +--------------------------------------------+
;   |            game_print_map_current          |
;   +--------------------------------------------+
;   | Prints the map in its current state        |
;   +--------------------------------------------+
game_print_map_current:
			pshu	a
			lda	#0
			sta	SOLVED
			pulu	a
			jsr	game_print_map
			rts
