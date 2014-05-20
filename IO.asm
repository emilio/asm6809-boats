;   +------------------------------------------------------+
;   |          INPUT OUTPUT SUBROUTINES                    |
;   +------------------------------------------------------+
;   | @author Emilio Cobos <emiliocobos@usal.es>           |
;   | @author Eduardo Alonso Robles <edualorobles@usal.es> |
;   +------------------------------------------------------+


			.module IO
			.globl  print
			.globl  puts
			.globl	print_hex
			.globl  reads
			.globl  lreads
			.globl	STDIN
			.globl	STDOUT

;---------------+
;   CONSTANTS   |
;---------------+

; IO:
STDIN			.equ 0xFF02 ; keyboard
STDOUT			.equ 0xFF00 ; screen

INPUT_END		.equ #10 ; \n

;   +--------------------------------------------+
;   |                print                       |
;   +--------------------------------------------+
;   | Prints a string stored in the direction    |
;   | pointed by `x` register                    |
;   |                                            |
;   | Must end with a `null` char (`\0`)         |
;   +--------------------------------------------+
;   | @param x                                   |
;   +--------------------------------------------+
print:
			pshu	a, x
print_loop:
			lda	,x+
			beq	print_end
			sta	STDOUT
			bra	print_loop
print_end:
			pulu	a, x
			rts

;   +--------------------------------------------+
;   |                puts                        |
;   +--------------------------------------------+
;   | Prints a string stored in the direction    |
;   | pointed by `x` register and INPUT_END      |
;   |                                            |
;   | Must end with a `null` char (`\0`)         |
;   +--------------------------------------------+
;   | @param x                                   |
;   +--------------------------------------------+

; we redo the logic after print to avoid too mani jsr's
puts:
			pshu	a, x
puts_loop:
			lda	,x+
			beq	puts_end
			sta	STDOUT
			bra	puts_loop
puts_end:
			lda	INPUT_END
			sta	STDOUT
			pulu	a, x
			rts

;   +--------------------------------------------+
;   |                print_hex_letter            |
;   +--------------------------------------------+
;   | Prints the hex letter corresponding to the |
;   | register a                                 |
;   |                                            |
;   | a must be between 0 and 15                 |
;   +--------------------------------------------+
;   | @param a                                   |
;   +--------------------------------------------+
print_hex_letter:
			pshu	a
			adda	#'0
			cmpa	#'9
			bge	print_hex_letter_letter
			bra	print_hex_letter_end
print_hex_letter_letter:
			adda	#7 ; distance from '9' to 'A' - 1
			
print_hex_letter_end:
			sta	STDOUT
			pulu	a
			rts

;   +--------------------------------------------+
;   |                print_hex                   |
;   +--------------------------------------------+
;   | Prints number in hexa                      |
;   +--------------------------------------------+
;   | @param a                                   |
;   +--------------------------------------------+
print_hex:
			pshu	a,b
			pshu	a

			ldb	#'0
			stb	STDOUT
			ldb	#'x
			stb	STDOUT

			anda	#0xF0
			lsra
			lsra
			lsra
			lsra
			jsr	print_hex_letter

			pulu	a

			anda	#0x0F
			jsr	print_hex_letter

			pulu	a,b
			rts

;   +--------------------------------------------+
;   |                reads                       |
;   +--------------------------------------------+
;   | Stores input in stack until user presses   |
;   | INPUT_END and saves it to `x`              |
;   |                                            |
;   | It also saves a `\0`                       |
;   | Note that this shit can overflow           |
;   +--------------------------------------------+
;   | @param x                                   |
;   +--------------------------------------------+
reads:
			pshu	a, x
reads_loop:
			lda	STDIN
			cmpa	INPUT_END
			beq	reads_end
			sta	,x+
			bra	reads_loop
reads_end:
			lda	#0
			sta	,x+
			pulu	a, x
			rts

;   +--------------------------------------------+
;   |                lreads                      |
;   +--------------------------------------------+
;   | Stores input in stack until length stored  |
;   | in `a` is reached or INPUT_END is pressed  |
;   |                                            |
;   | It also saves a `\0`                       |
;   +--------------------------------------------+
;   | @param x                                   |
;   | @param a                                   |
;   +--------------------------------------------+
lreads:
			pshu	a, b, x
			deca ; make some space for \0
lreads_loop:
			cmpa	#0 ; we reached the limit
			beq	lreads_end

			ldb	STDIN
			cmpb	INPUT_END
			beq	lreads_end

			stb	,x+
			deca
			bra	lreads_loop
lreads_end:
			ldb	#0
			stb	,x+
			pulu	a, b, x
			rts


;   +--------------------------------------------+
;   |                slength                     |
;   +--------------------------------------------+
;   | Stores in `a` the length of the string     |
;   | pointed by `x`                             |
;   +--------------------------------------------+
;   | @param x                                   |
;   | @modifies a                                |
;   +--------------------------------------------+

slength:
;   		pshu	a
			pshu	b, x
			clra
slength_loop:
			stb	,x+
			beq	slength_end
			inca
			bra	slength_loop
slength_end:
			pulu	b, x
			rts
