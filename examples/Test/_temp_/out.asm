;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.1.0 #12072 (MINGW64)
;--------------------------------------------------------
	.module main
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _wait_for_a_key
	.globl _fade_out
	.globl _make_black
	.globl _fade_screen
	.globl _unpack_screen
	.globl _screen_enable
	.globl _init_vdp
	.globl _fade_from_black
	.globl _fade_to_black
	.globl _fases_init
	.globl _sp_HideAllSpr
	.globl _sp_SetSpriteClip
	.globl _sp_GetKey
	.globl _sp_ClearRect
	.globl _sp_UpdateNow
	.globl _sp_DeleteSpr
	.globl _sp_MoveSprAbs
	.globl _sp_CreateSpr
	.globl _sp_PutTiles
	.globl _sp_GetTiles
	.globl _sp_PrintAtInv
	.globl _sp_TileSet
	.globl _sp_AttrGet
	.globl _sp_AttrSet
	.globl _sp_Init
	.globl _wyz_play_sound
	.globl _end_sprite
	.globl _sprites_start
	.globl _sprites_clip
	.globl _swap_screen
	.globl _draw_image
	.globl _draw_tile
	.globl _pal_select
	.globl _pal_bright
	.globl _joystick
	.globl _vsync
	.globl _spritesClip
	.globl _spritesClipValues
	.globl _needed_pal
	.globl _tilesc_pal
	.globl _tilesb_pal
	.globl _tilesa_pal
	.globl _sprites_pal
	.globl _warp_palette
	.globl _fases
	.globl _spriteList
	.globl _sp_attr_buf
	.globl _sp_tile_buf
	.globl _white_pal
	.globl _fases_data
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_sp_tile_buf::
	.ds 768
_sp_attr_buf::
	.ds 768
_spriteList::
	.ds 180
_fases::
	.ds 1665
_warp_palette::
	.ds 90
_sprites_pal::
	.ds 32
_tilesa_pal::
	.ds 32
_tilesb_pal::
	.ds 32
_tilesc_pal::
	.ds 32
_needed_pal::
	.ds 128
_spritesClipValues::
	.ds 4
_spritesClip::
	.ds 2
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;../../sdk/include/splib_evo.h:68: void sp_Init(void)
;	---------------------------------
; Function sp_Init
; ---------------------------------
_sp_Init::
;../../sdk/include/splib_evo.h:72: for (i = 0; i < 32 * 24; i++)
	ld	bc, #0x0000
00102$:
;../../sdk/include/splib_evo.h:74: sp_tile_buf[i] = 0;
	ld	hl, #_sp_tile_buf
	add	hl, bc
	ld	(hl), #0x00
;../../sdk/include/splib_evo.h:75: sp_attr_buf[i] = 0;
	ld	hl, #_sp_attr_buf
	add	hl, bc
	ld	(hl), #0x00
;../../sdk/include/splib_evo.h:72: for (i = 0; i < 32 * 24; i++)
	inc	bc
	ld	a, b
	sub	a, #0x03
	jr	C, 00102$
;../../sdk/include/splib_evo.h:80: }
	ret
;../../sdk/include/splib_evo.h:82: void sp_AttrSet(i16 x,i16 y,u8 a)
;	---------------------------------
; Function sp_AttrSet
; ---------------------------------
_sp_AttrSet::
	push	ix
	ld	ix,#0
	add	ix,sp
;../../sdk/include/splib_evo.h:84: if(y<24) sp_attr_buf[(y<<5)+x]=a;
	ld	a, 6 (ix)
	sub	a, #0x18
	ld	a, 7 (ix)
	rla
	ccf
	rra
	sbc	a, #0x80
	jr	NC, 00103$
	ld	bc, #_sp_attr_buf+0
	ld	l, 6 (ix)
	ld	h, 7 (ix)
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ex	de,hl
	ld	l, 4 (ix)
	ld	h, 5 (ix)
	add	hl, de
	add	hl, bc
	ld	a, 8 (ix)
	ld	(hl), a
00103$:
;../../sdk/include/splib_evo.h:85: }
	pop	ix
	ret
;../../sdk/include/splib_evo.h:87: u8 sp_AttrGet(i16 x,i16 y)
;	---------------------------------
; Function sp_AttrGet
; ---------------------------------
_sp_AttrGet::
	push	ix
	ld	ix,#0
	add	ix,sp
;../../sdk/include/splib_evo.h:89: return (y<24?sp_attr_buf[(y<<5)+x]:0);
	ld	a, 6 (ix)
	sub	a, #0x18
	ld	a, 7 (ix)
	rla
	ccf
	rra
	sbc	a, #0x80
	jr	NC, 00103$
	ld	bc, #_sp_attr_buf+0
	ld	l, 6 (ix)
	ld	h, 7 (ix)
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ex	de,hl
	ld	l, 4 (ix)
	ld	h, 5 (ix)
	add	hl, de
	add	hl, bc
	ld	l, (hl)
	ld	h, #0x00
	jr	00104$
00103$:
	ld	hl, #0x0000
00104$:
;../../sdk/include/splib_evo.h:90: }
	pop	ix
	ret
;../../sdk/include/splib_evo.h:92: void sp_TileSet(u8 col,u8 row,u16 tile)
;	---------------------------------
; Function sp_TileSet
; ---------------------------------
_sp_TileSet::
;../../sdk/include/splib_evo.h:100: draw_tile(col, row, tile);
	ld	iy, #4
	add	iy, sp
	ld	l, 0 (iy)
	ld	h, 1 (iy)
	push	hl
	ld	a, -1 (iy)
	dec	iy
	push	af
	inc	sp
	ld	a, -1 (iy)
	push	af
	inc	sp
	call	_draw_tile
	pop	af
	pop	af
;../../sdk/include/splib_evo.h:102: }
	ret
;../../sdk/include/splib_evo.h:106: void sp_PrintAtInv(u8 row, u8 col, u8 colour, u8 udg)
;	---------------------------------
; Function sp_PrintAtInv
; ---------------------------------
_sp_PrintAtInv::
	push	ix
	ld	ix,#0
	add	ix,sp
;../../sdk/include/splib_evo.h:110: ptr=(row<<5)+col;
	ld	l, 4 (ix)
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	c, 5 (ix)
	ld	b, #0x00
	add	hl, bc
	ex	de, hl
;../../sdk/include/splib_evo.h:111: sp_attr_buf[ptr]=colour;
	ld	hl, #_sp_attr_buf+0
	add	hl, de
	ld	a, 6 (ix)
	ld	(hl), a
;../../sdk/include/splib_evo.h:112: sp_tile_buf[ptr]=udg;
	ld	hl, #_sp_tile_buf+0
	add	hl, de
	ld	a, 7 (ix)
	ld	(hl), a
;../../sdk/include/splib_evo.h:114: draw_tile(col, row, udg);
	ld	c, 7 (ix)
	ld	b, #0x00
	push	bc
	ld	h, 4 (ix)
	ld	l, 5 (ix)
	push	hl
	call	_draw_tile
	pop	af
	pop	af
;../../sdk/include/splib_evo.h:115: }
	pop	ix
	ret
;../../sdk/include/splib_evo.h:117: void sp_GetTiles(struct sp_Rect *r, u8 *dest)
;	---------------------------------
; Function sp_GetTiles
; ---------------------------------
_sp_GetTiles::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-9
	add	hl, sp
	ld	sp, hl
;../../sdk/include/splib_evo.h:121: ptr=(r->row_coord<<5)+r->col_coord;
	ld	c, 4 (ix)
	ld	b, 5 (ix)
	ld	a, (bc)
	ld	h, #0x00
	ld	l, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ex	de,hl
	ld	l, c
	ld	h, b
	inc	hl
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	-2 (ix), l
	ld	-1 (ix), h
;../../sdk/include/splib_evo.h:123: for(i=0;i<r->height;i++)
	inc	sp
	inc	sp
	push	bc
	ld	-7 (ix), c
	ld	-6 (ix), b
	ld	de, #0x0000
00107$:
	ld	l, -7 (ix)
	ld	h, -6 (ix)
	inc	hl
	inc	hl
	ld	c, (hl)
	ld	b, #0x00
	ld	a, e
	sub	a, c
	ld	a, d
	sbc	a, b
	jr	NC, 00109$
;../../sdk/include/splib_evo.h:125: for(j=0;j<r->width;j++)
	ld	a, -2 (ix)
	ld	-4 (ix), a
	ld	a, -1 (ix)
	ld	-3 (ix), a
	ld	c, 6 (ix)
	ld	b, 7 (ix)
	xor	a, a
	ld	-2 (ix), a
	ld	-1 (ix), a
00104$:
	pop	hl
	push	hl
	inc	hl
	inc	hl
	inc	hl
	ld	a, (hl)
	ld	-5 (ix), a
	ld	l, a
	ld	h, #0x00
	ld	a, -2 (ix)
	sub	a, l
	ld	a, -1 (ix)
	sbc	a, h
	jr	NC, 00115$
;../../sdk/include/splib_evo.h:127: *dest++=sp_tile_buf[ptr++];
	ld	a, #<(_sp_tile_buf)
	add	a, -4 (ix)
	ld	l, a
	ld	a, #>(_sp_tile_buf)
	adc	a, -3 (ix)
	inc	-4 (ix)
	jr	NZ, 00133$
	inc	-3 (ix)
00133$:
	ld	h, a
	ld	a, (hl)
	ld	(bc), a
	inc	bc
;../../sdk/include/splib_evo.h:125: for(j=0;j<r->width;j++)
	inc	-2 (ix)
	jr	NZ, 00104$
	inc	-1 (ix)
	jr	00104$
00115$:
	ld	6 (ix), c
	ld	7 (ix), b
;../../sdk/include/splib_evo.h:129: ptr+=(32-r->width);
	ld	c, -5 (ix)
	ld	b, #0x00
	ld	hl, #0x0020
	cp	a, a
	sbc	hl, bc
	ld	c, -4 (ix)
	ld	b, -3 (ix)
	add	hl, bc
	ld	-2 (ix), l
	ld	-1 (ix), h
;../../sdk/include/splib_evo.h:123: for(i=0;i<r->height;i++)
	inc	de
	jp	00107$
00109$:
;../../sdk/include/splib_evo.h:131: }
	ld	sp, ix
	pop	ix
	ret
;../../sdk/include/splib_evo.h:133: void sp_PutTiles(struct sp_Rect *r, u8 *src)
;	---------------------------------
; Function sp_PutTiles
; ---------------------------------
_sp_PutTiles::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-15
	add	hl, sp
	ld	sp, hl
;../../sdk/include/splib_evo.h:137: ptr=(r->row_coord<<5)+r->col_coord;
	ld	c, 4 (ix)
	ld	b, 5 (ix)
	ld	a, (bc)
	ld	h, #0x00
	ld	l, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ex	de,hl
	ld	l, c
	ld	h, b
	inc	hl
	ex	(sp), hl
	pop	hl
	push	hl
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ex	de, hl
;../../sdk/include/splib_evo.h:139: for(i=0;i<r->height;i++)
	ld	-13 (ix), c
	ld	-12 (ix), b
	ld	-11 (ix), c
	ld	-10 (ix), b
	xor	a, a
	ld	-6 (ix), a
	ld	-5 (ix), a
00107$:
	ld	l, -11 (ix)
	ld	h, -10 (ix)
	inc	hl
	inc	hl
	ld	l, (hl)
	ld	h, #0x00
	ld	a, -6 (ix)
	sub	a, l
	ld	a, -5 (ix)
	sbc	a, h
	jp	NC, 00109$
;../../sdk/include/splib_evo.h:141: for(j=0;j<r->width;j++)
	ld	a, 6 (ix)
	ld	-4 (ix), a
	ld	a, 7 (ix)
	ld	-3 (ix), a
	xor	a, a
	ld	-2 (ix), a
	ld	-1 (ix), a
00104$:
	ld	l, -13 (ix)
	ld	h, -12 (ix)
	inc	hl
	inc	hl
	inc	hl
	ld	a, (hl)
	ld	-7 (ix), a
	ld	l, a
	ld	h, #0x00
	ld	a, -2 (ix)
	sub	a, l
	ld	a, -1 (ix)
	sbc	a, h
	jr	NC, 00115$
;../../sdk/include/splib_evo.h:143: sp_tile_buf[ptr]=*src++;
	ld	hl, #_sp_tile_buf
	add	hl, de
	ld	-8 (ix), l
	ld	-7 (ix), h
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	ld	a, (hl)
	inc	-4 (ix)
	jr	NZ, 00133$
	inc	-3 (ix)
00133$:
	ld	l, -8 (ix)
	ld	h, -7 (ix)
	ld	(hl), a
;../../sdk/include/splib_evo.h:144: sp_TileSet(r->col_coord+j,r->row_coord+i,sp_tile_buf[ptr++]);
	inc	de
	ld	-9 (ix), a
	ld	-8 (ix), #0
	ld	a, (bc)
	ld	l, -6 (ix)
	add	a, l
	ld	-7 (ix), a
	pop	hl
	push	hl
	ld	a, (hl)
	ld	l, -2 (ix)
	add	a, l
	push	bc
	push	de
	ld	l, -9 (ix)
	ld	h, -8 (ix)
	push	hl
	ld	h, -7 (ix)
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_sp_TileSet
	pop	af
	pop	af
	pop	de
	pop	bc
;../../sdk/include/splib_evo.h:141: for(j=0;j<r->width;j++)
	inc	-2 (ix)
	jr	NZ, 00104$
	inc	-1 (ix)
	jr	00104$
00115$:
	ld	a, -4 (ix)
	ld	6 (ix), a
	ld	a, -3 (ix)
	ld	7 (ix), a
;../../sdk/include/splib_evo.h:146: ptr+=(32-r->width);
	ld	l, -7 (ix)
	ld	h, #0x00
	ld	a, #0x20
	sub	a, l
	ld	l, a
	ld	a, #0x00
	sbc	a, h
	ld	h, a
	add	hl, de
	ex	de, hl
;../../sdk/include/splib_evo.h:139: for(i=0;i<r->height;i++)
	inc	-6 (ix)
	jp	NZ,00107$
	inc	-5 (ix)
	jp	00107$
00109$:
;../../sdk/include/splib_evo.h:148: }
	ld	sp, ix
	pop	ix
	ret
;../../sdk/include/splib_evo.h:152: struct sp_SS *sp_CreateSpr(u8 type, u8 rows, u16 graphic, u8 plane, u8 extra)
;	---------------------------------
; Function sp_CreateSpr
; ---------------------------------
_sp_CreateSpr::
;../../sdk/include/splib_evo.h:154: return 0;
	ld	hl, #0x0000
;../../sdk/include/splib_evo.h:155: }
	ret
;../../sdk/include/splib_evo.h:176: void sp_MoveSprAbs(struct sp_SS *sprite, struct sp_Rect *clip, u16 animate, u8 row, u8 col, u8 hpix, u8 vpix)
;	---------------------------------
; Function sp_MoveSprAbs
; ---------------------------------
_sp_MoveSprAbs::
;../../sdk/include/splib_evo.h:178: }
	ret
;../../sdk/include/splib_evo.h:193: void sp_DeleteSpr(struct sp_SS *sprite)
;	---------------------------------
; Function sp_DeleteSpr
; ---------------------------------
_sp_DeleteSpr::
;../../sdk/include/splib_evo.h:195: if(sprite)
	ld	iy, #2
	add	iy, sp
	ld	a, 1 (iy)
	or	a, 0 (iy)
	ret	Z
;../../sdk/include/splib_evo.h:197: sprite->active=FALSE;
	pop	de
	pop	bc
	push	bc
	push	de
	xor	a, a
	ld	(bc), a
;../../sdk/include/splib_evo.h:199: }
	ret
;../../sdk/include/splib_evo.h:203: void sp_UpdateNow(void)
;	---------------------------------
; Function sp_UpdateNow
; ---------------------------------
_sp_UpdateNow::
;../../sdk/include/splib_evo.h:205: end_sprite();
	call	_end_sprite
;../../sdk/include/splib_evo.h:206: swap_screen();
;../../sdk/include/splib_evo.h:207: }
	jp	_swap_screen
;../../sdk/include/splib_evo.h:250: void sp_ClearRect(struct sp_Rect *area, u8 colour, u8 udg, u8 flags)
;	---------------------------------
; Function sp_ClearRect
; ---------------------------------
_sp_ClearRect::
	push	ix
	ld	ix,#0
	add	ix,sp
;../../sdk/include/splib_evo.h:254: for(i=0;i<24;i++)
	ld	bc, #0x0000
;../../sdk/include/splib_evo.h:256: for(j=0;j<32;j++)
00109$:
	ld	de, #0x0000
00103$:
;../../sdk/include/splib_evo.h:258: sp_PrintAtInv(i,j,0,0);
	ld	a, e
	ld	l, c
	push	bc
	push	de
	ld	h, #0x00
	push	hl
	inc	sp
	ld	h, #0x00
	push	hl
	inc	sp
	push	af
	ld	a, l
	inc	sp
	push	af
	inc	sp
	call	_sp_PrintAtInv
	pop	af
	pop	af
	pop	de
	pop	bc
;../../sdk/include/splib_evo.h:256: for(j=0;j<32;j++)
	inc	de
	ld	a, e
	sub	a, #0x20
	ld	a, d
	sbc	a, #0x00
	jr	C, 00103$
;../../sdk/include/splib_evo.h:254: for(i=0;i<24;i++)
	inc	bc
	ld	a, c
	sub	a, #0x18
	ld	a, b
	sbc	a, #0x00
	jr	C, 00109$
;../../sdk/include/splib_evo.h:261: }
	pop	ix
	ret
;../../sdk/include/splib_evo.h:265: u8 sp_GetKey(void)
;	---------------------------------
; Function sp_GetKey
; ---------------------------------
_sp_GetKey::
;../../sdk/include/splib_evo.h:267: return (joystick()&(JOY_FIRE|JOY_START))?1:0;
	call	_joystick
	ld	a, l
	and	a, #0x30
	jr	Z, 00103$
	ld	hl, #0x0001
	ret
00103$:
	ld	hl, #0x0000
;../../sdk/include/splib_evo.h:268: }
	ret
;../../sdk/include/splib_evo.h:272: void sp_SetSpriteClip(struct sp_Rect *clip)
;	---------------------------------
; Function sp_SetSpriteClip
; ---------------------------------
_sp_SetSpriteClip::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	push	af
;../../sdk/include/splib_evo.h:277: empty.col_coord=0;
	ld	hl, #0
	add	hl, sp
	ex	de, hl
	ld	c, e
	ld	b, d
	inc	bc
	xor	a, a
	ld	(bc), a
;../../sdk/include/splib_evo.h:278: empty.row_coord=0;
	xor	a, a
	ld	(de), a
;../../sdk/include/splib_evo.h:279: empty.width=32;
	ld	l, e
	ld	h, d
	inc	hl
	inc	hl
	inc	hl
	ld	(hl), #0x20
;../../sdk/include/splib_evo.h:280: empty.height=24;
	ld	l, e
	ld	h, d
	inc	hl
	inc	hl
	ld	(hl), #0x18
;../../sdk/include/splib_evo.h:282: if(!clip) clip=&empty;
	ld	a, 5 (ix)
	or	a, 4 (ix)
	jr	NZ, 00114$
	ld	4 (ix), e
	ld	5 (ix), d
;../../sdk/include/splib_evo.h:284: for(i=0;i<24;i++)
00114$:
	ld	bc, #0x0018
00107$:
	dec	bc
	ld	a, b
	or	a, c
	jr	NZ, 00107$
;../../sdk/include/splib_evo.h:291: for(i=0;i<clip->height;i++)
	ld	l, 4 (ix)
	ld	h, 5 (ix)
	ld	de, #0x0000
00109$:
	inc	hl
	inc	hl
	ld	c, (hl)
	ld	b, #0x00
	ld	a, e
	sub	a, c
	ld	a, d
	sbc	a, b
	jr	NC, 00111$
	inc	de
	jr	00109$
00111$:
;../../sdk/include/splib_evo.h:295: }
	ld	sp, ix
	pop	ix
	ret
;../../sdk/include/splib_evo.h:297: void sp_HideAllSpr(void)
;	---------------------------------
; Function sp_HideAllSpr
; ---------------------------------
_sp_HideAllSpr::
;../../sdk/include/splib_evo.h:300: }
	ret
;../../sdk/include/fases.h:1826: void fases_init(void)
;	---------------------------------
; Function fases_init
; ---------------------------------
_fases_init::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-8
	add	hl, sp
	ld	sp, hl
;../../sdk/include/fases.h:1831: ptr=fases_data;
	ld	-2 (ix), #<(_fases_data)
	ld	-1 (ix), #>(_fases_data)
;../../sdk/include/fases.h:1833: for(i=0;i<45;i++)
	xor	a, a
	ld	-4 (ix), a
	ld	-3 (ix), a
00111$:
;../../sdk/include/fases.h:1835: fases[i].descriptor=*ptr++;
	ld	c, -4 (ix)
	ld	b, -3 (ix)
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ex	de, hl
	ld	hl, #_fases
	add	hl, de
	ex	de, hl
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	ld	a, (hl)
	ld	c, -2 (ix)
	ld	b, -1 (ix)
	inc	bc
	ld	(de), a
;../../sdk/include/fases.h:1836: for(j=0;j<10;j++)
	inc	de
	xor	a, a
	ld	-2 (ix), a
	ld	-1 (ix), a
00105$:
;../../sdk/include/fases.h:1838: tmp=*ptr++;
	ld	a, (bc)
	ld	-5 (ix), a
	inc	bc
	inc	sp
	inc	sp
	push	bc
	ld	a, -5 (ix)
	ld	-6 (ix), a
	ld	-5 (ix), #0
;../../sdk/include/fases.h:1839: tmp=(*ptr++<<8)|tmp;
	pop	hl
	push	hl
	ld	l, (hl)
	pop	bc
	push	bc
	inc	bc
	ld	a, #0x00
	or	a, -6 (ix)
	ld	-8 (ix), a
	ld	a, l
	or	a, -5 (ix)
	ld	-7 (ix), a
;../../sdk/include/fases.h:1840: fases[i].obj[j]=tmp;
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	add	hl, hl
	add	hl, de
	ld	a, -8 (ix)
	ld	(hl), a
	inc	hl
	ld	a, -7 (ix)
	ld	(hl), a
;../../sdk/include/fases.h:1836: for(j=0;j<10;j++)
	inc	-2 (ix)
	jr	NZ, 00161$
	inc	-1 (ix)
00161$:
	ld	a, -2 (ix)
	sub	a, #0x0a
	ld	a, -1 (ix)
	sbc	a, #0x00
	jr	C, 00105$
;../../sdk/include/fases.h:1842: for(j=0;j<3;j++)
	ld	e, -4 (ix)
	ld	d, -3 (ix)
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, de
	ld	de, #_fases
	add	hl, de
	ld	de, #0x0015
	add	hl, de
	ex	(sp), hl
	ld	de, #0x0000
00107$:
;../../sdk/include/fases.h:1844: tmp=*ptr++;
	ld	a, (bc)
	inc	bc
	ld	-6 (ix), a
	ld	-5 (ix), #0
;../../sdk/include/fases.h:1845: tmp=(*ptr++<<8)|tmp;
	ld	a, (bc)
	inc	bc
	ld	l, a
	ld	a, #0x00
	or	a, -6 (ix)
	ld	-2 (ix), a
	ld	a, l
	or	a, -5 (ix)
	ld	-1 (ix), a
;../../sdk/include/fases.h:1846: fases[i].movil[j]=tmp;
	ld	l, e
	ld	h, d
	add	hl, hl
	ld	a, l
	add	a, -8 (ix)
	ld	l, a
	ld	a, h
	adc	a, -7 (ix)
	ld	h, a
	ld	a, -2 (ix)
	ld	(hl), a
	inc	hl
	ld	a, -1 (ix)
	ld	(hl), a
;../../sdk/include/fases.h:1842: for(j=0;j<3;j++)
	inc	de
	ld	a, e
	sub	a, #0x03
	ld	a, d
	sbc	a, #0x00
	jr	C, 00107$
;../../sdk/include/fases.h:1848: for(j=0;j<10;j++) fases[i].coin[j]=*ptr++;
	ld	e, -4 (ix)
	ld	d, -3 (ix)
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, de
	ld	de, #_fases
	add	hl, de
	ld	de, #0x001b
	add	hl, de
	ld	-2 (ix), l
	ld	-1 (ix), h
	ld	de, #0x0000
00109$:
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	add	hl, de
	ld	a, (bc)
	inc	bc
	ld	(hl), a
	inc	de
	ld	a, e
	sub	a, #0x0a
	ld	a, d
	sbc	a, #0x00
	jr	C, 00109$
;../../sdk/include/fases.h:1833: for(i=0;i<45;i++)
	ld	-2 (ix), c
	ld	-1 (ix), b
	inc	-4 (ix)
	jr	NZ, 00162$
	inc	-3 (ix)
00162$:
	ld	a, -4 (ix)
	sub	a, #0x2d
	ld	a, -3 (ix)
	sbc	a, #0x00
	jp	C, 00111$
;../../sdk/include/fases.h:1850: }
	ld	sp, ix
	pop	ix
	ret
_fases_data:
	.db #0x0d	; 13
	.db #0xc2	; 194
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x13	; 19
	.db #0x30	; 48	'0'
	.db #0x83	; 131
	.db #0x20	; 32
	.db #0x55	; 85	'U'
	.db #0x30	; 48	'0'
	.db #0x17	; 23
	.db #0x30	; 48	'0'
	.db #0x87	; 135
	.db #0xcc	; 204
	.db #0x09	; 9
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x15	; 21
	.db #0x1a	; 26
	.db #0x63	; 99	'c'
	.db #0x1a	; 26
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x12	; 18
	.db #0x32	; 50	'2'
	.db #0x82	; 130
	.db #0xa2	; 162
	.db #0x54	; 84	'T'
	.db #0x64	; 100	'd'
	.db #0x16	; 22
	.db #0x36	; 54	'6'
	.db #0x86	; 134
	.db #0xa6	; 166
	.db #0x04	; 4
	.db #0xc4	; 196
	.db #0x00	; 0
	.db #0x35	; 53	'5'
	.db #0x01	; 1
	.db #0x17	; 23
	.db #0xa2	; 162
	.db #0x17	; 23
	.db #0x93	; 147
	.db #0x36	; 54	'6'
	.db #0x25	; 37
	.db #0x36	; 54	'6'
	.db #0x85	; 133
	.db #0x35	; 53	'5'
	.db #0xb6	; 182
	.db #0x36	; 54	'6'
	.db #0x57	; 87	'W'
	.db #0xc4	; 196
	.db #0x09	; 9
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x22	; 34
	.db #0x69	; 105	'i'
	.db #0x50	; 80	'P'
	.db #0x57	; 87	'W'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x92	; 146
	.db #0x24	; 36
	.db #0x34	; 52	'4'
	.db #0x44	; 68	'D'
	.db #0x84	; 132
	.db #0xb5	; 181
	.db #0x56	; 86	'V'
	.db #0x66	; 102	'f'
	.db #0x76	; 118	'v'
	.db #0x18	; 24
	.db #0x0f	; 15
	.db #0xc2	; 194
	.db #0x00	; 0
	.db #0xbc	; 188
	.db #0x13	; 19
	.db #0x1d	; 29
	.db #0x05	; 5
	.db #0x9c	; 156
	.db #0x06	; 6
	.db #0x1d	; 29
	.db #0xb7	; 183
	.db #0xc0	; 192
	.db #0x09	; 9
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x25	; 37
	.db #0x0b	; 11
	.db #0x52	; 82	'R'
	.db #0x1b	; 27
	.db #0x84	; 132
	.db #0x2a	; 42
	.db #0x11	; 17
	.db #0x51	; 81	'Q'
	.db #0x91	; 145
	.db #0x14	; 20
	.db #0x54	; 84	'T'
	.db #0x94	; 148
	.db #0xb6	; 182
	.db #0x17	; 23
	.db #0x57	; 87	'W'
	.db #0x97	; 151
	.db #0x03	; 3
	.db #0x90	; 144
	.db #0x00	; 0
	.db #0x35	; 53	'5'
	.db #0xb0	; 176
	.db #0x55	; 85	'U'
	.db #0x01	; 1
	.db #0x90	; 144
	.db #0x33	; 51	'3'
	.db #0x25	; 37
	.db #0xb4	; 180
	.db #0x19	; 25
	.db #0x15	; 21
	.db #0x70	; 112	'p'
	.db #0x26	; 38
	.db #0x18	; 24
	.db #0x98	; 152
	.db #0xc0	; 192
	.db #0x09	; 9
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x22	; 34
	.db #0x1a	; 26
	.db #0x43	; 67	'C'
	.db #0x1a	; 26
	.db #0x70	; 112	'p'
	.db #0x2a	; 42
	.db #0x21	; 33
	.db #0x41	; 65	'A'
	.db #0x61	; 97	'a'
	.db #0x81	; 129
	.db #0xa1	; 161
	.db #0x14	; 20
	.db #0x34	; 52	'4'
	.db #0x54	; 84	'T'
	.db #0x74	; 116	't'
	.db #0x94	; 148
	.db #0x17	; 23
	.db #0xcc	; 204
	.db #0x00	; 0
	.db #0x28	; 40
	.db #0x03	; 3
	.db #0x28	; 40
	.db #0x53	; 83	'S'
	.db #0x28	; 40
	.db #0xa3	; 163
	.db #0x19	; 25
	.db #0x44	; 68	'D'
	.db #0x32	; 50	'2'
	.db #0x06	; 6
	.db #0x22	; 34
	.db #0x56	; 86	'V'
	.db #0x32	; 50	'2'
	.db #0x96	; 150
	.db #0x1b	; 27
	.db #0x78	; 120	'x'
	.db #0xca	; 202
	.db #0x09	; 9
	.db #0x22	; 34
	.db #0x05	; 5
	.db #0x23	; 35
	.db #0x6b	; 107	'k'
	.db #0x53	; 83	'S'
	.db #0x0b	; 11
	.db #0x02	; 2
	.db #0x32	; 50	'2'
	.db #0x52	; 82	'R'
	.db #0x62	; 98	'b'
	.db #0x82	; 130
	.db #0xb2	; 178
	.db #0x05	; 5
	.db #0x25	; 37
	.db #0x95	; 149
	.db #0xb5	; 181
	.db #0x06	; 6
	.db #0xca	; 202
	.db #0x00	; 0
	.db #0x67	; 103	'g'
	.db #0xb1	; 177
	.db #0x17	; 23
	.db #0x42	; 66	'B'
	.db #0x57	; 87	'W'
	.db #0x13	; 19
	.db #0x17	; 23
	.db #0x63	; 99	'c'
	.db #0x26	; 38
	.db #0x65	; 101	'e'
	.db #0x17	; 23
	.db #0x86	; 134
	.db #0x36	; 54	'6'
	.db #0x27	; 39
	.db #0x36	; 54	'6'
	.db #0x78	; 120	'x'
	.db #0xca	; 202
	.db #0x09	; 9
	.db #0x13	; 19
	.db #0x0a	; 10
	.db #0x44	; 68	'D'
	.db #0x25	; 37
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x02	; 2
	.db #0x62	; 98	'b'
	.db #0x82	; 130
	.db #0x03	; 3
	.db #0x04	; 4
	.db #0x05	; 5
	.db #0x06	; 6
	.db #0x26	; 38
	.db #0x36	; 54	'6'
	.db #0x46	; 70	'F'
	.db #0x16	; 22
	.db #0xcc	; 204
	.db #0x00	; 0
	.db #0x75	; 117	'u'
	.db #0x01	; 1
	.db #0x75	; 117	'u'
	.db #0xb1	; 177
	.db #0x19	; 25
	.db #0x53	; 83	'S'
	.db #0x19	; 25
	.db #0x94	; 148
	.db #0x19	; 25
	.db #0x65	; 101	'e'
	.db #0x19	; 25
	.db #0x46	; 70	'F'
	.db #0x19	; 25
	.db #0x27	; 39
	.db #0x19	; 25
	.db #0x87	; 135
	.db #0xc0	; 192
	.db #0x09	; 9
	.db #0x13	; 19
	.db #0x1a	; 26
	.db #0x44	; 68	'D'
	.db #0x18	; 24
	.db #0x71	; 113	'q'
	.db #0x37	; 55	'7'
	.db #0x42	; 66	'B'
	.db #0x62	; 98	'b'
	.db #0x92	; 146
	.db #0x43	; 67	'C'
	.db #0x93	; 147
	.db #0x25	; 37
	.db #0x45	; 69	'E'
	.db #0x85	; 133
	.db #0x26	; 38
	.db #0x86	; 134
	.db #0x03	; 3
	.db #0x57	; 87	'W'
	.db #0x61	; 97	'a'
	.db #0x77	; 119	'w'
	.db #0xa1	; 161
	.db #0x17	; 23
	.db #0xb1	; 177
	.db #0x17	; 23
	.db #0x22	; 34
	.db #0x57	; 87	'W'
	.db #0x82	; 130
	.db #0x36	; 54	'6'
	.db #0x03	; 3
	.db #0x27	; 39
	.db #0x43	; 67	'C'
	.db #0x17	; 23
	.db #0xb5	; 181
	.db #0x52	; 82	'R'
	.db #0x17	; 23
	.db #0xc0	; 192
	.db #0x09	; 9
	.db #0x05	; 5
	.db #0x0b	; 11
	.db #0x50	; 80	'P'
	.db #0x05	; 5
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x52	; 82	'R'
	.db #0x72	; 114	'r'
	.db #0x92	; 146
	.db #0x73	; 115	's'
	.db #0x93	; 147
	.db #0x74	; 116	't'
	.db #0x94	; 148
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x02	; 2
	.db #0x15	; 21
	.db #0x21	; 33
	.db #0x34	; 52	'4'
	.db #0x51	; 81	'Q'
	.db #0x55	; 85	'U'
	.db #0x03	; 3
	.db #0x92	; 146
	.db #0x15	; 21
	.db #0x15	; 21
	.db #0xb7	; 183
	.db #0xc0	; 192
	.db #0x09	; 9
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x35	; 53	'5'
	.db #0x16	; 22
	.db #0x35	; 53	'5'
	.db #0x6b	; 107	'k'
	.db #0x62	; 98	'b'
	.db #0x1b	; 27
	.db #0x70	; 112	'p'
	.db #0x52	; 82	'R'
	.db #0x62	; 98	'b'
	.db #0x72	; 114	'r'
	.db #0x26	; 38
	.db #0x36	; 54	'6'
	.db #0x86	; 134
	.db #0x96	; 150
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x07	; 7
	.db #0x6d	; 109	'm'
	.db #0x32	; 50	'2'
	.db #0x3d	; 61
	.db #0x82	; 130
	.db #0x1d	; 29
	.db #0x43	; 67	'C'
	.db #0x2c	; 44
	.db #0xa3	; 163
	.db #0x2c	; 44
	.db #0x05	; 5
	.db #0x5c	; 92
	.db #0x45	; 69	'E'
	.db #0x2d	; 45
	.db #0x86	; 134
	.db #0x2c	; 44
	.db #0x97	; 151
	.db #0xc0	; 192
	.db #0x09	; 9
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x05	; 5
	.db #0x0b	; 11
	.db #0x21	; 33
	.db #0x47	; 71	'G'
	.db #0x83	; 131
	.db #0x1b	; 27
	.db #0x44	; 68	'D'
	.db #0x54	; 84	'T'
	.db #0x64	; 100	'd'
	.db #0x74	; 116	't'
	.db #0x57	; 87	'W'
	.db #0x67	; 103	'g'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x4d	; 77	'M'
	.db #0xcc	; 204
	.db #0x00	; 0
	.db #0x19	; 25
	.db #0x13	; 19
	.db #0x19	; 25
	.db #0xa3	; 163
	.db #0x48	; 72	'H'
	.db #0x44	; 68	'D'
	.db #0x1d	; 29
	.db #0x36	; 54	'6'
	.db #0x1d	; 29
	.db #0x86	; 134
	.db #0x1d	; 29
	.db #0x17	; 23
	.db #0x46	; 70	'F'
	.db #0x47	; 71	'G'
	.db #0x1d	; 29
	.db #0xa7	; 167
	.db #0xcc	; 204
	.db #0x09	; 9
	.db #0x30	; 48	'0'
	.db #0x25	; 37
	.db #0x51	; 81	'Q'
	.db #0x38	; 56	'8'
	.db #0x82	; 130
	.db #0x45	; 69	'E'
	.db #0x12	; 18
	.db #0x42	; 66	'B'
	.db #0x52	; 82	'R'
	.db #0x62	; 98	'b'
	.db #0x72	; 114	'r'
	.db #0xa2	; 162
	.db #0x46	; 70	'F'
	.db #0x56	; 86	'V'
	.db #0x66	; 102	'f'
	.db #0x76	; 118	'v'
	.db #0x47	; 71	'G'
	.db #0x3f	; 63
	.db #0x71	; 113	'q'
	.db #0x22	; 34
	.db #0xa1	; 161
	.db #0x2e	; 46
	.db #0x22	; 34
	.db #0x32	; 50	'2'
	.db #0x54	; 84	'T'
	.db #0x22	; 34
	.db #0x16	; 22
	.db #0x1f	; 31
	.db #0x78	; 120	'x'
	.db #0x2e	; 46
	.db #0xa8	; 168
	.db #0x2e	; 46
	.db #0x09	; 9
	.db #0x13	; 19
	.db #0x49	; 73	'I'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x04	; 4
	.db #0x0b	; 11
	.db #0x30	; 48	'0'
	.db #0x06	; 6
	.db #0x82	; 130
	.db #0x26	; 38
	.db #0x70	; 112	'p'
	.db #0xb0	; 176
	.db #0x21	; 33
	.db #0x31	; 49	'1'
	.db #0x53	; 83	'S'
	.db #0x63	; 99	'c'
	.db #0x34	; 52	'4'
	.db #0x15	; 21
	.db #0x25	; 37
	.db #0x77	; 119	'w'
	.db #0x4c	; 76	'L'
	.db #0xc4	; 196
	.db #0x00	; 0
	.db #0x54	; 84	'T'
	.db #0x03	; 3
	.db #0x34	; 52	'4'
	.db #0x83	; 131
	.db #0x5b	; 91
	.db #0xa4	; 164
	.db #0x19	; 25
	.db #0x65	; 101	'e'
	.db #0x2a	; 42
	.db #0x37	; 55	'7'
	.db #0x3a	; 58
	.db #0x28	; 40
	.db #0x19	; 25
	.db #0x88	; 136
	.db #0x6a	; 106	'j'
	.db #0x09	; 9
	.db #0x2a	; 42
	.db #0xa9	; 169
	.db #0x20	; 32
	.db #0x39	; 57	'9'
	.db #0x42	; 66	'B'
	.db #0x79	; 121	'y'
	.db #0x65	; 101	'e'
	.db #0x49	; 73	'I'
	.db #0x01	; 1
	.db #0x41	; 65	'A'
	.db #0x81	; 129
	.db #0x22	; 34
	.db #0xa2	; 162
	.db #0x64	; 100	'd'
	.db #0x95	; 149
	.db #0x67	; 103	'g'
	.db #0x87	; 135
	.db #0xb7	; 183
	.db #0x45	; 69	'E'
	.db #0x72	; 114	'r'
	.db #0x00	; 0
	.db #0x11	; 17
	.db #0x82	; 130
	.db #0x5a	; 90	'Z'
	.db #0x34	; 52	'4'
	.db #0x11	; 17
	.db #0xa4	; 164
	.db #0x11	; 17
	.db #0x16	; 22
	.db #0x11	; 17
	.db #0x37	; 55	'7'
	.db #0x3a	; 58
	.db #0x09	; 9
	.db #0x72	; 114	'r'
	.db #0x59	; 89	'Y'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x22	; 34
	.db #0x17	; 23
	.db #0x65	; 101	'e'
	.db #0x3a	; 58
	.db #0x80	; 128
	.db #0x79	; 121	'y'
	.db #0x81	; 129
	.db #0x33	; 51	'3'
	.db #0x43	; 67	'C'
	.db #0x63	; 99	'c'
	.db #0x73	; 115	's'
	.db #0xa3	; 163
	.db #0x15	; 21
	.db #0x36	; 54	'6'
	.db #0x78	; 120	'x'
	.db #0x88	; 136
	.db #0x42	; 66	'B'
	.db #0x19	; 25
	.db #0x22	; 34
	.db #0x72	; 114	'r'
	.db #0x52	; 82	'R'
	.db #0x19	; 25
	.db #0x33	; 51	'3'
	.db #0x19	; 25
	.db #0x44	; 68	'D'
	.db #0x19	; 25
	.db #0x55	; 85	'U'
	.db #0x32	; 50	'2'
	.db #0x66	; 102	'f'
	.db #0x22	; 34
	.db #0xa7	; 167
	.db #0x4e	; 78	'N'
	.db #0x09	; 9
	.db #0x6e	; 110	'n'
	.db #0x69	; 105	'i'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x15	; 21
	.db #0x5b	; 91
	.db #0x55	; 85	'U'
	.db #0x68	; 104	'h'
	.db #0x84	; 132
	.db #0x36	; 54	'6'
	.db #0x10	; 16
	.db #0x01	; 1
	.db #0x21	; 33
	.db #0xb1	; 177
	.db #0x32	; 50	'2'
	.db #0x43	; 67	'C'
	.db #0xb6	; 182
	.db #0x47	; 71	'G'
	.db #0x57	; 87	'W'
	.db #0x98	; 152
	.db #0x56	; 86	'V'
	.db #0xa2	; 162
	.db #0x21	; 33
	.db #0xa2	; 162
	.db #0x13	; 19
	.db #0xa2	; 162
	.db #0x25	; 37
	.db #0xa2	; 162
	.db #0x17	; 23
	.db #0xc0	; 192
	.db #0x09	; 9
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x22	; 34
	.db #0x0a	; 10
	.db #0x42	; 66	'B'
	.db #0x0b	; 11
	.db #0x62	; 98	'b'
	.db #0x0a	; 10
	.db #0xa0	; 160
	.db #0xb0	; 176
	.db #0x11	; 17
	.db #0xb2	; 178
	.db #0xb3	; 179
	.db #0xb4	; 180
	.db #0x15	; 21
	.db #0xb6	; 182
	.db #0xb7	; 183
	.db #0xb8	; 184
	.db #0x44	; 68	'D'
	.db #0x31	; 49	'1'
	.db #0x63	; 99	'c'
	.db #0x19	; 25
	.db #0x34	; 52	'4'
	.db #0x19	; 25
	.db #0x94	; 148
	.db #0x19	; 25
	.db #0x45	; 69	'E'
	.db #0x19	; 25
	.db #0x85	; 133
	.db #0x30	; 48	'0'
	.db #0x17	; 23
	.db #0x48	; 72	'H'
	.db #0x47	; 71	'G'
	.db #0x30	; 48	'0'
	.db #0x87	; 135
	.db #0x5c	; 92
	.db #0x09	; 9
	.db #0x5c	; 92
	.db #0x79	; 121	'y'
	.db #0x22	; 34
	.db #0x79	; 121	'y'
	.db #0x32	; 50	'2'
	.db #0x35	; 53	'5'
	.db #0x63	; 99	'c'
	.db #0x1a	; 26
	.db #0x61	; 97	'a'
	.db #0x62	; 98	'b'
	.db #0x44	; 68	'D'
	.db #0x84	; 132
	.db #0x16	; 22
	.db #0x46	; 70	'F'
	.db #0x86	; 134
	.db #0xa6	; 166
	.db #0x58	; 88	'X'
	.db #0x68	; 104	'h'
	.db #0x46	; 70	'F'
	.db #0x2c	; 44
	.db #0x01	; 1
	.db #0x48	; 72	'H'
	.db #0x82	; 130
	.db #0x38	; 56	'8'
	.db #0x33	; 51	'3'
	.db #0x19	; 25
	.db #0x04	; 4
	.db #0x84	; 132
	.db #0x25	; 37
	.db #0xb6	; 182
	.db #0x17	; 23
	.db #0xce	; 206
	.db #0x09	; 9
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x15	; 21
	.db #0x8b	; 139
	.db #0x20	; 32
	.db #0x35	; 53	'5'
	.db #0x42	; 66	'B'
	.db #0x28	; 40
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0xb1	; 177
	.db #0x32	; 50	'2'
	.db #0x03	; 3
	.db #0x84	; 132
	.db #0x94	; 148
	.db #0xa5	; 165
	.db #0x06	; 6
	.db #0xb6	; 182
	.db #0x4b	; 75	'K'
	.db #0x19	; 25
	.db #0x91	; 145
	.db #0x19	; 25
	.db #0x82	; 130
	.db #0x19	; 25
	.db #0xa2	; 162
	.db #0x19	; 25
	.db #0x73	; 115	's'
	.db #0x19	; 25
	.db #0xb3	; 179
	.db #0x19	; 25
	.db #0x64	; 100	'd'
	.db #0x19	; 25
	.db #0x55	; 85	'U'
	.db #0x19	; 25
	.db #0x46	; 70	'F'
	.db #0x19	; 25
	.db #0x37	; 55	'7'
	.db #0xc4	; 196
	.db #0x09	; 9
	.db #0x02	; 2
	.db #0x7b	; 123
	.db #0x22	; 34
	.db #0x07	; 7
	.db #0x82	; 130
	.db #0x2b	; 43
	.db #0x90	; 144
	.db #0x81	; 129
	.db #0xa1	; 161
	.db #0x02	; 2
	.db #0x72	; 114	'r'
	.db #0xb2	; 178
	.db #0x63	; 99	'c'
	.db #0x54	; 84	'T'
	.db #0x45	; 69	'E'
	.db #0x36	; 54	'6'
	.db #0x41	; 65	'A'
	.db #0x40	; 64
	.db #0x01	; 1
	.db #0x13	; 19
	.db #0xb1	; 177
	.db #0x19	; 25
	.db #0x43	; 67	'C'
	.db #0x6a	; 106	'j'
	.db #0x53	; 83	'S'
	.db #0x19	; 25
	.db #0x34	; 52	'4'
	.db #0x19	; 25
	.db #0x15	; 21
	.db #0x19	; 25
	.db #0x26	; 38
	.db #0x19	; 25
	.db #0x37	; 55	'7'
	.db #0xa0	; 160
	.db #0x09	; 9
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x0b	; 11
	.db #0x21	; 33
	.db #0x4a	; 74	'J'
	.db #0x83	; 131
	.db #0x35	; 53	'5'
	.db #0x00	; 0
	.db #0xb0	; 176
	.db #0x42	; 66	'B'
	.db #0xa2	; 162
	.db #0x33	; 51	'3'
	.db #0x14	; 20
	.db #0x25	; 37
	.db #0x36	; 54	'6'
	.db #0xa8	; 168
	.db #0x00	; 0
	.db #0x45	; 69	'E'
	.db #0x1b	; 27
	.db #0x22	; 34
	.db #0x1b	; 27
	.db #0x92	; 146
	.db #0x2a	; 42
	.db #0x53	; 83	'S'
	.db #0x3a	; 58
	.db #0x05	; 5
	.db #0x3a	; 58
	.db #0x95	; 149
	.db #0x4e	; 78	'N'
	.db #0x47	; 71	'G'
	.db #0x3e	; 62
	.db #0x09	; 9
	.db #0x3e	; 62
	.db #0x99	; 153
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x11	; 17
	.db #0x0b	; 11
	.db #0x64	; 100	'd'
	.db #0x14	; 20
	.db #0x62	; 98	'b'
	.db #0x7a	; 122	'z'
	.db #0x21	; 33
	.db #0x91	; 145
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x82	; 130
	.db #0x5d	; 93
	.db #0x21	; 33
	.db #0x6c	; 108	'l'
	.db #0x31	; 49	'1'
	.db #0x1d	; 29
	.db #0x02	; 2
	.db #0x1d	; 29
	.db #0xb2	; 178
	.db #0x2c	; 44
	.db #0x84	; 132
	.db #0x2c	; 44
	.db #0x35	; 53	'5'
	.db #0x11	; 17
	.db #0x76	; 118	'v'
	.db #0x4c	; 76	'L'
	.db #0x58	; 88	'X'
	.db #0x2e	; 46
	.db #0x09	; 9
	.db #0x2e	; 46
	.db #0xa9	; 169
	.db #0x01	; 1
	.db #0x28	; 40
	.db #0x22	; 34
	.db #0x6a	; 106	'j'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x01	; 1
	.db #0x72	; 114	'r'
	.db #0x34	; 52	'4'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x87	; 135
	.db #0x00	; 0
	.db #0x81	; 129
	.db #0x2e	; 46
	.db #0x82	; 130
	.db #0x3e	; 62
	.db #0x73	; 115	's'
	.db #0x4e	; 78	'N'
	.db #0x64	; 100	'd'
	.db #0x5e	; 94
	.db #0x55	; 85	'U'
	.db #0x6e	; 110	'n'
	.db #0x46	; 70	'F'
	.db #0x7e	; 126
	.db #0x37	; 55	'7'
	.db #0x8e	; 142
	.db #0x28	; 40
	.db #0xce	; 206
	.db #0x09	; 9
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x11	; 17
	.db #0x07	; 7
	.db #0x34	; 52	'4'
	.db #0x05	; 5
	.db #0x52	; 82	'R'
	.db #0x03	; 3
	.db #0x81	; 129
	.db #0x63	; 99	'c'
	.db #0x45	; 69	'E'
	.db #0x27	; 39
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x85	; 133
	.db #0xc2	; 194
	.db #0x00	; 0
	.db #0x11	; 17
	.db #0x01	; 1
	.db #0x11	; 17
	.db #0xb1	; 177
	.db #0x80	; 128
	.db #0x22	; 34
	.db #0x42	; 66	'B'
	.db #0x14	; 20
	.db #0x42	; 66	'B'
	.db #0x74	; 116	't'
	.db #0x80	; 128
	.db #0x26	; 38
	.db #0x11	; 17
	.db #0xb8	; 184
	.db #0xc2	; 194
	.db #0x09	; 9
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x31	; 49	'1'
	.db #0x1a	; 26
	.db #0x54	; 84	'T'
	.db #0x1a	; 26
	.db #0x73	; 115	's'
	.db #0x1a	; 26
	.db #0x31	; 49	'1'
	.db #0x81	; 129
	.db #0x23	; 35
	.db #0x43	; 67	'C'
	.db #0x73	; 115	's'
	.db #0x93	; 147
	.db #0x35	; 53	'5'
	.db #0x85	; 133
	.db #0x07	; 7
	.db #0xb7	; 183
	.db #0x96	; 150
	.db #0x1b	; 27
	.db #0x21	; 33
	.db #0x1b	; 27
	.db #0x91	; 145
	.db #0x1b	; 27
	.db #0x42	; 66	'B'
	.db #0x1b	; 27
	.db #0x72	; 114	'r'
	.db #0x2a	; 42
	.db #0x54	; 84	'T'
	.db #0x1b	; 27
	.db #0x46	; 70	'F'
	.db #0x1b	; 27
	.db #0x76	; 118	'v'
	.db #0x1b	; 27
	.db #0x27	; 39
	.db #0x1b	; 27
	.db #0x97	; 151
	.db #0xc2	; 194
	.db #0x09	; 9
	.db #0x03	; 3
	.db #0x0b	; 11
	.db #0x34	; 52	'4'
	.db #0x29	; 41
	.db #0x51	; 81	'Q'
	.db #0x0b	; 11
	.db #0x20	; 32
	.db #0x90	; 144
	.db #0x41	; 65	'A'
	.db #0x71	; 113	'q'
	.db #0x53	; 83	'S'
	.db #0x63	; 99	'c'
	.db #0x45	; 69	'E'
	.db #0x75	; 117	'u'
	.db #0x26	; 38
	.db #0x96	; 150
	.db #0x8f	; 143
	.db #0xce	; 206
	.db #0x00	; 0
	.db #0xc0	; 192
	.db #0x01	; 1
	.db #0xaa	; 170
	.db #0x14	; 20
	.db #0x50	; 80	'P'
	.db #0x06	; 6
	.db #0x50	; 80	'P'
	.db #0x57	; 87	'W'
	.db #0xc0	; 192
	.db #0x09	; 9
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x25	; 37
	.db #0x0b	; 11
	.db #0x32	; 50	'2'
	.db #0x0b	; 11
	.db #0x51	; 81	'Q'
	.db #0x0b	; 11
	.db #0x13	; 19
	.db #0x33	; 51	'3'
	.db #0x53	; 83	'S'
	.db #0x63	; 99	'c'
	.db #0x83	; 131
	.db #0xa3	; 163
	.db #0x68	; 104	'h'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x97	; 151
	.db #0x87	; 135
	.db #0x00	; 0
	.db #0x2c	; 44
	.db #0x11	; 17
	.db #0x6c	; 108	'l'
	.db #0x41	; 65	'A'
	.db #0x2e	; 46
	.db #0x23	; 35
	.db #0x2e	; 46
	.db #0x93	; 147
	.db #0x2e	; 46
	.db #0x15	; 21
	.db #0x2e	; 46
	.db #0x85	; 133
	.db #0x2e	; 46
	.db #0x27	; 39
	.db #0xb2	; 178
	.db #0x09	; 9
	.db #0x97	; 151
	.db #0xb1	; 177
	.db #0x21	; 33
	.db #0x3a	; 58
	.db #0x45	; 69	'E'
	.db #0x18	; 24
	.db #0x63	; 99	'c'
	.db #0x3a	; 58
	.db #0x32	; 50	'2'
	.db #0x14	; 20
	.db #0x94	; 148
	.db #0x36	; 54	'6'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x8d	; 141
	.db #0x84	; 132
	.db #0x12	; 18
	.db #0x26	; 38
	.db #0x74	; 116	't'
	.db #0x26	; 38
	.db #0xa4	; 164
	.db #0x15	; 21
	.db #0x96	; 150
	.db #0x19	; 25
	.db #0x87	; 135
	.db #0x19	; 25
	.db #0xa7	; 167
	.db #0x15	; 21
	.db #0x68	; 104	'h'
	.db #0x15	; 21
	.db #0x78	; 120	'x'
	.db #0x28	; 40
	.db #0x09	; 9
	.db #0x28	; 40
	.db #0xa9	; 169
	.db #0x15	; 21
	.db #0x1a	; 26
	.db #0x54	; 84	'T'
	.db #0xbb	; 187
	.db #0x64	; 100	'd'
	.db #0x68	; 104	'h'
	.db #0x21	; 33
	.db #0x41	; 65	'A'
	.db #0x61	; 97	'a'
	.db #0x81	; 129
	.db #0x73	; 115	's'
	.db #0x93	; 147
	.db #0xb3	; 179
	.db #0x95	; 149
	.db #0x67	; 103	'g'
	.db #0xb7	; 183
	.db #0x8f	; 143
	.db #0x19	; 25
	.db #0xa5	; 165
	.db #0x19	; 25
	.db #0x57	; 87	'W'
	.db #0x4e	; 78	'N'
	.db #0x67	; 103	'g'
	.db #0x19	; 25
	.db #0xa7	; 167
	.db #0x19	; 25
	.db #0x28	; 40
	.db #0x19	; 25
	.db #0x48	; 72	'H'
	.db #0x1b	; 27
	.db #0x09	; 9
	.db #0x1b	; 27
	.db #0x19	; 25
	.db #0x19	; 25
	.db #0x39	; 57	'9'
	.db #0x2a	; 42
	.db #0xa9	; 169
	.db #0x32	; 50	'2'
	.db #0xab	; 171
	.db #0x60	; 96
	.db #0x5a	; 90	'Z'
	.db #0x74	; 116	't'
	.db #0x02	; 2
	.db #0x84	; 132
	.db #0xa4	; 164
	.db #0x56	; 86	'V'
	.db #0x76	; 118	'v'
	.db #0x86	; 134
	.db #0xa6	; 166
	.db #0x27	; 39
	.db #0x47	; 71	'G'
	.db #0x38	; 56	'8'
	.db #0xa8	; 168
	.db #0x84	; 132
	.db #0x19	; 25
	.db #0x11	; 17
	.db #0x19	; 25
	.db #0xa2	; 162
	.db #0x19	; 25
	.db #0x03	; 3
	.db #0x19	; 25
	.db #0x94	; 148
	.db #0x19	; 25
	.db #0x15	; 21
	.db #0x19	; 25
	.db #0xa6	; 166
	.db #0x19	; 25
	.db #0x07	; 7
	.db #0x32	; 50	'2'
	.db #0x09	; 9
	.db #0x13	; 19
	.db #0x59	; 89	'Y'
	.db #0x32	; 50	'2'
	.db #0x99	; 153
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x32	; 50	'2'
	.db #0x7b	; 123
	.db #0x85	; 133
	.db #0x1b	; 27
	.db #0x10	; 16
	.db #0xa1	; 161
	.db #0x02	; 2
	.db #0x93	; 147
	.db #0x14	; 20
	.db #0xa5	; 165
	.db #0x06	; 6
	.db #0x58	; 88	'X'
	.db #0x98	; 152
	.db #0xb8	; 184
	.db #0x86	; 134
	.db #0x19	; 25
	.db #0x04	; 4
	.db #0x19	; 25
	.db #0xb4	; 180
	.db #0x19	; 25
	.db #0x45	; 69	'E'
	.db #0x19	; 25
	.db #0x27	; 39
	.db #0x1d	; 29
	.db #0x47	; 71	'G'
	.db #0x19	; 25
	.db #0x67	; 103	'g'
	.db #0x28	; 40
	.db #0x09	; 9
	.db #0x1d	; 29
	.db #0x39	; 57	'9'
	.db #0x1d	; 29
	.db #0x59	; 89	'Y'
	.db #0x19	; 25
	.db #0x79	; 121	'y'
	.db #0x34	; 52	'4'
	.db #0x15	; 21
	.db #0x50	; 80	'P'
	.db #0x13	; 19
	.db #0x50	; 80	'P'
	.db #0x58	; 88	'X'
	.db #0x03	; 3
	.db #0xb3	; 179
	.db #0x44	; 68	'D'
	.db #0x26	; 38
	.db #0x46	; 70	'F'
	.db #0x66	; 102	'f'
	.db #0x18	; 24
	.db #0x38	; 56	'8'
	.db #0x58	; 88	'X'
	.db #0x78	; 120	'x'
	.db #0x87	; 135
	.db #0xce	; 206
	.db #0x00	; 0
	.db #0x2b	; 43
	.db #0x64	; 100	'd'
	.db #0x1b	; 27
	.db #0x68	; 104	'h'
	.db #0x13	; 19
	.db #0x78	; 120	'x'
	.db #0x13	; 19
	.db #0x88	; 136
	.db #0x2e	; 46
	.db #0xa8	; 168
	.db #0x28	; 40
	.db #0x09	; 9
	.db #0x1f	; 31
	.db #0x49	; 73	'I'
	.db #0x1f	; 31
	.db #0x59	; 89	'Y'
	.db #0x1b	; 27
	.db #0x69	; 105	'i'
	.db #0x72	; 114	'r'
	.db #0x04	; 4
	.db #0x70	; 112	'p'
	.db #0x7a	; 122	'z'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x85	; 133
	.db #0x17	; 23
	.db #0x57	; 87	'W'
	.db #0x67	; 103	'g'
	.db #0x77	; 119	'w'
	.db #0xa7	; 167
	.db #0x28	; 40
	.db #0x48	; 72	'H'
	.db #0x58	; 88	'X'
	.db #0x00	; 0
	.db #0x86	; 134
	.db #0x30	; 48	'0'
	.db #0x41	; 65	'A'
	.db #0x71	; 113	'q'
	.db #0x81	; 129
	.db #0x61	; 97	'a'
	.db #0xa1	; 161
	.db #0x51	; 81	'Q'
	.db #0x12	; 18
	.db #0x11	; 17
	.db #0x62	; 98	'b'
	.db #0x11	; 17
	.db #0x23	; 35
	.db #0x20	; 32
	.db #0x25	; 37
	.db #0x50	; 80	'P'
	.db #0x07	; 7
	.db #0x20	; 32
	.db #0xa7	; 167
	.db #0xce	; 206
	.db #0x09	; 9
	.db #0x02	; 2
	.db #0x05	; 5
	.db #0x00	; 0
	.db #0x6b	; 107	'k'
	.db #0x64	; 100	'd'
	.db #0x47	; 71	'G'
	.db #0x93	; 147
	.db #0x95	; 149
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x8e	; 142
	.db #0x82	; 130
	.db #0x22	; 34
	.db #0x22	; 34
	.db #0x13	; 19
	.db #0x7a	; 122	'z'
	.db #0x44	; 68	'D'
	.db #0x22	; 34
	.db #0x15	; 21
	.db #0x72	; 114	'r'
	.db #0x26	; 38
	.db #0x22	; 34
	.db #0x17	; 23
	.db #0x12	; 18
	.db #0x97	; 151
	.db #0x73	; 115	's'
	.db #0xb2	; 178
	.db #0x5e	; 94
	.db #0x09	; 9
	.db #0x52	; 82	'R'
	.db #0x79	; 121	'y'
	.db #0x15	; 21
	.db #0x6b	; 107	'k'
	.db #0x42	; 66	'B'
	.db #0x03	; 3
	.db #0x74	; 116	't'
	.db #0x37	; 55	'7'
	.db #0x73	; 115	's'
	.db #0x93	; 147
	.db #0x55	; 85	'U'
	.db #0x75	; 117	'u'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x87	; 135
	.db #0x24	; 36
	.db #0x91	; 145
	.db #0x3e	; 62
	.db #0x23	; 35
	.db #0x30	; 48	'0'
	.db #0x93	; 147
	.db #0x11	; 17
	.db #0x74	; 116	't'
	.db #0x40	; 64
	.db #0x56	; 86	'V'
	.db #0x15	; 21
	.db #0x17	; 23
	.db #0x6e	; 110	'n'
	.db #0x09	; 9
	.db #0x30	; 48	'0'
	.db #0x89	; 137
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x12	; 18
	.db #0x28	; 40
	.db #0x53	; 83	'S'
	.db #0x0b	; 11
	.db #0x82	; 130
	.db #0x15	; 21
	.db #0xa0	; 160
	.db #0x73	; 115	's'
	.db #0x15	; 21
	.db #0x75	; 117	'u'
	.db #0x77	; 119	'w'
	.db #0xb8	; 184
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x86	; 134
	.db #0xa6	; 166
	.db #0x00	; 0
	.db #0x26	; 38
	.db #0x91	; 145
	.db #0x3e	; 62
	.db #0x33	; 51	'3'
	.db #0x3a	; 58
	.db #0x93	; 147
	.db #0x3a	; 58
	.db #0x24	; 36
	.db #0x4a	; 74	'J'
	.db #0x16	; 22
	.db #0x2e	; 46
	.db #0x86	; 134
	.db #0x2a	; 42
	.db #0x97	; 151
	.db #0x6e	; 110	'n'
	.db #0x09	; 9
	.db #0x3a	; 58
	.db #0x99	; 153
	.db #0x14	; 20
	.db #0x04	; 4
	.db #0x74	; 116	't'
	.db #0x04	; 4
	.db #0x82	; 130
	.db #0x18	; 24
	.db #0xa0	; 160
	.db #0x15	; 21
	.db #0xb8	; 184
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xc3	; 195
	.db #0xce	; 206
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x52	; 82	'R'
	.db #0x40	; 64
	.db #0x14	; 20
	.db #0x40	; 64
	.db #0x74	; 116	't'
	.db #0x1d	; 29
	.db #0x05	; 5
	.db #0x1d	; 29
	.db #0x07	; 7
	.db #0x40	; 64
	.db #0x47	; 71	'G'
	.db #0x1d	; 29
	.db #0xb7	; 183
	.db #0xce	; 206
	.db #0x09	; 9
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x0b	; 11
	.db #0x33	; 51	'3'
	.db #0x17	; 23
	.db #0x85	; 133
	.db #0x28	; 40
	.db #0x51	; 81	'Q'
	.db #0x61	; 97	'a'
	.db #0x33	; 51	'3'
	.db #0x83	; 131
	.db #0x06	; 6
	.db #0x56	; 86	'V'
	.db #0x66	; 102	'f'
	.db #0xb6	; 182
	.db #0x48	; 72	'H'
	.db #0x78	; 120	'x'
	.db #0xc5	; 197
	.db #0x6c	; 108	'l'
	.db #0x31	; 49	'1'
	.db #0x1d	; 29
	.db #0x22	; 34
	.db #0x1d	; 29
	.db #0x92	; 146
	.db #0x3d	; 61
	.db #0x13	; 19
	.db #0x15	; 21
	.db #0x54	; 84	'T'
	.db #0x1d	; 29
	.db #0x26	; 38
	.db #0x1d	; 29
	.db #0x96	; 150
	.db #0x6c	; 108	'l'
	.db #0x37	; 55	'7'
	.db #0x1d	; 29
	.db #0xb8	; 184
	.db #0xc4	; 196
	.db #0x09	; 9
	.db #0x30	; 48	'0'
	.db #0x57	; 87	'W'
	.db #0x50	; 80	'P'
	.db #0x68	; 104	'h'
	.db #0x60	; 96
	.db #0x38	; 56	'8'
	.db #0x32	; 50	'2'
	.db #0x23	; 35
	.db #0x33	; 51	'3'
	.db #0x93	; 147
	.db #0x04	; 4
	.db #0x16	; 22
	.db #0xa6	; 166
	.db #0x27	; 39
	.db #0x97	; 151
	.db #0x00	; 0
	.db #0xd6	; 214
	.db #0x1d	; 29
	.db #0x00	; 0
	.db #0xbc	; 188
	.db #0x10	; 16
	.db #0x3a	; 58
	.db #0x04	; 4
	.db #0x2c	; 44
	.db #0x54	; 84	'T'
	.db #0x3a	; 58
	.db #0x94	; 148
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x1d	; 29
	.db #0x75	; 117	'u'
	.db #0x1d	; 29
	.db #0x37	; 55	'7'
	.db #0x1d	; 29
	.db #0x87	; 135
	.db #0xcc	; 204
	.db #0x09	; 9
	.db #0x33	; 51	'3'
	.db #0x1a	; 26
	.db #0x61	; 97	'a'
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x21	; 33
	.db #0x41	; 65	'A'
	.db #0x71	; 113	'q'
	.db #0x91	; 145
	.db #0xb3	; 179
	.db #0x55	; 85	'U'
	.db #0x65	; 101	'e'
	.db #0x46	; 70	'F'
	.db #0x76	; 118	'v'
	.db #0x00	; 0
	.db #0xcc	; 204
	.db #0xc2	; 194
	.db #0x00	; 0
	.db #0x58	; 88	'X'
	.db #0x04	; 4
	.db #0x58	; 88	'X'
	.db #0x74	; 116	't'
	.db #0x19	; 25
	.db #0x66	; 102	'f'
	.db #0x19	; 25
	.db #0x48	; 72	'H'
	.db #0x13	; 19
	.db #0x58	; 88	'X'
	.db #0x19	; 25
	.db #0x68	; 104	'h'
	.db #0x19	; 25
	.db #0x78	; 120	'x'
	.db #0xc8	; 200
	.db #0x09	; 9
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x34	; 52	'4'
	.db #0x1a	; 26
	.db #0x61	; 97	'a'
	.db #0x15	; 21
	.db #0x72	; 114	'r'
	.db #0x0b	; 11
	.db #0x11	; 17
	.db #0x21	; 33
	.db #0x51	; 81	'Q'
	.db #0xa1	; 161
	.db #0x15	; 21
	.db #0x25	; 37
	.db #0x35	; 53	'5'
	.db #0x85	; 133
	.db #0x95	; 149
	.db #0xa5	; 165
	.db #0xcf	; 207
	.db #0xc0	; 192
	.db #0x00	; 0
	.db #0x21	; 33
	.db #0x04	; 4
	.db #0x21	; 33
	.db #0x44	; 68	'D'
	.db #0x31	; 49	'1'
	.db #0xb4	; 180
	.db #0x40	; 64
	.db #0x06	; 6
	.db #0x10	; 16
	.db #0x96	; 150
	.db #0x54	; 84	'T'
	.db #0x77	; 119	'w'
	.db #0xc0	; 192
	.db #0x09	; 9
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x21	; 33
	.db #0x1a	; 26
	.db #0x52	; 82	'R'
	.db #0x58	; 88	'X'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x11	; 17
	.db #0x51	; 81	'Q'
	.db #0x61	; 97	'a'
	.db #0xa1	; 161
	.db #0x15	; 21
	.db #0x25	; 37
	.db #0x35	; 53	'5'
	.db #0xa5	; 165
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xce	; 206
	.db #0x13	; 19
	.db #0x14	; 20
	.db #0x11	; 17
	.db #0x64	; 100	'd'
	.db #0x11	; 17
	.db #0x55	; 85	'U'
	.db #0x11	; 17
	.db #0x75	; 117	'u'
	.db #0x11	; 17
	.db #0xa6	; 166
	.db #0x11	; 17
	.db #0x47	; 71	'G'
	.db #0x11	; 17
	.db #0x97	; 151
	.db #0x1d	; 29
	.db #0x38	; 56	'8'
	.db #0x11	; 17
	.db #0x68	; 104	'h'
	.db #0x2e	; 46
	.db #0x09	; 9
	.db #0x31	; 49	'1'
	.db #0x0b	; 11
	.db #0x65	; 101	'e'
	.db #0x09	; 9
	.db #0x72	; 114	'r'
	.db #0x58	; 88	'X'
	.db #0x82	; 130
	.db #0x13	; 19
	.db #0x54	; 84	'T'
	.db #0x74	; 116	't'
	.db #0xb4	; 180
	.db #0x35	; 53	'5'
	.db #0x95	; 149
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xcd	; 205
	.db #0x17	; 23
	.db #0x31	; 49	'1'
	.db #0x17	; 23
	.db #0x81	; 129
	.db #0x2c	; 44
	.db #0x03	; 3
	.db #0x17	; 23
	.db #0x13	; 19
	.db #0x17	; 23
	.db #0xa3	; 163
	.db #0x17	; 23
	.db #0x35	; 53	'5'
	.db #0x17	; 23
	.db #0x85	; 133
	.db #0x17	; 23
	.db #0x07	; 7
	.db #0x27	; 39
	.db #0xb7	; 183
	.db #0x3c	; 60
	.db #0x09	; 9
	.db #0x01	; 1
	.db #0x0b	; 11
	.db #0x45	; 69	'E'
	.db #0x0b	; 11
	.db #0x61	; 97	'a'
	.db #0x0b	; 11
	.db #0x30	; 48	'0'
	.db #0x80	; 128
	.db #0x02	; 2
	.db #0x62	; 98	'b'
	.db #0xb2	; 178
	.db #0x34	; 52	'4'
	.db #0x84	; 132
	.db #0x06	; 6
	.db #0xb6	; 182
	.db #0x00	; 0
	.db #0xd6	; 214
	.db #0x32	; 50	'2'
	.db #0x91	; 145
	.db #0x1d	; 29
	.db #0x42	; 66	'B'
	.db #0x1d	; 29
	.db #0x72	; 114	'r'
	.db #0x1d	; 29
	.db #0x03	; 3
	.db #0x1d	; 29
	.db #0xb3	; 179
	.db #0x1d	; 29
	.db #0x15	; 21
	.db #0x1d	; 29
	.db #0xa5	; 165
	.db #0x20	; 32
	.db #0x57	; 87	'W'
	.db #0x22	; 34
	.db #0x09	; 9
	.db #0x32	; 50	'2'
	.db #0x99	; 153
	.db #0x33	; 51	'3'
	.db #0x1a	; 26
	.db #0x53	; 83	'S'
	.db #0x29	; 41
	.db #0x83	; 131
	.db #0x2c	; 44
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x90	; 144
	.db #0xb0	; 176
	.db #0x33	; 51	'3'
	.db #0x83	; 131
	.db #0x36	; 54	'6'
	.db #0x86	; 134
	.db #0x18	; 24
	.db #0xb8	; 184
	.db #0xc6	; 198
	.db #0x17	; 23
	.db #0x21	; 33
	.db #0x57	; 87	'W'
	.db #0x41	; 65	'A'
	.db #0x57	; 87	'W'
	.db #0x61	; 97	'a'
	.db #0x17	; 23
	.db #0x81	; 129
	.db #0x17	; 23
	.db #0xb3	; 179
	.db #0x17	; 23
	.db #0x95	; 149
	.db #0x17	; 23
	.db #0x87	; 135
	.db #0x17	; 23
	.db #0x58	; 88	'X'
	.db #0x26	; 38
	.db #0x09	; 9
	.db #0x36	; 54	'6'
	.db #0x99	; 153
	.db #0x02	; 2
	.db #0x1a	; 26
	.db #0x20	; 32
	.db #0x7b	; 123
	.db #0x85	; 133
	.db #0x24	; 36
	.db #0x51	; 81	'Q'
	.db #0x52	; 82	'R'
	.db #0x72	; 114	'r'
	.db #0xb2	; 178
	.db #0x53	; 83	'S'
	.db #0x93	; 147
	.db #0x54	; 84	'T'
	.db #0x55	; 85	'U'
	.db #0x56	; 86	'V'
	.db #0x86	; 134
;../../sdk/include/evo_ts.h:13: void fade_to_black(void)
;	---------------------------------
; Function fade_to_black
; ---------------------------------
_fade_to_black::
;../../sdk/include/evo_ts.h:16: for (a = 16; a > 0; a--)
	ld	c, #0x10
00102$:
;../../sdk/include/evo_ts.h:18: pal_bright(a - 1);
	ld	a, c
	dec	a
	push	bc
	push	af
	inc	sp
	call	_pal_bright
	inc	sp
	call	_vsync
	pop	bc
;../../sdk/include/evo_ts.h:16: for (a = 16; a > 0; a--)
	dec	c
	jr	NZ, 00102$
;../../sdk/include/evo_ts.h:21: }
	ret
_white_pal:
	.dw #0x6318
	.dw #0x6318
	.dw #0x6318
	.dw #0x6318
	.dw #0x6318
	.dw #0x6318
	.dw #0x6318
	.dw #0x6318
	.dw #0x6318
	.dw #0x6318
	.dw #0x6318
	.dw #0x6318
	.dw #0x6318
	.dw #0x6318
	.dw #0x6318
	.dw #0x6318
;../../sdk/include/evo_ts.h:23: void fade_from_black(void)
;	---------------------------------
; Function fade_from_black
; ---------------------------------
_fade_from_black::
;../../sdk/include/evo_ts.h:26: for(a = 0;a <= 15; a++)
	ld	b, #0x00
00102$:
;../../sdk/include/evo_ts.h:28: pal_bright(a);
	push	bc
	push	bc
	inc	sp
	call	_pal_bright
	inc	sp
	call	_vsync
	pop	bc
;../../sdk/include/evo_ts.h:26: for(a = 0;a <= 15; a++)
	inc	b
	ld	a, #0x0f
	sub	a, b
	jr	NC, 00102$
;../../sdk/include/evo_ts.h:31: }
	ret
;../../sdk/include/evo_ts.h:35: void init_vdp(void)
;	---------------------------------
; Function init_vdp
; ---------------------------------
_init_vdp::
;../../sdk/include/evo_ts.h:38: }
	ret
;../../sdk/include/evo_ts.h:40: void screen_enable(u16 enable)
;	---------------------------------
; Function screen_enable
; ---------------------------------
_screen_enable::
;../../sdk/include/evo_ts.h:43: }
	ret
;../../sdk/include/evo_ts.h:45: void unpack_screen(const u8 id,u8 pal)
;	---------------------------------
; Function unpack_screen
; ---------------------------------
_unpack_screen::
;../../sdk/include/evo_ts.h:47: draw_image(id);
	ld	hl, #2
	add	hl, sp
	ld	a, (hl)
	push	af
	inc	sp
	call	_draw_image
	inc	sp
;../../sdk/include/evo_ts.h:48: pal_select(pal);
	ld	hl, #3
	add	hl, sp
	ld	a, (hl)
	push	af
	inc	sp
	call	_pal_select
	inc	sp
;../../sdk/include/evo_ts.h:49: swap_screen();
	call	_swap_screen
;../../sdk/include/evo_ts.h:50: fade_from_black();
;../../sdk/include/evo_ts.h:51: }
	jp	_fade_from_black
;../../sdk/include/evo_ts.h:54: void fade_screen(u16 out)
;	---------------------------------
; Function fade_screen
; ---------------------------------
_fade_screen::
;../../sdk/include/evo_ts.h:58: if(out)
	ld	iy, #2
	add	iy, sp
	ld	a, 1 (iy)
	or	a, 0 (iy)
	jp	Z,_fade_from_black
;../../sdk/include/evo_ts.h:60: fade_to_black();
;../../sdk/include/evo_ts.h:64: fade_from_black();
;../../sdk/include/evo_ts.h:66: }
	jp	_fade_to_black
;main.c:14: void make_black()
;	---------------------------------
; Function make_black
; ---------------------------------
_make_black::
;main.c:18: for(i=0;i<24;i++)
	ld	bc, #0x0000
;main.c:20: for(j=0;j<32;j++) sp_AttrSet(j,i,0);
00109$:
	ld	de, #0x0000
00103$:
	push	bc
	push	de
	xor	a, a
	push	af
	inc	sp
	push	bc
	push	de
	call	_sp_AttrSet
	pop	af
	pop	af
	inc	sp
	pop	de
	pop	bc
	inc	de
	ld	a, e
	sub	a, #0x20
	ld	a, d
	rla
	ccf
	rra
	sbc	a, #0x80
	jr	C, 00103$
;main.c:18: for(i=0;i<24;i++)
	inc	bc
	ld	a, c
	sub	a, #0x18
	ld	a, b
	rla
	ccf
	rra
	sbc	a, #0x80
	jr	C, 00109$
;main.c:22: }
	ret
;main.c:24: void fade_out ()
;	---------------------------------
; Function fade_out
; ---------------------------------
_fade_out::
;main.c:26: fade_screen(TRUE);
	ld	hl, #0x0001
	push	hl
	call	_fade_screen
	pop	af
;main.c:27: make_black();
;main.c:28: }
	jp	_make_black
;main.c:30: void wait_for_a_key(i16 timer)
;	---------------------------------
; Function wait_for_a_key
; ---------------------------------
_wait_for_a_key::
;main.c:32: i8 res = 1;
	ld	c, #0x01
;main.c:34: if (timer<0)
	ld	hl, #2 + 1
	add	hl, sp
	bit	7, (hl)
	jr	Z, 00115$
;main.c:36: timer=-timer;
	ld	hl, #2
	add	hl, sp
	xor	a, a
	sub	a, (hl)
	ld	(hl), a
	ld	a, #0x00
	inc	hl
	sbc	a, (hl)
	ld	(hl), a
;main.c:37: res=2;
	ld	c, #0x02
;main.c:40: while(timer>0)
00115$:
	dec	c
	ld	a, #0x01
	jr	Z, 00133$
	xor	a, a
00133$:
	ld	c, a
	pop	de
	pop	hl
	push	hl
	push	de
00106$:
	xor	a, a
	cp	a, l
	sbc	a, h
	jp	PO, 00134$
	xor	a, #0x80
00134$:
	ret	P
;main.c:42: sp_UpdateNow();
	push	hl
	push	bc
	call	_sp_UpdateNow
	call	_sp_GetKey
	ld	a, l
	pop	bc
	pop	hl
	or	a, a
	jr	Z, 00104$
	ld	a, c
	or	a, a
	ret	NZ
;main.c:47: break;
00104$:
;main.c:50: timer--;
	dec	hl
;main.c:52: }
	jr	00106$
;main.c:54: void main (void)
;	---------------------------------
; Function main
; ---------------------------------
_main::
;main.c:56: spritesClipValues.row_coord = 2;
	ld	hl, #_spritesClipValues
	ld	(hl), #0x02
;main.c:57: spritesClipValues.col_coord = 4;
	ld	hl, #(_spritesClipValues + 0x0001)
	ld	(hl), #0x04
;main.c:58: spritesClipValues.height = 20;
	ld	hl, #(_spritesClipValues + 0x0002)
	ld	(hl), #0x14
;main.c:59: spritesClipValues.width = 24;
	ld	hl, #(_spritesClipValues + 0x0003)
	ld	(hl), #0x18
;main.c:60: spritesClip = &spritesClipValues;
	ld	hl, #_spritesClipValues
	ld	(_spritesClip), hl
;main.c:61: sprites_clip(1);
	ld	a, #0x01
	push	af
	inc	sp
	call	_sprites_clip
	inc	sp
;main.c:62: sprites_start();
	call	_sprites_start
;main.c:64: pal_bright(0);
	xor	a, a
	push	af
	inc	sp
	call	_pal_bright
	inc	sp
;main.c:65: unpack_screen(IMG_MOJON, PAL_MOJON);
	ld	a, #0x02
	push	af
	inc	sp
	xor	a, a
	push	af
	inc	sp
	call	_unpack_screen
	pop	af
;main.c:66: wyz_play_sound(7, CANAL_FX);
	ld	de, #0x0107
	push	de
	call	_wyz_play_sound
;main.c:67: wait_for_a_key(200);
	ld	hl, #0x00c8
	ex	(sp),hl
	call	_wait_for_a_key
	pop	af
;main.c:68: fade_out();
	call	_fade_out
;main.c:69: unpack_screen(IMG_CREDITS, PAL_CREDITS);
	ld	de, #0x0301
	push	de
	call	_unpack_screen
	pop	af
;main.c:70: wyz_play_sound (7, CANAL_FX);
	ld	de, #0x0107
	push	de
	call	_wyz_play_sound
;main.c:71: wait_for_a_key(500);
	ld	hl, #0x01f4
	ex	(sp),hl
	call	_wait_for_a_key
	pop	af
;main.c:72: fade_out();
;main.c:166: }
	jp	_fade_out
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
