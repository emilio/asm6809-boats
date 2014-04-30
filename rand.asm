;   +--------------------------------------------+
;   |            RANDOM NUMBER GENERATOR         |
;   +--------------------------------------------+
;   | Emilio Cobos <emiliocobos@usal.es>         |
;   +--------------------------------------------+
			.module	flota_random
			.globl	rand
			.globl	RAND_LAST

; Theorically it should be completely random...
; TODO: Randomize
RAND_SEED:		.byte	32145645
RAND_LAST:		.byte	32145645
; Must be 2^n (so mod gets achieved with AND)
RAND_MAX:		.byte	0xFF
; A == 2 (así podemos usar rol para multiplicar)
; RAND_A:			.byte	234
RAND_C:			.byte	233

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
			rola
			adda	RAND_C

			; % m
			; anda	RAND_MAX (unnecessary since RAND_MAX == INT_MAX)
			
			sta	RAND_LAST
			rts
