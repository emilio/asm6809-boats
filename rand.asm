;   +------------------------------------------------------+
;   |                 RANDOM NUMBER GENERATOR              |
;   +------------------------------------------------------+
;   | @author Emilio Cobos <emiliocobos@usal.es>           |
;   | @author Eduardo Alonso Robles <edualorobles@usal.es> |
;   +------------------------------------------------------+
			.module	flota_random
			.globl	rand
			.globl	srand
			.globl	usrand
			.globl	RAND_LAST
			.globl	RAND_MAX
			.globl	print
			.globl	STDIN
			.globl	STDOUT

USRAND_STR:		.ascii	"Introduce semilla:"
			.byte	0

; Theorically it should be completely random...
; TODO: Randomize
RAND_LAST:		.byte	0x01
; Must be 2^n - 1 (so mod gets achieved with AND)
RAND_MAX:		.byte	0xFF
; A == 2 (así podemos usar rol para multiplicar)
; A == 4
; RAND_A:			.byte	233
RAND_C:			.byte	0x12

;   +--------------------------------------------+
;   |                    rand                    |
;   +--------------------------------------------+
;   | Stores in `a` a randon number              |
;   +--------------------------------------------+
;   | @modifies a                                |
;   +--------------------------------------------+
rand:
			; xn * A + c
			lda	RAND_LAST

			; A = 1
;			lsla
;			lsla

			adda	RAND_C

			; % m
			; anda	RAND_MAX
			
			sta	RAND_LAST
			rts

srand:
			sta	RAND_LAST
			rts

usrand:
			pshu	x,a
;			ldx	#USRAND_STR
			leax	USRAND_STR,PCR
			jsr	print
			lda	STDIN
			sta	RAND_LAST
			lda	#'\n
			sta	STDOUT
			pulu	x,a
			rts
