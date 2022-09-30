		device pentagon1024
		define ZXMAK
;MEM_SLOT0=#37f7
;MEM_SLOT1=#77f7
;MEM_SLOT2=#b7f7
;MEM_SLOT3=#f7f7

;SPBUF_PAGE0=8
;SPBUF_PAGE1=9
;SPBUF_PAGE2=10
;SPBUF_PAGE3=11

;SPTBL_PAGE=6

;CC_PAGE0=12
;CC_PAGE1=13
;CC_PAGE2=14
;SND_PAGE=0
;FM_PAGE=31
;PAL_PAGE=4
;GFX_PAGE=32 ;16

AFX_INIT  = $4000
AFX_PLAY  = $4003
AFX_FRAME = $4006
PT3_INIT  = $4009
PT3_FRAME = $400c

IMG_LIST  = $1000

;смещения в SND_PAGE

;MUS_COUNT=#49fe
;SMP_COUNT=#49ff
SFX_COUNT = $5800

;MUS_LIST =#4a00
;SMP_LIST =#4d00
SFX_DATA  = $5800

VPAGE_TILES   = $50
VPAGE_SPRITES = $5C

SIO_CONTROL_A   EQU     #19
SIO_DATA_REG_A  EQU     #18	
CTC_CH0     	equ $10
CTC_CH1     	equ $11
CTC_CH2     	equ $12
CTC_CH3     	equ $13

		include "sprint00.asm"

		macro MDebug color

		push af
		ld a,color
		ld (mdebugcolor),a
		out ($FE),a
		pop af

		endm


		macro MRestoreMemMap012

		ld a,(memCCPage0) : out (PAGE0),a
		ld a,(memCCPage1) : ld (_memSlot1),a : out (PAGE1),a
		ld a,(memCCPage2) : ld (_memSlot2),a : out (PAGE2),a
	
		endm


		macro MRestoreMemMap12

		ld a,(memCCPage1) : ld (_memSlot1),a : out (PAGE1),a
		ld a,(memCCPage2) : ld (_memSlot2),a : out (PAGE2),a

		endm



		org $E000

begin:		di
		ld (exit_sp),sp
		ld sp,begin-1
		ld (exit_addr),hl
		xor  a
.tfd4		ld   (_tfmflag),a

		;инициализация звуковых эффектов, если они есть
		ld a,(memSNDPage) : call setSlot1
		ld a,(SFX_COUNT)
		or a
		jr z,.noSfx
		ld hl,SFX_DATA
		call AFX_INIT
.noSfx		xor a
		call reset_ay

		;установка обработчика прерываний

		ld a,im2vector/256
		ld i,a
		im 2
		
		ifndef ZXMAK
                ;ld de,Im2Empty ;Im2Handler
                ;call set_im2
;                ld hl,im2handler
;                ;ld ($8000),hl
;                ;ld ($8002),hl
;                ;ld ($8004),hl
;                ld ($FE06),hl
;               
		ld hl,im2empty : ld ($FDFE),hl
		ld hl,im2VShandler : ld ($FE06),hl

.sync:		ei : halt : di
		in a,(SIO_CONTROL_A)
		bit 0,a                   ; 0-bit, байт пришел ?
		jr z,.endsync             ; да, это прерывание от клавиатуры
.keys:		call PS2Scan
		jr .sync
.endsync:
;;
		ld b,5
		djnz $
;
		ld a,0x57 : out (CTC_CH2),a
		ld a,112  : out (CTC_CH2),a
		ld a,0xd7 : out (CTC_CH3),a
		ld a,160  : out (CTC_CH3),a
		ld a,0    : out (CTC_CH0),a

		ld hl,im2Keyhandler : ld ($FDFE),hl
		endif

		ei
		ld a,1
		ld (_palChange),a
		call _swap_screen

		;установка карты памяти для выполнения кода
		;страница в верхнем окне не меняется, всегда 11

		ld a,(memCCPage0) : call setSlot0
		ld a,(memCCPage1) : call setSlot1
		ld a,(memCCPage2) : call setSlot2

		jp 0

_quit:
		di
		xor a
		call reset_ay		
		im 1
		ld a,(memory_pages+255) : out (PAGE2),a
		ld a,(memory_pages+254) : out (PAGE0),a
		ld sp,(exit_sp)
		ld hl,(exit_addr)
		jp (hl)

;более быстрая версия ldir, эффективна при bc>12
;из статьи на MSX Assembly Page
;в отличие от нормального ldir портит A и флаги

_fast_ldir
		xor a
		sub c
		and 63
		add a,a
		ld (.jump),a
.jump=$+1
		jr nz,.loop
.loop		dup 64 : ldi : edup
		jp pe,.loop
		ret


;!!!!!!!!!!!!!!!!!!!!!
_clear_screen:
		push af
		ld a,VPAGE_TILES : out (PAGE1),a

		ld hl,$4160
		ld a,(_screenActive)
		and 1
		jr nz,.m1
		ld hl,$4020
.m1		ld a,32 
		out (PORT_Y),a
		di
		ld d,d
		ld a,0
		ld b,b
		pop af
		ld b,192
.lp1		di
		ld c,c
		ld (hl),a
		ld b,b
		ei
		exa : in a,(PORT_Y) : inc a : out (PORT_Y),a : exa
		djnz .lp1
		ld a,$C0 : out (PORT_Y),a
		MRestoreMemMap12
		ret

_swap_screen:	push ix
		push iy

		ld a,(spritesActive)
		or a
		push af
		jr z,.noSpr0
		MDebug 2
		ld a,VPAGE_SPRITES    : out (PAGE1),a
		ld a,(memSpritesPage) : out (PAGE2),a
		call prspr
;		call vclip_clear
		ld a,VPAGE_TILES : out (PAGE1),a
		ld hl,_vclip
		call vclipspr ;respr_ext
.noSpr0
;		ld a,5
;		out (#fe),a
		MDebug 3
		call update_pal

		call waitVsync ;halt
;		xor a
;		out (#fe),a

		ld a,(_screenActive)
		out (RGMOD),a
		xor 1
		ld (_screenActive),a

		pop af
		jr z,.noSpr1
		ld a,255     : ld (_vclip),a
		ld hl,_vclip : ld (_vclipptr),hl
		xor a :	ld (_sptr),a
		MDebug 6
		call respr
		ld hl,_sprqueue
		ld a,(_screenActive)
		and 1
		jr nz,.m4
		inc h
.m4		ld (hl),$FF
		call updateTilesToShadow
.noSpr1		MRestoreMemMap012
		MDebug 1
		ld a,$C0 : out (PORT_Y),a
		pop iy
		pop ix
		ret

_vsync:		MDebug 3
		call update_pal
		call waitVsync
		ld hl,$43E0
		ld de,$43E4
		ld a,(_screenActive)
		and 1
		jr z,.m3
		exd
.m3		di
		ld bc,PORT_Y
		ld d,d
		ifdef ZXMAK
			ld a,0
			ld a,a
			dup 3
			out (c),b : ld a,(hl)
			//out (c),b 
			ld (de),a
			inc l
			inc e
			edup
		else
			ld a,64
			ld a,a
			dup 3
			out (c),b : ld a,(hl)
			out (c),b : ld (de),a
			inc l
			inc e
			edup
		endif
		org $-2
		ld b,b
		ei
		xor a : ld (_palChange2),a
		MRestoreMemMap012
		MDebug 1
		ld a,$C0 : out (PORT_Y),a
		ret

update_pal:	ld a,(_palChange)
		and a
		jr z,.nosetpal
		ld a,VPAGE_TILES : out (PAGE1),a
		ld a,(memPALPage) : out (PAGE0),a

		xor a : out (PORT_Y),a
		ld hl,_palette
		ld de,_palBright0
		exx
		ld de,$43E0
		ld a,(_screenActive)
		and 1
		jr z,.m1
		ld de,$43E4
.m1		ld b,e
		ld c,$FF
		exx

		ld b,4
.palloop1	push bc
		ld a,(de) : inc de : exx : ld h,a : exx
		ld b,16
.palloop2	ld a,(hl) : inc l : exx : ld l,a : ld a,(hl) : ld (de),a : inc e : exx
		ld a,(hl) : inc l : exx : ld l,a : ld a,(hl) : ld (de),a : inc e : exx
		ld a,(hl) : inc l : exx : ld l,a : ld a,(hl) : ld (de),a : ld e,b : exx
		in a,(PORT_Y) : inc a : out (PORT_Y),a
		djnz .palloop2
		pop bc
		djnz .palloop1

		xor a : ld (_palChange),a
		dec a : ld (_palChange2),a
		jr .endpal

.nosetpal	ld a,(_palChange2)
		and a
		jr z,.endpal
		ld a,VPAGE_TILES : out (PAGE1),a
		ld hl,$43E0
		ld de,$43E4
		ld a,(_screenActive)
		and 1
		jr nz,.m3
		exd
.m3		di
		ld bc,PORT_Y
		ld d,d
		ifdef ZXMAK
			ld a,0
			ld a,a
			dup 3
			out (c),b : ld a,(hl)
			//out (c),b 
			ld (de),a
			inc l
			inc e
			edup
		else
			ld a,64
			ld a,a
			dup 3
			out (c),b : ld a,(hl)
			out (c),b : ld (de),a
			inc l
			inc e
			edup
		endif
		org $-2
		ld b,b
		ei
		xor a : ld (_palChange2),a
.endpal		ret


pal_get_address:
		ld h,0
		ld l,a
		add hl,hl
		add hl,hl
		add hl,hl
		add hl,hl
		add hl,hl
		add hl,hl
		ld d,h : ld e,l
		add hl,hl
		add hl,de

		ld a,(memPALPage) : out (PAGE0),a
		ret



_pal_select:	call pal_get_address
		ld de,_palette
		ld bc,192
		ldir

		ld a,d
		ld (_palChange),a

		ld a,(memCCPage0) : out (PAGE0),a
		ret



_pal_bright:
		cp 31
		jr c,.l1
		ld a,30
.l1		or $20
		ld (_palBright0),a
		ld (_palBright1),a
		ld (_palBright2),a
		ld (_palBright3),a
		ld (_palChange),a
		ret

_pal_bright16:	; c - palseg, a - bright
		ld hl,_palBright0
		ld b,0
		add hl,bc
		cp 31
		jr c,.l1
		ld a,30
.l1		or $20
		ld (hl),a
		ld (_palChange),a
		ret

;_pal_copy
;	push de
;	call pal_get_address
;
;	ld de,palTemp
;	ld bc,16
;	ldir
;
;	ld bc,MEM_SLOT0
;	ld a,~CC_PAGE0
;	out (c),a
;
;	pop de
;	ld hl,palTemp
;	ld bc,16
;	ldir
;
;	ret

		include "lib_input.asm"
		include "lib_sound.asm"
		include "lib_tiles.asm"
		include "lib_sprites.asm"

im2empty:	ei
		reti

im2Keyhandler:	push af : push bc : push de : push hl
		ld a,5 : out ($FE),a
		call PS2Scan
		ld a,(mdebugcolor) : out ($FE),a
		pop hl : pop de : pop bc : pop af
		ei
		ret

im2VShandler:
		push af : push bc : push de : push hl : push ix : push iy
		exa : exx
		push af : push bc : push de : push hl
		ld a,4 : out ($FE),a
		;in a,(SIO_CONTROL_A)
		;bit 0,a                 ; 0-bit, байт пришел ?
		;jp nz,im2keys           ; да, это прерывание от клавиатуры

		in a,(PORT_Y) : push af
		ld a,$C0 : out (PORT_Y),a
		ld a,(SNDFLAG)
		bit 7,a
		jr nz,.nosnd
		bit 3,a
		jr nz,.fmout
		bit 2,a
		jr z,.nots
		ld bc,#fffd		;второй чип Turbo Sound
		ld a,#fe		
		out (c),a		
		ld hl,AYREGS
		call ROUT
		ld bc,#fffd		;первый чип
		out (c),b
.i1		ld hl,AYREGS2
.i2		call ROUT
		jr .esnd
.nots		ld hl,AYREGS
		and 3
		jr z,.i2
;	ld hl,AYREGS2
		jr .i1
.fmout	;call turbo_off
	;ld a,#f9
	;ld bc,#fffd		;первый чип
	;out (c),a
	;ld hl,AYREGS2
	;call ROUTFM
	;call turbo_on
.esnd		ld a,0
		ld (AYREGS+9),a
		ld hl,0
		ld (AYREGS+2),hl
.nosnd	
		;ld a,(_palChange2)
		;or a
		;jp z,.noPalette

	;изменение палитры

;	ld de,(_palBright)
;	ld a,d
;	add a,high palBrightTable
;	ld b,a
;
;	ld hl,_palette
;
;.colId=0
;	dup 8
;	ld a,.colId
;	out (#fe),a
;	ld a,(hl)
;	add a,e
;	ld c,a
;	ld a,(bc)
;	out (#ff),a
;	inc l
;.colId=.colId+1
;	edup
;.colId=0
;	dup 8
;	ld a,.colId
;	out (#f6),a
;	ld a,(hl)
;	add a,e
;	ld c,a
;	ld a,(bc)
;	out (#ff),a
;	inc l
;.colId=.colId+1
;	edup
;
;	;восстановление цвета бордюра
;
;	ld a,(_borderCol)
;	ld c,a
;	and 7
;	bit 3,c
;	jr nz,.bright
;	out (#fe),a
;	jr .palSet
;.bright
;	out (#f6),a
;.palSet
;		in a,(PAGE1) : push af
;		ld hl,_palette
;		ld de,$43E0
;		xor a : out (PORT_Y),a
;		ld a,64
;.plp1		exa
;		ldi : ldi : ldi
;		ld e,$E0
;		in a,(PORT_Y) : inc a : out (PORT_Y),a
;		exa
;		dec a
;		jr nz,.plp1
;		pop af : out (PAGE1),a
;		xor a
;		ld (_palChange2),a
.noPalette

		in a,(PAGE1) : ld (_memSlot1),a
		in a,(PAGE2) : ld (_memSlot2),a
		ld a,(memSNDPage) : out (PAGE1),a
	;ld bc,MEM_SLOT1
	;out (c),a

	;ld a,~FM_PAGE
	;ld bc,MEM_SLOT2
	;out (c),a

;	ld a,(musicPage)
;	or a
;	jr z,.noMusic
;	ld bc,MEM_SLOT2
;	out (c),a
;	ld bc,#fffd		;второй чип Turbo Sound
;	ld a,#fe		;если Turbo Sound нет, звуки и музыка
;	out (c),a		;играют на одном чипе, иначе на разных
;	call PT3_FRAME
;	ld a,(turboSound)
;	or a
;	jr z,.sfx
;.noMusic
;	ld a,1
;	call reset_ay
;.sfx
;	ld bc,#fffd		;первый чип
;	out (c),b
;	call AFX_FRAME

;	poll_mouse

		ld a,(SNDFLAG)
		bit 7,a
		jr nz,.nosnd2
		bit 4,a
		jr nz,.fmp1
		call #400c
		ld hl,AYREGS3
		ld de,AYREGS
		ld bc,14
		ldir
		jr .nfm
.fmp1		;call turbo_off
		;call #6006	
		;call turbo_on
.nfm		call #4006
.nosnd2
		ld a,(_memSlot1) : out (PAGE1),a
	;ld bc,MEM_SLOT1
	;out (c),a
	;ld a,(_memSlot2)
	;ld bc,MEM_SLOT2
	;out (c),a

	;счётчик кадров

		ld hl,_time
		ld b,4
.time1		inc (hl)
		jr nz,.time2
		inc hl
		djnz .time1
.time2
		pop af
		out (PORT_Y),A

		ld a,$FF : ld (vsync_flag),a
		;in a,(SIO_CONTROL_A)
		;bit 0,a                 ; 0-bit, байт пришел ?
		;jp nz,im2keys           ; да, это прерывание от клавиатуры
		call PS2Scan
		ld a,(mdebugcolor) : out ($FE),a
		pop hl : pop de : pop bc : pop af
		exx : exa
		pop iy : pop ix : pop hl : pop de : pop bc : pop af
		ei
		reti

vsync_flag:	db 0

waitVsync:	xor a : ld (vsync_flag),a
		MDebug 0
.loop		ei : halt
		ld a,(vsync_flag)
		and a
		jr z,.loop
		ret

;im2keys		call KeysHandler
;		pop hl : pop de : pop bc : pop af
;		exx : exa
;		pop iy : pop ix : pop hl : pop de : pop bc : pop af
;		ei
;		reti
;
;KeysHandler:
;.loop:          in a,(SIO_CONTROL_A)
;                bit 0,a
;                ret z
;                in a,(SIO_DATA_REG_A)
;                cp $F0
;                jr nz,.key
;                ld a,1
;                ld (.needskipkey),a
;                jr .loop
;.key:           cp $E0
;                jr z,.skipkey
;                ld c,0
;.needskipkey:   equ $-1
;                bit 0,c
;                jr nz,.skipkey
;                ld (KeyPressed),a
;.skipkey:       xor a
;                ld (.needskipkey),a
;                jr .loop 
;
;KeyPressed:	db 0

ROUT	
ROUT_HL xor a
ROUT_A0	ld de,#FFBF
	ld bc,#FFFD
LOUT	out (c),a
	ld b,e
	outi 
	ld b,d
	inc a
	cp 13
	jr nz,LOUT
	out (c),a
	ld a,(hl)
	and a
	ret z
	ld b,e
	out (c),a
	xor a
	ld (hl),a
	ret

ROUTFM	
	xor a
	ld de,#FFBF
	ld bc,#FFFD
.l1	inf
	jp m,.l1
	out (c),a
.l2	inf
	jp m,.l3	
	ld b,e
	outi 
	ld b,d
	inc a
	cp 13
	jr nz,.l1
.l3	inf
	jp m,.l3
	out (c),a
.l4	inf
	jp m,.l4
	ld a,(hl)
	and a
	ret z
	ld b,e
	out (c),a
	xor a
	ld (hl),a
	ret


setSlot0:	ld (_memSlot0),a 
		out (PAGE0),a
		ret

setSlot1:	ld (_memSlot1),a
		out (PAGE1),a
		ret

setSlot2:	ld (_memSlot2),a
		out (PAGE2),a
		ret

clearPage:	call setSlot1
		ld hl,#4000
		ld de,#4001
		ld bc,#3fff
		ld (hl),l
		jp _fast_ldir


		align 256	;#nn00
tileUpdateXTable
		dup 8
		db #01,#02,#04,#08,#10,#20,#40,#80
		edup
.x=0
		dup 64
		db .x>>3
.x=.x+1
		edup

		align 256
keymap:		ds 256,0
		org keymap + $6B + $80
		db 2
		org keymap + $74 + $80
		db 1
		org keymap + $75 + $80
		db 8
		org keymap + $72 + $80
		db 4
		org keymap + $29
		db $10
		org keymap + $5A
		db $20
		org keymap + $76
		db $80 ; esc
		org keymap + 256

		align 256
_sprqueue	;формат 4 байта на спрайт, idh,idl,y,x (idh=255 конец списка)
_sprqueue0	ds 256,255
_sprqueue1	ds 256,255
_palette	ds 192,0
_vclip		ds 64,255	
		display "Top ",/h,$," (should be <=0xFC00)"

		org $FC00
memory_pages:  ; таблица выделенных страниц памяти
memCCPage0:	db 0 ;
memCCPage1:	db 0 ;
memCCPage2:	db 0 ;
memCCPage3:	db 0 ; код
memSNDPage:	db 0 ; музыка и sfx
memPALPage:	db 0 ; палитры
memTilesPage:	db 0 ; графика тайлов
memSpritesPage:	db 0 ; графика спрайтоа
memImgPage:	ds 256-8,0 ; картинки
		
		org $FD00
tileUpdateMap	;битовая карта обновившихся знакомест, 64x25 бит
		ds 8*25,0
AYREGS		ds 14
AYREGS2		ds 14
SNDFLAG		db 0
AYREGS3		ds 14	
_tfmflag	db 0
		
		org $FDFD
		jp im2VShandler; im2empty

		org $FE00
im2vector	ds 257,$FD

;переменные

musicPage	db 0
tileOffset	dw 0
spritesActive	db 0	;1 если вывод спрайтов разрешён
tileUpdate	db 0	;1 если выводились тайлы, для системы обновления фона под спрайтами
palTemp		ds 16,0
keysPrevState	ds 40,0
turboSound	db 0	;1 если есть TS

;экспортируемые переменные

	macro rgb222 b2,g2,r2
	db (((r2&3)<<4)|((g2&3)<<2)|(b2&3))
	endm

_memSlot0	db 0
_memSlot1	db 0
_memSlot2	db 0
_borderCol	db 0
;_palBright	dw 3<<6
_palBright0	db $20
_palBright1	db $20
_palBright2	db $20
_palBright3	db $20
_palChange	db 1
_palChange2	db 1	
_screenActive	db 0
_time		dd 0
_vclipptr	dw _vclip
_clip           db 0
_sptr		db 0
_sndflag	equ SNDFLAG
keys_flag:	db 0
key_stat:	db 0
key_scancode:	db 0
exit_sp:	dw 0
exit_addr:	dw 0
mdebugcolor:	db 0

	export _palette
	export _memSlot0
	export _memSlot1
	export _memSlot2
	export _borderCol
;	export _palBright
	export _palChange
	export _sprqueue
	export _screenActive
	export _time
	export _vclip
	export _vclipptr
	export _clip	
	export _sptr
	export _sndflag
	export _tfmflag

;экспортируемые функции

	export _pal_select
;	export _pal_copy
	export _pal_bright
	export _pal_bright16
	export _swap_screen
	export _vsync
	export _clear_screen
	export _fast_ldir
	export _quit
end
	display "tfmflag",_tfmflag
	display "AYREGS",AYREGS
	display "AYREGS2",AYREGS2
	display "SNDFLAG",SNDFLAG
	display "AYREGS3",AYREGS3

	display "Size ",/d,end-begin," bytes"

	savebin "startup.bin",begin,end-begin