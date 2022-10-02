#include "../../include/sprinter.h"
#include "startup.h"	//���� ���� ������������ ������������� ��� ���������� startup.asm

void memset(void* m,u8 b,u16 len) __naked
{
__asm
	ld hl,#2
	add hl,sp
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld a,(hl)
	inc hl
	ld c,(hl)
	inc hl
	ld b,(hl)

	ex de,hl
	ld d,h
	ld e,l
	inc de
	dec bc
	ld (hl),a
	jp _FAST_LDIR
__endasm;
}



void memcpy(void* d,void* s,u16 len) __naked
{
__asm
	ld hl,#2
	add hl,sp
	ld e,(hl)
	inc hl
	ld d,(hl)
	push de
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld c,(hl)
	inc hl
	ld b,(hl)
	ex de,hl
	pop de
	jp _FAST_LDIR
__endasm;
}



void border(u8 n) __naked
{
__asm
	ld hl,#2
	add hl,sp
	ld a,(hl)
	ld (_BORDERCOL),a
	ld c,a
	and #7
	out (0xfe),a
	ret
__endasm;
}

/*void draw_warp(u8 warp) __naked
{
__asm
	ld hl,#2
	add hl,sp
	ld a,(hl)
	and #0x0f
	cp #0x0f
	jr nz,1$
	dec a
1$:	call _WARP
	ret
__endasm;
}*/

/*void draw_blink(u8 val) __naked
{
__asm
	ld hl,#2
	add hl,sp
	ld a,(hl)
	jp _BLINK
__endasm;
}*/

void vsync(void) __naked
{
__asm
	jp _VSYNC
__endasm;
}



u8 joystick(void) __naked
{
__asm
	jp _JOYSTICK
__endasm;
}



void keyboard(u8* keys) __naked
{
__asm
	ld hl,#2
	add hl,sp
	ld e,(hl)
	inc hl
	ld d,(hl)
	jp _KEYBOARD
__endasm;
}

/*
u8 mouse_pos(u8* x,u8* y) __naked
{
__asm
	ld hl,#2
	add hl,sp
	ld c,(hl)
	inc hl
	ld b,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	ld a,(_MOUSE_X)
	ld (bc),a
	ld a,(_MOUSE_Y)
	ld (de),a
	ld a,(_MOUSE_BTN)
	ld l,a
	ret
__endasm;
}*/


/*
void mouse_set(u8 x,u8 y) __naked
{
__asm
	ld hl,#2
	add hl,sp
	ld a,(hl)
	ld (_MOUSE_X),a
	inc hl
	ld a,(hl)
	ld (_MOUSE_Y),a
	jp _MOUSE_APPLY_CLIP
__endasm;
}*/


/*
void mouse_clip(u8 xmin,u8 ymin,u8 xmax,u8 ymax) __naked
{
__asm
	ld hl,#2
	add hl,sp
	ld a,(hl)
	ld (_MOUSE_CX1),a
	inc hl
	ld a,(hl)
	ld (_MOUSE_CY1),a
	inc hl
	ld a,(hl)
	ld (_MOUSE_CX2),a
	inc hl
	ld a,(hl)
	ld (_MOUSE_CY2),a
	jp _MOUSE_APPLY_CLIP
__endasm;
}*/


/*
u8 mouse_delta(i8* x,i8* y) __naked
{
__asm
	ld hl,#2
	add hl,sp
	ld c,(hl)
	inc hl
	ld b,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	ld a,(_MOUSE_DX)
	ld (bc),a
	ld a,(_MOUSE_DY)
	ld (bc),a
	ld a,(_MOUSE_BTN)
	ld l,a
	ret
__endasm;
}*/


/*
void sfx_play(u8 sfx,i8 vol) __naked
{
__asm
	ld hl,#2
	add hl,sp
	ld b,(hl)
	inc hl
	ld c,(hl)
	jp _SFX_PLAY
__endasm;
}
*/

/*
void sfx_stop(void) __naked
{
__asm
	jp _SFX_STOP
__endasm;
}
*/

/*
void music_play(u8 mus) __naked
{
__asm
	ld hl,#2
	add hl,sp
	ld a,(hl)
	jp _MUSIC_PLAY
__endasm;
}*/


/*
void music_stop(void) __naked
{
__asm
	jp _MUSIC_STOP
__endasm;
}
*/

/*
void sample_play(u8 sample) __naked
{
__asm
	ld hl,#2
	add hl,sp
	ld l,(hl)
	jp _SAMPLE_PLAY
__endasm;
}
*/


u16 rand16(void) __naked
{
__asm
	ld hl,(1$)
	push hl
	srl h
	rr l
	ex de,hl
	ld hl,(2$)
	add hl,de
	ld (2$),hl
	ld a,l
	xor #15
	ld l,a
	ex de,hl
	pop hl
	sbc hl,de
	ld (1$),hl
	ret

1$:	.dw 1
2$:	.dw 5

__endasm;
}


/*
void pal_clear(void) __naked
{
__asm
	ld hl,#_PALETTE
	ld bc,#0x1000
1$:
	ld (hl),c
	inc l
	djnz 1$
	ld a,h
	ld (_PALCHANGE),a
	ret
__endasm;
}*/



void pal_select(u8 id) __naked
{
__asm
	ld hl,#2
	add hl,sp
	ld a,(hl)
	jp _PAL_SELECT
__endasm;
}



void pal_bright(u8 bright) __naked
{
__asm
	ld hl,#2
	add hl,sp
	ld a,(hl)
	jp _PAL_BRIGHT
__endasm;
}

void pal_bright16(u8 subpal, u8 bright) __naked
{
__asm
	ld hl,#2
	add hl,sp
	ld a,(hl)
	inc hl
	and #3
	ld c,a
	ld a,(hl)
	jp _PAL_BRIGHT16
__endasm;
}

/*
void pal_col(u8 id,u8 col) __naked
{
__asm
	ld hl,#2
	add hl,sp
	ld a,(hl)
	inc hl
	ld c,(hl)
	ld hl,#_PALETTE
	add a,l
	ld l,a
	ld a,c
	and #63
	ld (hl),a
	ld a,h
	ld (_PALCHANGE),a
	ret
__endasm;
}*/



void pal_copy(u8 start, u8 count, u8* pal) __naked
{
__asm
	ld hl,#2
	add hl,sp
//	ld a,(hl)
//	inc hl
//	ld e,(hl)
//	inc hl
//	ld d,(hl)
//	jp _PAL_COPY
	ld b,(hl) // start
	inc hl
	ld c,(hl) // count
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	ld a,b
	cp #64
	jr nc,2$
	add a,c
	cp #65
	jr nc,2$
	ld a,b
	add a,a
	add a,b
	ld hl,#_PALETTE
	add a,l
	ld l,a
	jr nc,1$
	inc h
1$:	ld a,c
	add a,a
	add a,c
	ld c,a
	ld b,#0
	ldir
2$:
	ret
__endasm;
}



void pal_custom(u8 start, u8 count, u8* pal) __naked
{
__asm
	ld hl,#2
	add hl,sp
//	ld a,(hl)
//	inc hl
//	ld h,(hl)
//	ld l,a
//	ld de,#_PALETTE
//	ld b,#16
//1$:
//	ld a,(hl)
//	and #63
//	ld (de),a
//	inc hl
//	inc e
//	djnz 1$
//	ld a,d
//	ld (_PALCHANGE),a
	ld b,(hl) // start
	inc hl
	ld c,(hl) // count
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	ld a,b
	cp #64
	jr nc,2$
	add a,c
	cp #65
	jr nc,2$
	ld a,b
	add a,a
	add a,b
	ld hl,#_PALETTE
	add a,l
	ld l,a
	jr nc,1$
	inc h
1$:	ld a,c
	add a,a
	add a,c
	ld c,a
	ld b,#0
	ex de,hl
	ldir
	ld a,d
	ld (_PALCHANGE),a	
2$:	
	ret
__endasm;
}



void draw_tile(u8 x,u8 y,u16 tile) __naked
{
__asm
	ld hl,#2
	add hl,sp
	ld c,(hl)
	inc hl
	ld b,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	jp _DRAW_TILE
__endasm;
}


/*
void draw_tile_key(u8 x,u8 y,u16 tile) __naked
{
__asm
	ld hl,#2
	add hl,sp
	ld c,(hl)
	inc hl
	ld b,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	jp _DRAW_TILE_KEY
__endasm;
}
*/


void draw_image(u8 x) __naked
{
__asm
	ld hl,#2
	add hl,sp
	ld a,(hl)
	jp _DRAW_IMAGE
__endasm;
}

/*
void draw_stile(u8 x,u8 y,u16 tile) __naked
{
__asm
	ld hl,#2
	add hl,sp
	ld c,(hl)
	sla c
	sla c
	inc hl
	ld b,(hl)
	sla b
	sla b
	sla b
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	ld a,d
	add a,a
	add a,d
	ld d,a	
	jp _DRAW_S_TILE
__endasm;
}
*/

void clear_screen(u8 color) __naked
{
__asm
	ld hl,#2
	add hl,sp
	ld a,(hl)
	jp _CLEAR_SCREEN
__endasm;
}



void swap_screen(void) __naked
{
__asm
	jp _SWAP_SCREEN
__endasm;
}


/*
void select_image(u8 id) __naked
{
__asm
	ld hl,#2
	add hl,sp
	ld l,(hl)
	jp _SELECT_IMAGE
__endasm;
}*/

/*
void color_key(u8 col) __naked
{
__asm
	ld hl,#2
	add hl,sp
	ld c,(hl)
	jp _COLOR_KEY
__endasm;
}
*/

/*
void set_sprite(u8 id,u8 x,u8 y,u16 spr) __naked
{
__asm
	ld hl,#2
	add hl,sp
	ld a,(hl)	;id
	inc hl
	ld c,(hl)	;x
	inc hl
	ld b,(hl)	;y
	inc hl
	ld e,(hl)	;sprl
	inc hl
	ld d,(hl)	;sprh
	srl c
	rl e
	rl d
	push af
	ld a,#16
	add a,c
	ld c,a
	pop af
	add a,a
	add a,a
	ld l,a
	ld h,#_SPRQUEUE/256

	ld a,d		;�������� ������ �������
	cp #255
	jr z,1$
	add a,a
	add a,d
	ld d,a
1$:
	ld a,(_SCREENACTIVE)
	and #2
	jr nz,2$
	inc h
2$:
	ld a,b
	cp #176
	jr c,3$
	ld b,#176
3$:	ld a,(_CLIP)
	and a
	jr z,7$	
	ld a,c
	cp #24
	jr c,11$
	cp #136
	jr c,7$
11$:	ld c,#24
7$:	ld (hl),d
	inc l
	ld (hl),e
	inc l
	ld (hl),b
	inc l
	ld (hl),c
	inc d
	ret z
	ld a,(_CLIP)
	and a
	jr z,6$	
	ld hl,(_VCLIPPTR)
	ld a,c
	cp #32
	jr c,8$
	cp #120
	jr c,10$
	ld d,#128
	jr 9$
8$:	ld d,#23
9$:	ld (hl),#0
	inc l
	ld (hl),#0
	inc l
	ld (hl),b
	inc l
	ld (hl),d
	inc l
	ld (_VCLIPPTR),hl
10$: ld a,b
	cp #16
	jr c,4$
	cp #161
	jr c,6$
	ld b,#176
	jr 5$
4$: ld b,#0
5$:	
	ld (hl),#0
	inc l
	ld (hl),#0
	inc l
	ld (hl),b
	inc l
	ld (hl),c
	inc l
	ld (_VCLIPPTR),hl
6$:	
	ret
__endasm;
}
*/

void add_sprite(u8 x,u8 y,u16 spr) __naked
{
__asm
	ld hl,#2
	add hl,sp
	ld c,(hl)	;x
	inc hl
	ld b,(hl)	;y
	inc hl
	ld e,(hl)	;sprl
	inc hl
	ld d,(hl)	;sprh
	//srl c
	//rl e
	//rl d
	//ld a,#16
	//add a,c
	//ld c,a
	ld a,(_SPTR)
//	add a,a
//	add a,a
	ld l,a
	ld h,#_SPRQUEUE/256

	//ld a,d		;�������� ������ �������
	//cp #255
	//jr z,1$
	//add a,a
	//add a,d
	//ld d,a
1$:
	ld a,(_SCREENACTIVE)
	and #1
	jr nz,2$
	inc h
2$:
	ld a,b
	cp #176
	jr c,3$
	ld b,#176
3$:	ld a,(_CLIP)
	and a
	jr z,7$	
	ld a,c
	cp #16
	jr c,11$
	cp #224
	jr c,7$
11$:	ld c,#16
7$:	ld (hl),d
	inc l
	ld (hl),e
	inc l
	ld (hl),b
	inc l
	ld (hl),c
	inc l
	ld a,l
	ld (_SPTR),a
	inc d
	ret z
	ld hl,(_VCLIPPTR)
	ld a,(_CLIP)
	and a
	jr z,6$	
	ld a,c
	cp #32
	jr c,8$
	cp #209
	jr c,10$
	ld d,#224
	jr 9$
8$:	ld d,#16
9$:	ld (hl),#0
	inc l
	ld (hl),#0
	inc l
	ld (hl),b
	inc l
	ld (hl),d
	inc l
	ld (_VCLIPPTR),hl
10$: ld a,b
	cp #16
	jr c,4$
	cp #161
	jr c,6$
	ld b,#176
	jr 5$
4$: ld b,#0
5$:	
	ld (hl),#0
	inc l
	ld (hl),#0
	inc l
	ld (hl),b
	inc l
	ld (hl),c
	inc l
	ld (_VCLIPPTR),hl
6$:	ld (hl),#255
	ret
__endasm;
}

void end_sprite(void) __naked
{
__asm
	ld a,(_SPTR)
//	add a,a
//	add a,a
	ld l,a
	ld h,#_SPRQUEUE/256
1$:
	ld a,(_SCREENACTIVE)
	and #1
	jr nz,2$
	inc h
2$:	ld (hl),#255
	ret
__endasm;
}

void sprites_clip(u8 clip) __naked
{
__asm
	ld hl,#2
	add hl,sp
	ld a,(hl)
	ld (_CLIP),a	
	ret
__endasm;
}


void sprites_start(void) __naked
{
__asm
	jp _SPRITES_START
__endasm;
}



void sprites_stop(void) __naked
{
__asm
	jp _SPRITES_STOP
__endasm;
}



u32 time(void) __naked
{
__asm
	ld hl,#_TIME+3
	ld d,(hl)
	dec hl
	ld e,(hl)
	dec hl
	ld a,(hl)
	dec hl
	ld l,(hl)
	ld h,a
	ret
__endasm;
}



void delay(u16 time) __naked
{
__asm
	ld hl,#2
	add hl,sp
	ld c,(hl)
	inc hl
	ld b,(hl)
	ld a,b
	or c
	ret z
1$:
	push bc
	call _VSYNC
	pop bc
	dec bc
	ld a,b
	or c
	jr nz,1$
	ret
__endasm;
}

void wyz_play_music (unsigned char song_number) __naked
{
__asm
	ld hl,#2
	add hl,sp
	ld a,(hl)	
	jp _WYZ_PLAY_MUSIC
__endasm;	
}

void wyz_play_sound (unsigned char fx_number, unsigned char fx_channel) __naked
{
__asm
	ld hl,#2
	add hl,sp
	ld b,(hl)
	inc hl
	ld c,(hl)
	jp _WYZ_PLAY_SOUND

__endasm;
}

void wyz_stop_sound (void) __naked
{
__asm
	jp _WYZ_STOP_SOUND
__endasm;
}

void fm_sound_on (void) __naked
{
__asm
	ld a,(_SNDFLAG)
	or #0x10
	ld (_SNDFLAG),a
	ret
__endasm;
}

u8 tfm_stat(void) __naked
{
__asm
	ld a,(_TFMFLAG)
	ld l,a
	ret
__endasm;	
}

void quit(void) __naked
{
__asm
	jp _QUIT
__endasm;
}