;   +--------------------------------------------+
;   |                  GAME IO                   |
;   +--------------------------------------------+
;   | @author Emilio Cobos <emiliocobos@usal.es> |
;   +--------------------------------------------+
			.module	flota_loop
			.globl	game_loop
			.globl	game_print_map_solved
			.globl	game_print_map_current
			.globl	game_solved
			.globl	game_surrender
			.globl	game_ask
			.globl	game_is_solved
			.globl	game_shoot
			.globl	print
			.globl	STDOUT
			.globl	FIELD
			.globl	USER_FIELD


;   +--------------------------------------------+
;   |                 game_loop                  |
;   +--------------------------------------------+
;   | This is all the game logic                 |
;   +--------------------------------------------+
game_loop:
			jsr	game_print_map_current
			jsr	game_ask

			; if user pressed q we quit
			cmpa	#-1
			beq	game_loop_surrender

			; else we shoot and continue the loop
			leax	USER_FIELD,PCR
			jsr	game_shoot

			; TODO: check and print status (return from game_shoot)
			jsr	game_is_solved
			beq	game_loop_solved

			bra	game_loop

game_loop_surrender:
			jsr	game_surrender
			bra	game_loop_end

game_loop_solved:
			jsr	game_solved
			; bra	game_loop_end
game_loop_end:
			rts
