	.globl	_main

	.area _HEADER (ABS)

	.org    0x0000	;--code-loc 0x0006

init:
	call s__GSINIT
	jp   __pre_main

	.area	_CODE

__pre_main:
	push de
	ld de,#_HEAP_start
	ld (_heap_top),de
	pop de
	call _main
	di
	halt

	;; Ordering of segments for the linker.
	.area	_HOME
	.area	_CODE
	.area	_INITIALIZER
	.area   _GSINIT
	.area   _GSFINAL

	.area	_DATA
	.area	_INITIALIZED
	.area	_BSEG
	.area   _BSS
	.area   _HEAP 
	.area	_DATA

_heap_top::
	.dw 0

	.area   _GSINIT
gsinit::

	.area   _GSFINAL
	ld	bc, #l__INITIALIZER
	ld	a, b
	or	a, c
	jr	Z, gsinit_next
	ld	de, #s__INITIALIZED
	ld	hl, #s__INITIALIZER
	ldir
gsinit_next: 
	ret

	.area	_HEAP

_HEAP_start::
