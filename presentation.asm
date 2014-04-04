;   +--------------------------------------------+
;   |                PRESENTATION                |
;   +--------------------------------------------+
;   | @author Emilio Cobos <emiliocobos@usal.es> |
;   +--------------------------------------------+


			.module flota
			.globl presentation
			.globl print

;---------------+
;   READ-ONLY   |
;---------------+
; NO PUEDO ESCRIBIR puntoASCIZ EN COMENTARIOS? EN SERIO?
; Cuando la cadena sobrepasa cierta longitud (64 bits) `asciz` da una violación de segmento<
presentation_str:
			.ascii "\tHundir la flota\t\n------------------------------\n  Emilio Cobos (70912324-N)\n"
			.byte 0


;------------------------------+
;   SIMPLE ENOUGH, ISN'T IT?   |
;------------------------------+
presentation:
			ldx	#presentation_str
			jsr	print
			rts
