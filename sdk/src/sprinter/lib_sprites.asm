				
		export _sprites_start
		export _sprites_stop

;копирование видимого экрана в теневой

copy_visible_to_shadow:
		ld a,VPAGE_TILES
		out (PAGE1),A
		ld a,(_screenActive)
		ld hl,$4020
		ld de,$4160
		and 1
		jr nz,.m1
		ex de,hl
.m1		ld a,32
		out (PORT_Y),a

		di       ; длина блока 256 байт
		ld d,d
		ld a,0   
		ld b,b
		ei

		ld b,192 ; 192 строк

.lp1		di       ; копирование строки акселератором
		ld l,l
		ld a,(hl)
		ld (de),a
		ld b,b
		ei

		in a,(PORT_Y) : inc a : out (PORT_Y),a
		djnz .lp1
		ld a,$C0 : out (PORT_Y),a 

		ret

;запуск спрайтов
;очищает список спрайтов
;копирует видимый экран в теневой
;разрешает вывод спрайтов
_sprites_start:
		xor a
		ld (spritesActive),a

		ld hl,_sprqueue
		ld de,_sprqueue + 1
		ld bc,511
		ld (hl),255
		ldir

		call copy_visible_to_shadow

		MRestoreMemMap12

		ld a,1
		ld (spritesActive),a

		ret

;остановка спрайтов

_sprites_stop:
		xor a
		ld (spritesActive),a
		ret

vclipspr:	ld de,_vclip
		ld a,(_screenActive)
		and 1
		ld hl,$4160
		jr nz,.m1
		ld hl,$4020
		;inc d
.m1		ld (.vcliplineoffs),hl
		exd
		jr .vclip0go

.vclip0		inc l
		ret z ;end of queue
.vclip0go
		ld d,(hl) ;high id
		inc d
		ret z ;end of queue
		inc l
		inc l

		ld a,(hl)
		add a,32
		ld b,a
		inc l
		ld e,(hl)
		push hl
		ld d,0
.vcliplineoffs	equ $+1 : ld hl,$4020
		add hl,de
		ld c,PORT_Y
		di
		ld d,d   ; set accel block size
		ld a,16
		ld l,l
		rept 16
		out (c),b
		ld a,(hl)
		ld (hl),a
		;inc h
		inc b
		endr
		org $-1
		ld b,b
		ei
		pop hl
		jp .vclip0


respr:		ld hl,_sprqueue
.respr_ext	ld a,(_screenActive)
		and 1
		ld a,$EB
		jr nz,.m1
		ld a,0
		inc h
.m1		ld (.respr_swp),a
		jr .respr0go

.respr0		inc l
		ret z ;end of queue
.respr0go
		ld d,(hl) ;high id
		inc d
		ret z ;end of queue
		inc l
		inc l

		ld a,(hl)
		add a,32
		ld b,a
		inc l
		ld e,(hl)
		push hl
		ld d,0
		ld hl,$4020
		add hl,de
		ex de,hl
		ld hl,$140
		add hl,de   ; hl 1 de 0
.respr_swp	nop ; ex de,hl
		ld c,PORT_Y
		di
		ld d,d   
		ld a,16
		ld l,l
		rept 16
		out (c),b
		ld a,(hl)
		ld (de),a
		;inc h
		inc b
		endr
		org $-1
		ld b,b
		ei
		pop hl
		jp .respr0


prspr:		ld de,_sprqueue
		ld hl,$4160
		ld a,(_screenActive)
		and 1
		jr nz,.m1
		ld hl,$4020
		inc d
.m1		ld (.prsprlineoffs),hl
		jr .prspr0g0
.prspr0:	inc e
		ret z
.prspr0g0:	exd
		ld d,(hl)
		inc d
		ret z
		inc l
		ld a,(hl)
		inc l
		ld d,(hl) ; y
		inc l
		ld e,(hl) ; x
		push hl
		ld h,a
          	rlca : rlca : rlca : rlca
          	and $F0
          	ld l,a
          	ld a,h : and $30 : or $80 : ld h,a ; hl - sprite address

          	ld a,d
          	add a,32
          	ld b,a

          	ex de,hl
          	push de
.prsprlineoffs: equ $+1 : ld de,$4020
          	ld h,0
          	add hl,de
          	pop de
          	ex de,hl

		;draw loop 
		; hl - sprite data ($8000..$BFFF)
		; de - screen address ($4000..$7FFF)
		; b  - screen line

		ld c,PORT_Y
		di
		ld d,d   ; размер блока
		ld a,16
		ld l,l   ; копирование
		rept 16
		out (c),b
		ld a,(hl)
		ld (de),a
		inc h
		inc b
		endr
		org $-2
		ld b,b
		ei
		pop de
		jp .prspr0
