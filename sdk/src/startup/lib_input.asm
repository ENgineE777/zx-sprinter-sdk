	export _joystick
	export _keyboard
	export _mouse_apply_clip

;���������� ���� ��������� ����, ���������� ��� ��������� ��������� ��� ����

_mouse_apply_clip
	ret

;������� ������ ���������� � ����������
;���������� Kempston � Cursor+Space

_joystick
;	ld l,0
;
;	ld bc,#fefe		;��� cZXCV
;	in a,(c)
;	rra
;	jr c,.noCaps	;caps �� �����
;
;;cursor ��������
;
;	ld b,#f7		;��� 12345
;	in a,(c)
;	and #10
;	jr nz,$+4
;	set 1,l
;	ld b,#ef		;09876
;	in a,(c)
;	rra
;	jr c,$+4
;	set 4,l
;	rra
;	rra
;	jr c,$+4
;	set 0,l
;	rra
;	jr c,$+4
;	set 3,l
;	rra
;	jr c,$+4
;	set 2,l
;.noCaps
;	ld b,#7f		;��� SpSymBNM
;	in a,(c)
;	rra
;	jr c,$+4
;	set 4,l
;	ld b,#bf 		;��� eLKJH
;	in a,(c)
;	rra
;	jr c,$+4
;	set 5,l	
;
;	ld a,l
;	or a
;	ret nz
		ld a,(key_stat)
		ld l,a
		ret
;kempston ��������
;	xor a
;	out ($bf),a
;	in a,(31)
;	and #1f
;	ld l,a
;	ld a,1
;	out ($bf),a
	ret
	
;����� ����������, ��������� 40-������� ������ ������� ��������� ������

keyboard_row
	in a,(c)
	cpl
	ld e,a
	ld b,5
.l0
	rr e
	sbc a,a
	ld c,a
	xor (ix)
	and c
	and 2
	ld (ix),c
	rr c
	jr nc,$+4
	or 1
	ld (hl),a
	inc ix
	inc hl
	djnz .l0
	ret
	
	
	
_keyboard
	push ix
	ex de,hl
	ld ix,keysPrevState
	ld bc,#fefe		;cZXCV
	call keyboard_row
	ld bc,#fdfe		;ASDFG
	call keyboard_row
	ld bc,#fbfe		;QWERT
	call keyboard_row
	ld bc,#f7fe		;12345
	call keyboard_row
	ld bc,#effe		;09876
	call keyboard_row
	ld bc,#dffe		;POIUY
	call keyboard_row
	ld bc,#bffe		;eLKJH
	call keyboard_row
	ld bc,#7ffe		;_sMNB
	call keyboard_row
	pop ix
	ret


PS2Scan:
.loop		in a,(SIO_CONTROL_A)
		bit 0,a
		jr z,.endhandler
		call KeyHandler
		jr .loop
.endhandler:	ret

KeyHandler:	ld hl,keys_flag
		in a,(SIO_DATA_REG_A)
		ld d,a
		cp $E0
		jr nz,.kh1
		set 7,(hl) ; // ������� �������
		ret
.kh1		cp $F0
		jr nz,.kh2
		set 6,(hl) ; // ���������� �������
		ret
.kh2		bit 7,a ; ����������?
		jr z,.kh3
		ld (hl),0
		ret
.kh3		ld a,(hl)
		and $80
		or d
		ld d,a
		bit 6,(hl)
		jr nz,.keyrelease
.keypress	ld h,high keymap
		ld l,d
		ld e,(hl)
		ld a,(key_stat)
		or e
		ld (key_stat),a
		ld a,d
		ld (key_scancode),a
		xor a
		ld (keys_flag),a
		ret
.keyrelease	ld h,high keymap
		ld l,d
		ld a,(hl)
		xor $FF
		ld e,a
		ld a,(key_stat)
		and e
		ld (key_stat),a
		xor a
		ld (keys_flag),a
		ret	