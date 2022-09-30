		device pentagon1024

		org $8100-512
		include "dss_equ.asm"
		include "bios_equ.asm"
		include "sprint00.asm"

GFX_320_256	equ $81
CR		equ 13
LF		equ 10
MEM_PAGES	equ 29
begin

		db "EXE"	;EXE ID
		db $00	;EXE VERSION
		dw $0200	;CODE OFFSET LOW
		dw $0000	;CODE OFFSET HIGH
		dw end-code_start;END-BEG ;PRIMARY LOADER
		dw $0000	;
		dw $0000	;RESERVED
		dw $0000	;
		dw $8100	;LOAD ADDRESS
		dw code_start	;START ADDRESS
		dw code_start-1	;STACK ADDRESS

		org $8100

code_start
;	ld sp,code_start
		;in a,(PORT_Y)
		;ld hl,porty_n
		;call hexToASCII
		;ld hl,portyStr
		;ld c,Dss.PChars
		;rst $10

		ld a,$C0 : out (PORT_Y),a
		ld a, (ix-3)
		ld (_File), a

		ld hl,messageStr
		ld c,Dss.PChars
		rst $10
		jr cont
		;ld hl,datFile
		;ld c,Dss.Open
		;rst $10
		;jr nc,openok
loadErr		ld hl,messageErr
exitErr		ld c,Dss.PChars
		rst $10
		ld b,1
		ld c,Dss.Exit
		rst $10
		jr $
;openok:		ld (_File),a

cont:		ld bc, (MEM_PAGES*256) | Dss.GetMem
		rst $10
		jp c,NotEnoughtMemory
		ld (mem_handle),a
		ld hl,memory_pages
		ld c,Bios.Emm_Fn5
		rst $08
		
		in a,(PAGE2) : ld (memory_pages+255),a
		in a,(PAGE0) : ld (memory_pages+254),a

		ld b,MEM_PAGES
		ld hl,memory_pages

loadloop:	push hl
		push bc

		ld a,(hl) : out (PAGE3),a
_File equ $+1 : ld a,0
		ld c,Dss.Read
		ld hl,$C000
		ld de,$4000
		rst $10
		jr c,loadErr
		ld c,Dss.PutChar
		ld a,"."
		rst $10

		pop bc
		pop hl
		inc hl
		djnz loadloop

loadDone:
		ld a,(memory_pages+3) : out (PAGE3),a ; CC_PAGE3
		ld hl,memory_pages
		ld de,$FC00
		ld bc,$100
		ldir

		ld a,$50 : out (PAGE1),a ; обнуление палитр 0 и 1
		ld hl,$0
		di
		ld d,d
		ld a,0
		ld e,e
		ld ($43E0),hl
		ld ($43E2),hl
		ld ($43E4),hl
		ld ($43E6),hl
		ld b,b
		ei

		ld c,Dss.GetVMod
		rst $10
		ld c,a
		ld (_oldvmode),bc

		ld a,GFX_320_256    ; графический режим 320х256х256
		ld bc,Dss.SetVMod
		rst $10

                ld c,$A6 : ld b,2 : rst 8

		ld hl,$4000
		ld bc,640
		di
.clslp		xor a
		ld e,e
		ld (hl),a
		ld b,b
		inc hl
		dec bc
		ld a,b
		or c
		jp nz,.clslp
		ei

		ld a,(memory_pages+3) : out (PAGE3),a ; CC_PAGE3
		ld hl,exit
		jp $E000

exit:		
                ld c,$A6 : ld b,3 : rst 8
		ld bc,(_oldvmode)
		ld a,c
		ld c,Dss.SetVMod
		rst $10
		ld b,0
		ld c,Dss.Exit
		rst $10
		jr $

NotEnoughtMemory:
		ld hl,messageErrMem
		jp exitErr

hexToASCII:     
		push af
		rrca : rrca : rrca : rrca
		call nibbleToAscii
		pop af
nibbleToAscii:	and $0F
		cp 10
		ccf
		adc a,$30
		daa
 		ld (hl),a
 		inc hl
 		ret

_oldvmode:	db 0
mem_handle:	db 0
;datFile:	db "UWOL.DAT",0,0,0,0,0
;portyStr:	db CR,LF,"PortY = "
;porty_n:	db "00",CR,LF,0
messageErr:	db CR,LF,"Loading error.",CR,LF,0
messageErrMem:	db CR,LF,"Not enough memory.",CR,LF,0
messageStr:	db CR,LF,"UWOL QUEST FOR MONEY v0.99RC IS LOADING.",CR,LF,0

memory_pages:	ds 256,0
		align 256
end

		display "File size ",/d,end-begin," bytes"

		savebin "loader.exe",begin,end-begin