STDIN			.equ 0xFF02 ; keyboard
STDOUT			.equ 0xFF00 ; screen
PROGRAM_END_CELL	.equ 0xFF01
			.area PROG(ABS)
			.org 0x0300
			.globl PROGRAM_START
			.globl rand

; Prints the hex letter corresponding to the register a
; a must be between 0 and 15
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


; Prints number in hexa
; @param a
print_num:
			pshu	a
			pshu	a

			anda	#0xF0
			rora
			rora
			rora
			rora
			jsr	print_hex_letter

			pulu	a

			anda	#0x0F
			jsr	print_hex_letter

			pulu	a
			rts




PROGRAM_START:
			ldu #0xFF00 ; init user stack
			lda	#0xC3
			jsr	print_num
			ldb	#8
bucle:
			decb
			beq	PROGRAM_END			
			jsr	rand
			jsr	print_num
			lda	#'\n
			sta	STDOUT
			bra	bucle
PROGRAM_END:
			clra
			sta PROGRAM_END_CELL
			.org 0xFFFE
			.word PROGRAM_START
