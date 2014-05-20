;   +------------------------------------------------------+
;   |                     PRESENTATION                     |
;   +------------------------------------------------------+
;   | @author Emilio Cobos <emiliocobos@usal.es>           |
;   | @author Eduardo Alonso Robles <edualorobles@usal.es> |
;   +------------------------------------------------------+


			.module flota
			.globl presentation
			.globl print

;---------------+
;   READ-ONLY   |
;---------------+
; NO PUEDO ESCRIBIR puntoASCIZ EN COMENTARIOS? EN SERIO?
; Cuando la cadena sobrepasa cierta longitud (64 bits) `asciz` da una violación de segmento<
presentation_str:
			.ascii "+----------------------------------------------------------+\n"
			.ascii "|                          Hundir la flota                 |\n"
			.ascii "+-----------------------+----------------------+-----------+\n"
			.ascii "| Emilio Cobos Alvarez  | emiliocobos@usal.es  | 70912324N |\n"
			.ascii "| Eduardo Alonso Robles | edualorobles@usal.es | 70901036V |\n"
			.ascii "+-----------------------+----------------------+-----------+\n"
			.ascii "\n\n"
			.byte 0


;------------------------------+
;   SIMPLE ENOUGH, ISN'T IT?   |
;------------------------------+
presentation:
;			ldx	#presentation_str
			leax	presentation_str,PCR
			jsr	print
			rts
