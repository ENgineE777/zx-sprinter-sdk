	export _draw_tile
	export _draw_image
;	export _select_image
;	export _draw_tile_key
;	export _color_key



/*	macro MDrawTile

	ld bc,-16384+40
	dup 8
	ld a,(de)	;#4xxx
	ld (hl),a
	inc e
	set 5,h
	ld a,(de)	;#6xxx
	ld (hl),a
	inc e
	set 7,h
	res 6,h
	ld a,(de)	;#axxx
	ld (hl),a
	inc e
	res 5,h
	ld a,(de)	;#8xxx
	ld (hl),a
	inc e
	add hl,bc
	edup
	org $-2

	endm

*/
/*
	macro MDrawTileGetAddrs

	ld hl,(tileOffset)
	add hl,de
	ex de,hl
	
	ld h,high scrTable
	ld l,b
	ld a,c
	add a,(hl)
	set 5,l
	ld h,(hl)
	ld l,a

	ld a,d
	srl a
	add a,GFX_PAGE
	ld bc,MEM_SLOT0
	cpl
	out (c),a

	ld a,e
	rrca
	rrca
	rrca
	ld e,a
	and 31
	bit 0,d
	jr z,$+4
	or #20
	ld d,a
	ld a,e
	and #e0
	ld e,a

	endm

*/

/*
	macro MCopyTileColumnFromBuf
	ld bc,40
	dup 8
	ld a,(de)
	ld (hl),a
	inc e
	add hl,bc
	edup
	endm
*/

/*
	macro MCopyTileColumnToBuf
	ld bc,40
	dup 8
	ld a,(hl)
	ld (de),a
	inc e
	add hl,bc
	edup
	endm

*/

;копирование тайла из теневого экрана в буфер спрайтов
;d=x,e=y
/*
updateOneTileToBuffer
	exa
	push de

	ld a,d				;получить из de адрес в экране
	ld h,high scrTable
	ld l,e
	add a,(hl)
	set 5,l
	ld h,(hl)
	ld l,a

	sla e
	sla e
	sla e

	ld bc,MEM_SLOT0
	ld a,~SPBUF_PAGE0
	out (c),a

	MCopyTileColumnToBuf	;столбец 0
	org $-2
	ld a,e
	sub 7
	ld e,a
	ld bc,-7*40+16384
	add hl,bc

	ld bc,MEM_SLOT0
	ld a,~SPBUF_PAGE1
	out (c),a

	MCopyTileColumnToBuf	;столбец 1
	org $-2
	ld a,e
	sub 7
	ld e,a
	ld bc,-(7*40+8192)
	add hl,bc

	ld bc,MEM_SLOT0
	ld a,~SPBUF_PAGE2
	out (c),a

	MCopyTileColumnToBuf	;столбец 2
	org $-2
	ld a,e
	sub 7
	ld e,a
	ld bc,-7*40+16384
	add hl,bc

	ld bc,MEM_SLOT0
	ld a,~SPBUF_PAGE3
	out (c),a

	MCopyTileColumnToBuf	;столбец 3
	org $-2

	pop de
	exa
	ret
*/

;копирование тайла из активного экрана на теневой экран
;d=x,e=y
updateOneTileToShadow:
		exa
		push de

		ld a,d : add a,a : add a,a : add a,a : ld c,a : ld b,0
		ld a,e
		ld hl,$4020 : add hl,bc
		exd
		ld hl,$4160 : add hl,bc
		add a,a : add a,a : add a,a : add a,32
		ld b,a
		ld a,(_screenActive)
		and 1
		jr z,.m1
		exd
.m1		
		ld c,PORT_Y
		di
		ld d,d   ; set accel block size
		ld a,8
		ld l,l
		rept 8
		out (c),b
		ld a,(hl)
		ld (de),a
		inc b
		endr
		org $-1
		ld b,b
		ei		

		pop de
		exa
		ret


;копирование тайла из буфера спрайта на теневой экран
;d=x,e=y
/*
updateOneTileFromBuffer
	exa
	push de

	ld a,d				;получить из de адрес в экране
	ld h,high scrTable
	ld l,e
	add a,(hl)
	set 5,l
	ld h,(hl)
	ld l,a

	sla e
	sla e
	sla e

	ld bc,MEM_SLOT0
	ld a,~SPBUF_PAGE0
	out (c),a

	MCopyTileColumnFromBuf	;столбец 0
	org $-2
	ld a,e
	sub 7
	ld e,a
	ld bc,-7*40+16384
	add hl,bc

	ld bc,MEM_SLOT0
	ld a,~SPBUF_PAGE1
	out (c),a

	MCopyTileColumnFromBuf	;столбец 1
	org $-2
	ld a,e
	sub 7
	ld e,a
	ld bc,-(7*40+8192)
	add hl,bc

	ld bc,MEM_SLOT0
	ld a,~SPBUF_PAGE2
	out (c),a

	MCopyTileColumnFromBuf	;столбец 2
	org $-2
	ld a,e
	sub 7
	ld e,a
	ld bc,-7*40+16384
	add hl,bc

	ld bc,MEM_SLOT0
	ld a,~SPBUF_PAGE3
	out (c),a

	MCopyTileColumnFromBuf	;столбец 3
	org $-2

	pop de
	exa
	ret

*/

/*
updateTilesToBuffer
	ld a,(tileUpdate)
	or a
	ret z

	ld hl,tileUpdateMap
	ld e,0	;y
.clearUpdMap0
	ld d,0	;x
.clearUpdMap1
	ld a,(hl)
	or a
	jp nz,.rowChange
	ld a,d
	add a,8
	ld d,a
	jp .noRowChange
.rowChange
	push hl
	dup 8
	rra
	call c,updateOneTileToBuffer
	inc d
	edup
	pop hl
	ld a,d
.noRowChange
	inc l
	cp 40
	jp nz,.clearUpdMap1
	inc l
	inc l
	inc l
	inc e
	ld a,e
	cp 25
	jp nz,.clearUpdMap0

	ret
*/


;updateTilesFromBuffer
updateTilesToShadow:
		ld a,(tileUpdate)
		or a
		ret z
		xor a
		ld (tileUpdate),a

		ld hl,tileUpdateMap
		ld e,0	;y
.clearUpdMap0:	ld d,0	;x
.clearUpdMap1:	ld a,(hl)
		or a
		jp nz,.rowChange
		ld a,d : add a,8 : ld d,a
		jp .noRowChange
.rowChange:	push hl
		dup 8
		rra
		call c,updateOneTileToShadow
		inc d
		edup
		pop hl
		ld (hl),0
		ld a,d
.noRowChange	inc l
		cp 32
		jp nz,.clearUpdMap1
		inc l
		inc l
		inc l
		inc l
		inc e
		ld a,e
		cp 24
		jp nz,.clearUpdMap0
		ret

;выбор изображения для отрисовки тайлов
/*
_select_image
	ld h,0
	add hl,hl
	add hl,hl
	ld bc,IMG_LIST
	add hl,bc

	ld bc,MEM_SLOT0
	ld a,~PAL_PAGE
	out (c),a

	ld e,(hl)	;tile
	inc l
	ld d,(hl)
	ld (tileOffset),de

	ld a,~CC_PAGE0
	out (c),a

	ret

*/

;установка флага обновления тайла
;c=X, b=y, не меняет bc и de

setTileUpdateMapF:
		ld (tileUpdate),a	;A всегда не 0 на входе
setTileUpdateMap:
		ld h,high tileUpdateXTable
		ld l,c
		ld a,(hl)
		set 6,l
		exa
		ld a,b
		add a,a
		add a,a
		add a,a
		add a,(hl)
		ld l,a
		ld h,high tileUpdateMap
		exa
		or (hl)
		ld (hl),a
		ret



;c=X, b=Y, de=tile
;координаты в тайлах

_draw_tile:
		ld a,(spritesActive)
		or a
		call nz,setTileUpdateMapF
		ld a,VPAGE_TILES    : out (PAGE1),a
		ld a,(memTilesPage) : out (PAGE2),a
		ld hl,$4160
		ld a,(_screenActive)
		and 1
		jr nz,.m1
		ld hl,$4020
.m1		ld a,b
		add a,a : add a,a : add a,a : add a,32
		ld b,a
		ld a,c
		add a,a : add a,a : add a,a
		add a,l
		ld l,a
		jr nc,.m2
		inc h
.m2		
		; yyyxxxxx ->    10yyy000 xxxxx000
		ld a,e
		ld d,e
		add a,a : add a,a : add a,a
		ld e,a
		ld a,d
		rrca : rrca
		and $38 : or $80
		ld d,a
		exd
		;draw loop 
		; hl - tile data ($8000..$BFFF)
		; de - screen address ($4000..$FFFF)
		; b  - screen line

		ld c,PORT_Y
		di
		ld d,d   ; set accel block size
		ld a,8
		ld l,l
		rept 8
		out (c),b
		ld a,(hl)
		ld (de),a
		inc h
		inc b
		endr
		org $-2
		ld b,b
		ei		
		ld a,(memCCPage1) : ld (_memSlot1),a : out (PAGE1),a
		ld a,(memCCPage2) : ld (_memSlot2),a : out (PAGE2),a
		ld a,$C0 : out (PORT_Y),A		
		ret


/*
;установка прозрачного цвета для draw_tile_key

_color_key
	ld b,high colorMaskTable
	ld a,(bc)
	ld (_draw_tile_key.keyAB0),a
	ld (_draw_tile_key.keyAB1),a
	ld (_draw_tile_key.keyAB2),a
	ld (_draw_tile_key.keyAB3),a
	set 4,c
	ld a,(bc)
	ld (_draw_tile_key.keyA0),a
	ld (_draw_tile_key.keyA1),a
	ld (_draw_tile_key.keyA2),a
	ld (_draw_tile_key.keyA3),a
	set 5,c
	ld a,(bc)
	ld (_draw_tile_key.keyB0),a
	ld (_draw_tile_key.keyB1),a
	ld (_draw_tile_key.keyB2),a
	ld (_draw_tile_key.keyB3),a
	ret
*/

/*
;отрисовка тайла с прозрачными пикселями
;c=X, b=Y, de=tile
;координаты в тайлах

_draw_tile_key
	ld a,(spritesActive)
	or a
	call nz,setTileUpdateMapF
	MDrawTileGetAddrs
	MSetShadowScreen

	ld a,8
.loop
	exa
.column0
	ld a,(de)
.keyAB0=$+1
	cp 0
	jr z,.column0done
	and %01000111
.keyA0=$+1
	cp 0
	jr z,.skipA0
	ld c,a
	ld a,(hl)
	and %10111000
	or c
	ld (hl),a
.skipA0
	ld a,(de)
	and %10111000
.keyB0=$+1
	cp 0
	jr z,.column0done
	ld c,a
	ld a,(hl)
	and %01000111
	or c
	ld (hl),a
.column0done
	inc e
	set 5,h

.column1
	ld a,(de)
.keyAB1=$+1
	cp 0
	jr z,.column1done
	and %01000111
.keyA1=$+1
	cp 0
	jr z,.skipA1
	ld c,a
	ld a,(hl)
	and %10111000
	or c
	ld (hl),a
.skipA1
	ld a,(de)
	and %10111000
.keyB1=$+1
	cp 0
	jr z,.column1done
	ld c,a
	ld a,(hl)
	and %01000111
	or c
	ld (hl),a
.column1done
	inc e
	res 6,h
	set 7,h

.column2
	ld a,(de)
.keyAB2=$+1
	cp 0
	jr z,.column2done
	and %01000111
.keyA2=$+1
	cp 0
	jr z,.skipA2
	ld c,a
	ld a,(hl)
	and %10111000
	or c
	ld (hl),a
.skipA2
	ld a,(de)
	and %10111000
.keyB2=$+1
	cp 0
	jr z,.column2done
	ld c,a
	ld a,(hl)
	and %01000111
	or c
	ld (hl),a
.column2done
	inc e
	res 5,h

.column3
	ld a,(de)
.keyAB3=$+1
	cp 0
	jr z,.column3done
	and %01000111
.keyA3=$+1
	cp 0
	jr z,.skipA3
	ld c,a
	ld a,(hl)
	and %10111000
	or c
	ld (hl),a
.skipA3
	ld a,(de)
	and %10111000
.keyB3=$+1
	cp 0
	jr z,.column3done
	ld c,a
	ld a,(hl)
	and %01000111
	or c
	ld (hl),a
.column3done
	inc e
	ld bc,-16384+40
	add hl,bc
	exa
	dec a
	jp nz,.loop

	MRestoreMemMap012
	ret
*/


;отрисовка изображения целиком
;эта процедура быстрее чем вывод отдельных тайлов
;a=id, c=X, b=Y

_draw_image:	exx
		ld d,0
		ld e,a
		add a,a
		add a,e
		ld e,a
		ld hl,memImgPage
		add hl,de
		ld c,PAGE2
		exx

		ld a,VPAGE_TILES
		out (PAGE1),a

		ld de,$4160
		ld a,(_screenActive)
		and 1
		jr nz,.m1
		ld de,$4020
.m1		ld a,32 
		out (PORT_Y),a
		ld b,3
.lp1		exx : outi : exx
		push bc
		ld hl,$8000
		ld b,64
		di
		ld d,d   ; set accel block size
		ld a,0		
		ld b,b
.lp2		di
		ld l,l
		ld a,(hl)
		ld (de),a
		ld b,b
		ei
		inc h
		in a,(PORT_Y) : inc a : out (PORT_Y),a
		djnz .lp2
		pop bc
		djnz .lp1

		ld a,(memCCPage1) : ld (_memSlot1),a : out (PAGE1),a
		ld a,(memCCPage2) : ld (_memSlot2),a : out (PAGE2),a

		;pop bc	;координаты начала изображения B=y C=x
		;pop hl	;размеры выводимой части

		;если спрайты разрешены, помечаем выведенные тайлы в карте изменившихся тайлов

		ld a,(spritesActive)
		or a
		jr z,.done
		ld (tileUpdate),a
		ld bc,0
		ld hl,$1820
.setUpd1	push bc
		push hl
.setUpd2	push hl
		call setTileUpdateMap
		pop hl
		inc c
		dec l
		jp nz,.setUpd2
		pop hl
		pop bc
		inc b
		dec h
		jp nz,.setUpd1
.done		ld a,$C0 : out (PORT_Y),a
		;ld bc,MEM_SLOT0
		;ld a,~CC_PAGE0
		;out (c),a
		ret
