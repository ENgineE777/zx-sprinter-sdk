;	export _sfx_play
;	export _sfx_stop
;	export _music_play
;	export _music_stop
;	export _sample_play

	export _wyz_play_sound
	export _wyz_play_music
	export _wyz_stop_sound 


;���������� ����� �� ��������� ����
;a=0 ��� 1

reset_ay
	push af
	or #fe
	di
	ld bc,#fffd
	out (c),a

	xor a
	ld l,a
.l0
	ld b,#ff
	out (c),a
	ld b,#bf
	out (c),l
	inc a
	cp 14
	jr nz,.l0
	ei
	pop af
	ret



;;������ ��������� �������
;
;_sfx_play
;	push bc
;	ld a,SND_PAGE
;	call setSlot1
;	pop bc
;	ld a,b
;	call AFX_PLAY
;	ld a,CC_PAGE1
;	jp setSlot1
;
;
;
;;������� �������� ��������
;
;_sfx_stop
;	xor a
;	jp reset_ay
;


;������ ������

;_music_play
;	push ix
;	push iy
;	push af
;	ld a,SND_PAGE
;	call setSlot1
;
;	ld a,(MUS_COUNT)
;	ld l,a
;	pop af
;
;	cp l
;	jr nc,.skip
;
;	ld h,high MUS_LIST
;	ld l,a
;
;	ld e,(hl)
;	inc h
;	ld d,(hl)
;	inc h
;	ld a,(hl)
;	ex de,hl
;	call setSlot2
;	di
;	ld (musicPage),a
;	ld bc,#fffd
;	ld a,#fe
;	out(c),a
;	call PT3_INIT
;	ei
;	ld a,CC_PAGE2
;	call setSlot2
;
;.skip
;	pop iy
;	pop ix
;
;	ld a,CC_PAGE1
;	jp setSlot1



;���������� ������

;_music_stop
;	xor a
;	ld (musicPage),a
;	jp reset_ay


;������������ ������
;l=����� ������

_sample_play
;	ld bc,MEM_SLOT0
;	ld a,~SND_PAGE
;	out (c),a
;	ld a,(SMP_COUNT&#3fff)
;	ld e,a
;	ld a,l
;	cp e
;	jr nc,.skip
;
;	ld h,high (SMP_LIST&#3f00)
;
;	ld e,(hl)	;lsb
;	inc h
;	ld d,(hl)	;msb
;	inc h
;	ld a,(hl)	;page
;	inc h
;	ld h,(hl)	;delay
;	ex de,hl
;
;	out (c),a
;	ld e,a
;	di
;	ld a,%10100000 ;����� EGA ��� �����, ��� ��� � 14 ��� �������� �����������
;	ld bc,#bd77
;	out (c),a
;	ld bc,MEM_SLOT0
;.l0
;	ld a,(hl)	;7
;	out (#fb),a	;11
;	or a		;4
;	jr z,.done	;7/12
;	inc hl		;6
;	bit 6,h		;8
;	jr nz,.page	;7/12
;.delay
;	ld a,d		;4
;	dec a		;4
;	jp nz,$-1	;10
;	jp .l0		;10=78t ��� d=1, ��� �������� 14 ������
;.page
;	ld h,0
;	dec e
;	out (c),e
;	jp .delay
;.done
;	ld a,%10101000 ;����� EGA � �����
;	ld bc,#bd77
;	out (c),a
;	ei
;
;.skip
;	ld bc,MEM_SLOT0
;	ld a,~CC_PAGE0
;	out (c),a
	ret

_wyz_play_sound
		push bc
		ld a,(memSNDPage) : call setSlot1
		pop bc
		ld a,b
		call AFX_PLAY 
		ld a,(memCCPage1)
		jp setSlot1

;		push bc
;		ld a,SND_PAGE
;		call setSlot1
;		pop bc
;		push ix
;		call #400a
;		pop ix
;		ei
;		ld a,CC_PAGE1
;		jp setSlot1

_wyz_play_music
		di
		push ix
		push af
		ld a,(memSNDPage) : call setSlot1
		;ld a,FM_PAGE
		;call setSlot2
		pop af
		ld hl,SNDFLAG
		bit 4,(hl)
		jr nz,.fmm
		call #4009
		ld a,(SNDFLAG)
		jr .nfm
;		and %11111101
;		ld (SNDFLAG),a
;		jr
.fmm		set 7,(hl)
		ei
		;call #6000		
		ld a,(SNDFLAG)
		or 8
.nfm		and %01111101
		ld (SNDFLAG),a
		ei
		pop ix
		;ld a,CC_PAGE2
		;call setSlot2
		ld a,(memCCPage1)
		jp setSlot1

_wyz_stop_sound: 
		di
		push ix
		ld a,(memSNDPage) : call setSlot1
		;ld a,SND_PAGE
		;call setSlot1
		ld a,(SNDFLAG)
		set 7,a
		ld (SNDFLAG),a
		bit 4,a
		push af
		call z,#400f
		pop af
		;call nz,#6003
		ld a,(SNDFLAG)
		and %01110111
		or 2
		ld (SNDFLAG),a
		ld hl,AYREGS2
		ld de,AYREGS2+1
		ld bc,13
		ld (hl),0
		ldir
		ei
		pop ix
		ld a,(memCCPage1)
		jp setSlot1
