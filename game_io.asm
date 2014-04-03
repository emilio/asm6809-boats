;	+--------------------------------------------+
;	|                  GAME IO                   |
;	+--------------------------------------------+
;	| @author Emilio Cobos <emiliocobos@usal.es> |
;	+--------------------------------------------+

					.module		flota_io
					.globl		game_print_map
					.globl		STDOUT
					.globl		FIELD
					.globl		USER_FIELD
;---------------+
;	READ-ONLY   |
;---------------+

GAME_UNKNOWN_CHAR:		.byte	#'-
GAME_WATER_CHAR:		.byte	#'~
GAME_BOAT_CHAR:			.byte	#'x

;	+--------------------------------------------+
;	|                game_print_map              |
;	+--------------------------------------------+
;	| Prints the map in its current state        |
;	+--------------------------------------------+
game_print_map:
						pshu	a
						pshu	b
						; print the first row: tab, number, tab...
						lda		#'1	; from one to 8
game_print_first_row:
						cmpa	#'9
						beq		game_print_rows
						; we put a tab an the number
						ldb		#'\t
						stb		STDOUT
						sta		STDOUT
						inca
						bra		game_print_first_row
game_print_rows:
						ldb		#'\n
						stb		STDOUT
						; 'A' == 65
						ldb		#0 ; From A to H
game_print_rows_loop:
						cmpb	#8
						beq		game_print_end
game_print_row:
						; put the letter and a tab
						addb	#65
						stb		STDOUT
						subb	#65
						lda		#'\t
						sta		STDOUT

						; loop from 0 to 7
						lda		#0
game_print_row_loop:
						cmpa	#8
						beq		game_print_row_end

						; Here we have, in a and b the (x,y) coordinates
						pshu	a, b

						; field_row = FIELD + a
						ldb		GAME_WATER_CHAR
						stb		STDOUT

						ldb		#'\t
						stb		STDOUT

						pulu	a, b


						inca
						bra		game_print_row_loop
game_print_row_end:
						lda		#'\n
						sta		STDOUT
						incb
						bra		game_print_rows_loop
game_print_end:
						pulu	b
						pulu	a
						rts
