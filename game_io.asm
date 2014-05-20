;   +------------------------------------------------------+
;   |                          GAME IO                     |
;   +------------------------------------------------------+
;   | @author Emilio Cobos <emiliocobos@usal.es>           |
;   | @author Eduardo Alonso Robles <edualorobles@usal.es> |
;   +------------------------------------------------------+

			.module	flota_io
			.globl	game_generate_map
			.globl	game_print_map_solved
			.globl	game_print_map_current
			.globl	game_ask
			.globl	game_shoot
			.globl	game_is_solved
			.globl	game_reset_shoot_count
			.globl	game_solved
			.globl	game_surrender
			.globl	FIELD
			.globl	USER_FIELD
			.globl	print
			.globl	lreads
			.globl	STDOUT
			.globl	usrand
			.globl	rand
			.globl	print_hex


;---------------+
;   READ-ONLY   |
;---------------+

BOATS_NUM:		.byte 4 ; Number of boats

GAME_ASK_STR:		.ascii "\nCasilla o q para rendirse: "
			.byte 0

GAME_SOLVED_STR:	.ascii "\nHAS RESUELTO EL JUEGO!\n\n"
			.byte 0

GAME_SURRENDER_STR:	.ascii "\nTE HAS RENDIDO\n\n"
			.byte 0

GAME_SHOOT_COUNT_BEFORE_STR:
			.ascii "\nHas necesitado "
			.byte 0

GAME_SHOOT_COUNT_AFTER_STR:
			.ascii " tiradas\n"
			.byte 0

GAME_UNKNOWN_CHAR:	.byte	#'-
GAME_WATER_CHAR:	.byte	#'~
GAME_BOAT_CHAR:		.byte	#'x

;----------------+
;   READ-WRITE   |
;----------------+
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

GAME_SHOOT_COUNT:	.byte 0

; 3 bytes for answer (q if quit, position if not)
GAME_ANSWER:		.byte 0
			.byte 0
			.byte 0

TEMP_BYTE:		.byte 0
GPMSOLVED:		.byte 0

;   +--------------------------------------------+
;   |                 int_to_mask                |
;   +--------------------------------------------+
;   | Generates the adecuate mask for y coord    |
;   | and stores it in TEMP_BYTE                 |
;   +--------------------------------------------+
;   | @param b                                   |
;   | @modifies TEMP_BYTE                        |
;   +--------------------------------------------+
int_to_mask:
			pshu	a,b
			; we generate a mask like 0x00000001
			; to invert it, later make the or, and check for the bit we are interested in
			; 2^(7-b)
			; we calculate 7-b and we store it in a
			lda	#7
			stb	TEMP_BYTE
			suba	TEMP_BYTE

			; we loop `a` times multiplying b * 2
			; (shifting the byte to the left)
			ldb	#1
int_to_mask_loop:
			cmpa	#0
			beq	int_to_mask_end
			lslb
			deca
			bra	int_to_mask_loop

int_to_mask_end:
			; store mask in TEMP_BYTE
			stb	TEMP_BYTE
			pulu	a,b
			rts

;   +--------------------------------------------+
;   |              game_generate_map             |
;   +--------------------------------------------+
;   | Generates the map randomly                 |
;   +--------------------------------------------+
;   | @modifies TEMP_BYTE                        |
;   +--------------------------------------------+
game_generate_map:
			jsr	usrand
			; TODO: get number of boats & randomize them
			pshu	a,b,x
;			ldx	#FIELD
			leax	FIELD,PCR
			ldb	BOATS_NUM
			incb

game_generate_map_boat:
			decb
			beq	game_generate_map_end ; while(--b)...
			pshu	b

			jsr	rand ; store random number in a
			anda	#0x07 ; make it between 0 and 7

			sta	TEMP_BYTE; move it to b
			ldb	TEMP_BYTE

			jsr	rand ; now we keep it in a
			anda	#0x07

;			ldx	#FIELD
			leax	FIELD,PCR
			jsr	game_shoot

; for debugging
game_generate_map_boat_second:
			; TODO: get the second boat part
			pshu	a

			; We pick a number between 0 and 3 // , and store it in TEMP_BYTE
			jsr	rand
			anda	0x03
			; sta	TEMP_BYTE
			; 0 => top | 1 => bot | 2 => left | 3 => right
			; when we can't, we choose the inverse
			; cmpa	#0
			beq	game_generate_map_boat_top
			cmpa	#1
			beq	game_generate_map_boat_bot
			cmpa	#2
			beq	game_generate_map_boat_left
			; cmpa	#3
			; beq	game_generate_map_boat_right
			bra	game_generate_map_boat_right

; TODO: get better tag names

game_generate_map_boat_top: ; decrement a coord
			pulu	a
			cmpa	#0; if we cant decrement it, increment it
			beq	game_generate_map_boat_bot_redirect
game_generate_map_boat_top_redirect:
			deca
			bra	game_generate_map_boat_end

game_generate_map_boat_bot: ; increment a coord
			pulu	a
			cmpa	#7
			beq	game_generate_map_boat_top_redirect
game_generate_map_boat_bot_redirect:
			inca
			bra	game_generate_map_boat_end

game_generate_map_boat_left:
			pulu	a
			cmpb	#0
			beq	game_generate_map_boat_right_redirect
game_generate_map_boat_left_redirect:
			decb
			bra	game_generate_map_boat_end

game_generate_map_boat_right:
			pulu	a
			cmpb	#7
			beq	game_generate_map_boat_left_redirect
game_generate_map_boat_right_redirect:
			incb
			; bra	game_generate_map_boat_end

game_generate_map_boat_end:
			; here we have the two coords of the new boat part
;			ldx	#FIELD
			leax	FIELD,PCR
			jsr	game_shoot
			pulu	b
			bra	game_generate_map_boat

game_generate_map_end:
			pulu	a,b,x
			rts

;   +--------------------------------------------+
;   |                game_print_map              |
;   +--------------------------------------------+
;   | Prints the map, either solved or not       |
;   +--------------------------------------------+
;   | @param GPMSOLVED show it solved or not     |
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
			jsr int_to_mask
			; now we have int TEMP_BYTE the correct mask

			; we store it this way in the stack cause we want to retrieve them at different times
			pshu	b
			pshu	a

			lda	GPMSOLVED
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

			pulu	b ; rescue the current loop index

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
			pshu	a,x

;			ldx	#FIELD
			leax	FIELD,PCR
			lda	a, x
			bita	TEMP_BYTE

			; if result is 0, the interesting bit was 0, so we choose the water char
			beq	choose_char_water

			; else we choose the water char
			ldb	GAME_BOAT_CHAR
			bra	choose_char_end

choose_char_water:
			ldb	GAME_WATER_CHAR
choose_char_end:
			pulu	a,x
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
			pshu	a,x
			; load the user map row in a
;			ldx	#USER_FIELD
			leax	USER_FIELD,PCR
			ldb	a, x

			; apply the mask (deactivate all the bits except the interesting one)
			bitb	TEMP_BYTE

			beq	choose_uchar_unknown

;			ldx	#FIELD
			leax	FIELD,PCR
			ldb	a, x
			bitb	TEMP_BYTE

			; if result is 0, the interesting bit was 0, so we choose the water char
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
			pulu	a,x
			rts

;   +--------------------------------------------+
;   |            game_print_map_solved           |
;   +--------------------------------------------+
;   | Prints the map solved                      |
;   +--------------------------------------------+
game_print_map_solved:
			pshu	a
			lda	#1
			sta	GPMSOLVED
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
			sta	GPMSOLVED
			pulu	a
			jsr	game_print_map
			rts
;   +--------------------------------------------+
;   |                 game_shoot                 |
;   +--------------------------------------------+
;   | Shoots to a x,y coordinate                 |
;   +--------------------------------------------+
;   | @param a x coord                           |
;   | @param b y coord                           |
;   | @param x map direction                     |
;   +--------------------------------------------+
game_shoot:
			pshu	a,b,x

			; ldx	#USER_FIELD ; get the map
			jsr	int_to_mask ; generate the correct mask


			ldb	a, x ; get the row

			orb	TEMP_BYTE ; apply the mask to the row, enabling the bit
			stb	a, x ; and store it again

			inc	GAME_SHOOT_COUNT

			pulu	a,b,x
			rts

;   +--------------------------------------------+
;   |                 game_ask                   |
;   +--------------------------------------------+
;   | Ask a user for a position in the map or `q`|
;   +--------------------------------------------+
;   | @modifies a x coordinate or -1 if quit     |
;   | @modifies b y coord                        |
;   +--------------------------------------------+
game_ask:
			pshu	x
game_ask_start:
;			ldx	#GAME_ASK_STR
			leax	GAME_ASK_STR,PCR
			jsr	print

			lda	#3 ; we want 3 chars (two plus \0)
;			ldx	#GAME_ANSWER
			leax	GAME_ANSWER,PCR
			jsr	lreads

			lda	0, x ; load the first char in a

game_ask_debug: ; just for debugging purposes
			; if first char is `q`, we return
			cmpa	#'q
			beq	game_ask_error
			cmpa	#'Q
			beq	game_ask_error

			; validation
			cmpa	#'A
			blo	game_ask_start
			cmpa	#'H
			bhi	game_ask_check_lower ; if it's bigger than 'H' it might be a lowercase letter
			suba	#'A
			bra	game_ask_number ; if not, we're done, check the number

game_ask_check_lower:
			cmpa	#'a
			blo	game_ask_start
			cmpa	#'h
			bhi	game_ask_start
			suba	#'a
game_ask_number:
			ldb	1,x ; load the second char in b

			cmpb	#'1
			blo	game_ask_start
			cmpb	#'8
			bhi	game_ask_start

			subb	#'1

			bra	game_ask_end
game_ask_error:
			lda	#-1
game_ask_end:
			pshu	b
			ldb	#'\n
			stb	STDOUT

			pulu	b
			pulu	x
			rts

;   +--------------------------------------------+
;   |                 game_is_solved             |
;   +--------------------------------------------+
;   | Check if map is solved                     |
;   +--------------------------------------------+
;   | @modifies a 0 if solved, other if not      |
;   +--------------------------------------------+
game_is_solved:
			pshu	b, x, y
			; loop through all rows (from 7 to 0 for comodity)
			; equivalent to:
			; a = 8;
			; while(a--) {
			; 	if( ((field[a] ^ user_field[a]) & field[a]) != 0 ) {
			; 		return a; // Not solved
			; 	}
			; }
			; return 0;
			lda	#8
;			ldx	#FIELD
			leax	FIELD,PCR
;			ldy	#USER_FIELD
			leay	USER_FIELD,PCR
game_is_solved_loop:
			cmpa	#0
			beq	game_is_solved_end
			deca
			; load in b the field row and xor it with a,y (user field)
			ldb	a,x
			eorb	a,y
			; this logical and is to avoid errors wen user checks a water field
			bitb	a,x
			; if its 0 we keep looping
			beq	game_is_solved_loop
game_is_solved_end:
			pulu	b, x, y
			rts

;   +--------------------------------------------+
;   |            game_print_shoot_count          |
;   +--------------------------------------------+
;   | Print the shoot count                      |
;   +--------------------------------------------+
game_print_shoot_count:
			pshu	a

;			ldx	#GAME_SHOOT_COUNT_BEFORE_STR
			leax	GAME_SHOOT_COUNT_BEFORE_STR,PCR
			jsr	print

			lda	GAME_SHOOT_COUNT
			jsr	print_hex

;			ldx	#GAME_SHOOT_COUNT_AFTER_STR
			leax	GAME_SHOOT_COUNT_AFTER_STR,PCR
			jsr	print

			pulu	a
			rts


;   +--------------------------------------------+
;   |            game_reset_shoot_count          |
;   +--------------------------------------------+
;   | Reset the shoot count                      |
;   +--------------------------------------------+
game_reset_shoot_count:
			pulu	a
			lda	#0
			sta	GAME_SHOOT_COUNT
			pshu	a
			rts
;   +--------------------------------------------+
;   |                 game_solved                |
;   +--------------------------------------------+
;   | User has solved the map, congratulate him  |
;   +--------------------------------------------+
game_solved:
			jsr	game_print_map_solved

;			ldx	#GAME_SOLVED_STR
			leax	GAME_SOLVED_STR,PCR
			jsr	print
			jsr	game_print_shoot_count
			rts

;   +--------------------------------------------+
;   |                 game_surrender             |
;   +--------------------------------------------+
;   | User has quitted                           |
;   +--------------------------------------------+
game_surrender:
			jsr	game_print_map_solved
;			ldx	#GAME_SURRENDER_STR
			leax	GAME_SURRENDER_STR,PCR
			jsr	print
			jsr	game_print_shoot_count
			rts
