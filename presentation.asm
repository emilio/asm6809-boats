;	+--------------------------------------------+
;	|                PRESENTATION                |
;	+--------------------------------------------+
;	| @author Emilio Cobos <emiliocobos@usal.es> |
;	+--------------------------------------------+


					.module flota
					.globl presentation
					.globl print

;---------------+
;	READ-ONLY   |
;---------------+
; Cuando la cadena sobrepasa cierta longitud (64 bits) da una violación de segmento, así que lo haremos con varias cadenas
;presentation_str:	.asciz "\tHundir la flota\t\n------------------------------\n  Emilio Cobos (70912324-N)\n"
presentation_str:	.asciz "\tHundir la flota\t\n------------------------------\n"
presentation_str_2:	.asciz "  Emilio Cobos (70912324-N)\n"


;------------------------------+
;	SIMPLE ENOUGH, ISN'T IT?   |
;------------------------------+
presentation:
					ldx		#presentation_str
					jsr		print
					ldx		#presentation_str_2
					jsr		print
					rts
