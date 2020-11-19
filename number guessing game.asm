org	00000H
	sjmp	_MAIN
org	0000BH
	ljmp	_timer

_MAIN:
C5:	acall	_init_lcd
	acall	_clear_lcd
	mov	DPTR, #_string_db		;Welcome to play
	acall	_lcd_string
	acall	_set_cursor
	mov	DPTR, #_string_db2		;Guess a number  
	acall	_lcd_string
	acall	_clear_lcd
	mov	DPTR, #_string_db3		;from 0 to 99 
	acall	_lcd_string
	acall	_set_cursor
	mov	DPTR, #_string_db4		;Make it bingo as
	acall	_lcd_string
	acall	_clear_lcd
	mov	DPTR, #_string_db5		;soon as you can 
	acall	_lcd_string
	acall	_clear_lcd
	acall	_set_cursor			;move to second line

	mov	TMOD, #01			;Initialize the timer 0
	mov	TH0, #255
	mov	TL0, #156
	mov	TCON, #010H 
	SETB	TR0
	mov	IE, #082H
	
	mov	DPTR, #0A003H			;turn off the leds
	mov	A, #83H
	movx	@DPTR, A
	mov	DPTR, #0A000H
	mov	A, #0000B
	movx	@DPTR, A
	mov	R2, #33H			;count how many times you can guess and display
	
C4:	acall	_clear_lcd
	mov	DPTR, #_string_db9		;Input :
	acall	_lcd_string
C7:	acall	_set_cursor
	mov	R3, #10000000B    		;for count which figure
C3:	mov	DPTR, #09003H
	mov	A, #82H
	movx	@DPTR, A
	acall	_scankey
	
	sjmp	C3
		
_scankey:					;scan the keyboard
	mov	R1, #11111110B
	mov	20H, #4D
C1:	mov	DPTR, #09003H
	mov	A, #82H
	movx	@DPTR, A
	mov	DPTR, #09000H
	mov	A, R1
	movx	@DPTR, A
	push	ACC
	jnb	ACC.0,row1
	jnb	ACC.1,row2
	jnb	ACC.2,row3
	jnb	ACC.3,row4
C2:	pop	ACC
	RL	A
	mov	R1, A
	djnz	20H, C1
	ret
	
row1:	mov	DPTR, #09001H
	movx	A, @DPTR
	acall	_Delay
	jnb	ACC.0,_NUM1
	jnb	ACC.1,_NUM2
	jnb	ACC.2,_NUM3
	jnb	ACC.3,_NUMA
	sjmp	C2
row2:	mov	DPTR, #09001H
	movx	A, @DPTR
	acall	_Delay
	jnb	ACC.0,_NUM4
	jnb	ACC.1,_NUM5
	jnb	ACC.2,_NUM6
	jnb	ACC.3,_NUMB
	sjmp	C2
row3:	mov	DPTR, #09001H
	movx	A, @DPTR
	acall	_Delay
	jnb	ACC.0,_NUM7
	jnb	ACC.1,_NUM8
	jnb	ACC.2,_NUM9
	jnb	ACC.3,_NUMC
	sjmp	C2
row4:	mov	DPTR, #09001H
	movx	A, @DPTR
	acall	_Delay
	jnb	ACC.0,_NUMstar
	jnb	ACC.1,_NUM0
	jnb	ACC.2,_NUMmattress
	;jnb	ACC.3,_NUMD
	sjmp	C2

_NUM1:
	acall	music
	mov	R1, #1
	acall	_judge	
	mov	A, #'1'
	acall	_lcd_char
_NUM2:
	acall	music
	mov	R1, #2
	acall	_judge
	mov	A, #'2'
	acall	_lcd_char
_NUM3:
	acall	music
	mov	R1, #3
	acall	_judge
	mov	A, #'3'
	acall	_lcd_char
_NUMA:
	acall	music
	mov	A, #'A'
	acall	_lcd_char
_NUM4:
	acall	music
	mov	R1, #4
	acall	_judge
	mov	A, #'4'
	acall	_lcd_char
_NUM5:
	acall	music
	mov	R1, #5
	acall	_judge
	mov	A, #'5'
	acall	_lcd_char
_NUM6:
	acall	music
	mov	R1, #6
	acall	_judge
	mov	A, #'6'
	acall	_lcd_char
_NUMB:
	acall	music
	mov	A, #'B'
	acall	_lcd_char
_NUM7:
	acall	music
	mov	R1, #7
	acall	_judge
	mov	A, #'7'
	acall	_lcd_char
_NUM8:
	acall	music
	mov	R1, #8
	acall	_judge
	mov	A, #'8'
	acall	_lcd_char
_NUM9:
	acall	music
	mov	R1, #9
	acall	_judge
	mov	A, #'9'
	acall	_lcd_char
_NUMC:
	acall	music
	acall	_Delete	
_NUMstar:
	acall	music
	mov	R3, #0
_NUM0:
	acall	music
	mov	R1, #0
	acall	_judge
	mov	A, #'0'
	acall	_lcd_char
_NUMmattress:
	acall	music
	acall	_random
	mov	A, 21H
	cjne	A, 04H, _not_equal
	acall	_clear_lcd
C6:	mov	DPTR, #_string_db16		; BINGO   
	acall	_lcd_string
	acall	_set_cursor
	mov	DPTR, #_string_db17		;You are Right
	acall	_lcd_string
	sjmp	C6
_NUMD:
	acall	music
	mov	A, #'D'
	acall	_lcd_char	
	
_init_lcd:
	mov	DPTR, #08000H
	mov	A, #038H
	movx	@DPTR, A
	acall	_Delay
	
	mov	A, #00EH
	movx	@DPTR, A
	acall	_Delay	
	
	mov	A, #006H
	movx	@DPTR, A
	acall	_Delay
	ret

_clear_lcd:
	mov	DPTR, #08000H
	mov	A, #001H
	movx	@DPTR, A
	acall	_Delay
	
	ret

_not_equal:				;R4-ACC if ACC and R4 were not same
	CPL	A
	INC	A
	ADDC	A, R4
	JC	_Big
	JNC	_Small
	
_Big:					;R4 is bigger one
	DEC	R2			;when you guess the wrong number, your times minus one
	acall	_wrong
	acall	_set_cursor2
	mov	DPTR, #_string_db10	;Number Too Big
	acall	_lcd_string
	acall	_set_cursor
	mov	DPTR, #_string_db12	;You have
	acall	_lcd_string
	mov	A, R2
	acall	_lcd_charforsring	
	mov	DPTR, #_string_db13	;times
	acall	_lcd_string
	
	ljmp	C4

_Small:					;R4 is smaller one
	DEC	R2			;when you guess the wrong number, your times minus one
	acall	_wrong
	acall	_set_cursor2
	mov	DPTR, #_string_db11	;Number Too Small
	acall	_lcd_string
	acall	_set_cursor
	mov	DPTR, #_string_db12
	acall	_lcd_string
	mov	A, R2
	acall	_lcd_charforsring
	mov	DPTR, #_string_db13
	acall	_lcd_string
	ljmp	C4
	
_random:				;produce a random numer
	acall	_Delay
	clr	TR0
	mov	A, TL0
	SUBB	A, #156
	mov	21H, A			;21H save the random
	ret
		
_lcd_string:
	
	MOV R1, #0
	_start:
		mov	A,#0
		acall	_wait_display_ready
					
		mov 	A, R1
		movc	A, @A+DPTR 
		jz	_exit
		acall	_lcd_charforsring
		inc	R1
		sjmp	_start
		_exit:
			ret
			
_lcd_char:
	mov	DPTR, #08001H
	movx	@DPTR, A
	acall	_Delay
	ajmp	C3	
			
_lcd_charforsring:
	push	DPH
	push	DPL
	mov	DPTR, #08001H
	movx	@DPTR, A
	acall	_Delay
	pop	DPL
	pop	DPH
	
	ret
	
_wait_display_ready:
	push	DPH
	push	DPL
	push	ACC
	wait_display_ready_i:
		mov	DPTR, #8002H
		movx	A, @DPTR
		jb	ACC.7, _wait_display_ready
		pop	ACC
		pop	DPL
		pop	DPH
		
		ret

_set_cursor:				;move to second line 
	mov	DPTR, #08000H
	mov	A, #0C0H
	movx	@DPTR, A
	acall	_Delay
	
	ret	
_set_cursor2:				;move to first line 
	mov	DPTR, #08000H
	mov	A, #080H
	movx	@DPTR, A
	acall	_Delay
	
	ret
music:					;play the music when you press the button
	mov	A, R1
	inc	A
	mov	R1, A
	mov	R0, #80
	CPL	P1.2
	acall	tone_delay
	ret

tone_delay:
	NOP
	mov	R7, #3
	djnz	R7,$
	djnz	R0, tone_delay
	cjne	A, #4, music
	ret
	
_judge:					;judge which should be stored
	mov	A, R3
	RL	A
	mov	R3, A
	
	jb	ACC.0, T
	jb	ACC.1, D
	ret

_count:
T:	mov	B, #10
	XCH	A, R1
	mul	AB
	mov	R4, A
	ret	
D:	mov	A, R4 
	ADD	A, R1	
	mov	R4, A
	ret	

_wrong:	
	mov	A, R2
	cjne	A, #30H, _exit3
	acall	_clear_lcd
	mov	DPTR, #_string_db14		;I am Sorry 
	acall	_lcd_string
	acall	_set_cursor
	mov	DPTR, #_string_db15		;You are Wrong
	acall	_lcd_string
	acall	_clear_lcd
	mov	DPTR, #_string_db18		;Answer will be
	acall	_lcd_string
	acall	_set_cursor
	mov	DPTR, #_string_db19		;You are Wrong
	acall	_lcd_string
	acall	_answer
_exit3:	ret

_answer:					;show the random number
	mov	DPTR, #0A003H
	mov	A, #82H
	movx	@DPTR, A
	mov	A, 21H
	mov	DPTR, #0A000H
	movx	@DPTR, A
	
	sjmp	_answer
_Delete:	
	acall	_set_cursor
	mov	DPTR, #_string_db8		;         
	acall	_lcd_string
	ljmp	C7			
_Delay:
	mov	R7, # 8
_Delay_I:
	mov	R6, # 100
_Delay_J:
	mov	R5, # 100
_Delay_K:
	djnz	R5, _Delay_K
	djnz	R6, _Delay_J
	djnz	R7, _Delay_i
	
	ret
_string_db:
	db	"Welcome to play"
	db	0H
_string_db2:
	db	"Guess a number  "
	db	0H
_string_db3:
	db	"from 0 to 99    "
	db	0H
_string_db4:
	db	"Make it bingo as"
	db	0H
_string_db5:
	db	"soon as you can "
	db	0H
_string_db8:
	db	"                "
	db	0H
_string_db9:
	db	"Input :"
	db	0H
_string_db10:
	db	"Number Too Big  "
	db	0H
_string_db11:
	db	"Number Too Small"
	db	0H
_string_db12:
	db	"You have "
	db	0H
_string_db13:
	db	" times"
	db	0H
_string_db14:
	db	"   I am Sorry   "
	db	0H
_string_db15:
	db	" You are Wrong  "
	db	0H
_string_db16:
	db	"     BINGO      "
	db	0H
_string_db17:
	db	" You are Right  "
	db	0H
_string_db18:
	db	"Answer will be  "
	db	0H
_string_db19:
	db	"shown by the LED"
	db	0H
_timer:
	mov	TH0, #255
	mov	TL0, #156
			
	
	reti

end
