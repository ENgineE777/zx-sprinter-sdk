D_TBON		EQU 3	; ����� ��� ����祭�� TURBO
D_TBOFF		EQU 2	; ����� ��� ����祭�� TURBO
D_ROM16ON	EQU 1
D_ROM16OFF	EQU 0
CNF_0		EQU 04h
CNF_1		EQU 0Ch
CNF_2		EQU 14h
CNF_3		EQU 1Ch
CNF_512		EQU 80h	; ����祭�� Pentagon 128

CBL_DIR		EQU 78	; ���� �ࠢ����� COVOX-Blaster
			; bit 7 - 1 ������� CBL

SPRINTER	EQU 4	; ������ !!!
ISD_WARM        EQU 3
ISD_COLD        EQU 0
IS_KEY          EQU 40h ; ������ ��� ������ � ���� ��� ��������� IS-DOS
IS_RAM_ADR      EQU 5BC0h ; ����� �������� ��������� �������� � IS-DOS
TB_WAITES	EQU 00H	; WAIT� ��� TURBO-MODE
NTB_WAITES	EQU 00H	; WAIT� ��� neTURBO-MODE
IS_WAITES	EQU 00H ; WAIT� ��� IS-DOS

SYS_PORT_ON	EQU 07CH
SYS_PORT_OFF	EQU 03CH

PAL_V_PAGE 	EQU 09EH
PAL_SCP		EQU 01EH

CNF_PAGE	EQU 040H
SYS_PAGE	EQU 0FEH
MODE_PAGE	EQU 0FCH

KBD_COM		EQU 1Bh
KBD_DAT		EQU 1Ah

COM_B		EQU 1Bh
DAT_B		EQU 1Ah
COM_A		EQU 19h
DAT_A		EQU 18h

LPT1_D		EQU 1CH
LPT1_C		EQU 1DH
LPT2_D		EQU 1EH
LPT2_C		EQU 1FH

STC0_C		EQU 10H
STC1_C		EQU 11H
STC2_C		EQU 12H
STC3_C		EQU 13H

RAMD_LET	EQU ('R'-'A')

P_KBD_OUT	EQU 0F8H
P_KBD_IN	EQU 0FEH
;***************************************
;HD_HEADS EQU 5
HD_CS	EQU 0A0H

;HD_S_P_T EQU 17
;HD_S_X_H EQU (HD_S_P_T * HD_HEADS)	; ??? �᫮ ᥪ�஥ �� 樫����

P_DATS	EQU 050H	; READ/WRITE INIR/OTIR

P_ERR	EQU 051H	; READ
P_PREC	EQU 151H	; WRITE

P_S_CNT	EQU 152H	;
P_S_NUM	EQU 153H
P_C_LOW EQU 154H
P_C_HIG EQU 155H        ;<-\
P_HD_CS	EQU 4152H        ;<-/

P_HDST	EQU 4053H	; READ
P_CMD	EQU 4153H	; WRITE

P_HD3F6	EQU 4154H	; WRITE 3F6
P_HD3F7 EQU 4055H	; READ 3F7

;***************************************
CMOS_DRD equ	0FFBDh
CMOS_DWR equ	0BFBDh
CMOS_AWR equ	0DFBDh
ISA_PORT equ	09FBDh

;***************************************
SEC_SIZE	EQU 11
CLAST_SIZE	EQU 13
RESERV_SECS	EQU 14
FATS_NUM	EQU 16
FLS_NUM		EQU 17
S_P_D		EQU 19
FORM_CODE	EQU 21
S_P_F		EQU 22
S_P_T		EQU 24
H_P_S		EQU 26
SPECIAL_SECS	EQU 28
FAT_ID		EQU 36H
;***************************************

SYSTEM_ID	EQU 0C020H

SYS_SP		EQU 0C0FEH	; �������������� ����
DISK_TYPE	EQU 0C100H	; ��ॠ����� ��᪮�
COPY_PAGE0	EQU 0C104H	; ����� ���祭�� ���⮢ ��࠭��
COPY_PAGE1	EQU 0C105H
COPY_PAGE2	EQU 0C106H
COPY_PAGE3	EQU 0C107H
RAMD_VARS	EQU 0C108H	; ��६���� RAM-��᪮�
A_RAMD_VARS	EQU 0C118H	; ⥪�騩 RAM-Disk
SP_SAVE		EQU 0C11AH	; ���� ��� ��࠭���� ���� �⥪�
ERR_SAVE	EQU 0C11CH
COPY_RGADR	EQU 0C11DH
RAM_MSD		EQU 0C11EH	; ��࠭�� ��� ࠡ��� � MS-DOS
MSD_SECS	EQU 0C11FH	; ��᫮ ᥪ�஢ � MS-DOS
MSD_NAME	EQU 0C120H	; ���� ����� ���������� 䠩��
;MSD_FAT_SEC	EQU 0C122H	; ��砫�� ᥪ�� FAT
INT_ADRESS  	EQU 0C124H	; ��砫�� ᥪ�� CAT
INT_PAGE    	EQU 0C126H	; ��砫�� ᥪ�� DAT
DS_1440		EQU 0C128H	; 䫠�� ��४��祭�� 720/1440
F_P_S		EQU 0C129H	; �᫮ 䠩����� ����ᥩ � ᥪ��
S_P_C		EQU 0C12AH	; �᫮ ᥪ�஢ ��⠫���
COUNT_FL	EQU 0C12BH	; ���稪 䠩��� � ᥪ��
COUNT_SEC	EQU 0C12CH	; ���稪 ᥪ�஢ � ��⠫���
C_P_B		EQU 0C12DH	; �᫮ �����஢ �� ���� ���
;CLASTER_LEN	EQU 0C12EH	; ����� ������ � �����
FAT_FLAG	EQU 0C130H	; FAT 䫠� + FAT sector
MSD_CONT_SEC	EQU 0C132H	; ⥪�騩 ᥪ�� ��� MS-DOS
MSD_CONT_SEC2	EQU 0C134H
S_X_H		EQU 0C136H	; ������⢮ ᥪ�஢ �� 樫����
CONFIG_ALL	EQU 0C138H	; ����⥫� ���䨣��樨
CONFIG_DE	EQU 0C13AH	; ����⥫� ���䨣��樨
CONFIG_BYTE	EQU 0C13EH	; ���� ���䨣��樨

WIN_MAP_SC	EQU 0C140H
WIN_TAB_SC	EQU 0C142H
WIN_SAV_HL	EQU 0C144H
WIN_SAV_DE	EQU 0C146H
WIN_SAV_BC	EQU 0C148H
WIN_ZG		EQU 0C14AH
WIN_PLACE_WIN	EQU 0C14CH
WIN_GR_MAP	EQU 0C14EH

SYS_WORK1	EQU 0C150H
SYS_WORK2	EQU 0C152H
SYS_WORK3	EQU 0C154H
SYS_WORK4	EQU 0C156H

WIN_MAP_LAB1	EQU 0C158H
WIN_MODE_SH	EQU 0C15CH
WIN_MODE_SC	EQU 0C15EH

MSD_FAT_SEC	EQU 0C160H	; ��砫�� ᥪ�� FAT
MSD_FAT_SEC2	EQU 0C162H	; ��砫�� ᥪ�� FAT
MSD_CAT_SEC	EQU 0C164H	; ��砫�� ᥪ�� CAT
MSD_CAT_SEC2	EQU 0C166H	; ��砫�� ᥪ�� CAT
MSD_DAT_SEC	EQU 0C168H	; ��砫�� ᥪ�� DAT
MSD_DAT_SEC2	EQU 0C16AH	; ��砫�� ᥪ�� DAT
CLASTER_LEN	EQU 0C16CH	; ����� ������ � �����
CLASTER_LEN2	EQU 0C16EH	; ����� ������ � �����

;CMOS_FLAG_1	EQU 0C170H

GR_BIT_END	EQU 7

S_BIT_END       EQU 7
S_BIT_LIN       EQU 6
S_BIT_MOD       EQU 5

BIT_1440	EQU 1
BIT_MASK_1440	EQU 00000010B

RAMD_KEYS	EQU 0C180H	; ���� RAM-Disks
RAMD_KEY_NUM	EQU 16

LIB_TABLE	EQU 0C1A0H      ; ⠡���� librares 32 ����
				; +0 ������⥪� DOS

HDD_INI_TABLE	EQU 0C1C0H	; ⠡���� ��� ide ���ன�� 32 ����
				; 0 - ����� DRV_HEAD
				; 1 - ᥪ�஢ �� ��஦��
				; 2 - �᫮ �������
				; 3 - ������⢮ 樫���஢ ��.
				; 4 - ������⢮ 樫���஢ ���訩.
				; 5 - ᥪ�஢ �� 樫���� ��.
				; 6 - ᥪ�஢ �� 樫���� ����.
				; 7 - reserv - type

FDD_INI_TABLE	EQU 0C1E0H	; ⠡���� ��� FDD ���ன�� 32 ����

RAMD_FAT	EQU 0C200H	; �ᯮ������� ������ RAM-Disk-��

MS_BPB		EQU 0C400H	; ���� BPB
MS_DIR		EQU 0C800H	; ���� DIR sector
MS_FAT		EQU 0CC00H	; ���� FAT sector
MS_BUF		EQU 0D000H	; ���� DAT sector
HD_IDF_ADR	EQU 0C600H


WIN_MAP_IX	EQU 0E000H	; ����� ���� ����

TASK_DATA	EQU 0EC00H	; ����� ��� �����

; ***** - ������ ��६���� - *****

WIN_SIZE_H	EQU 0		; ��ਧ��⠫�� ࠧ��� � ����������
WIN_SIZE_V	EQU 1		; ���⨪���� ࠧ��� � ����������
WIN_PLACE_H	EQU 2		; ��������� �� ��ਧ��ࠫ�, � ����������
WIN_PLACE_V	EQU 3		; ��������� �� ���⨪��� � ����������
WIN_MODE	EQU 4		; ०�� ���������
WIN_MODE_S	EQU 5		; �������⥫�� ०��
				; ��� 0 - Sp-SCR,
WIN_GR_X	EQU 6		; ��������� �� X � ���� ��䨪� (�� ���������)
WIN_GR_Y	EQU 7		; ��������� �� Y � ���� ��䨪� (�� ���������)

WIN_HL		EQU 8		; ��࠭���� HL
WIN_BC		EQU 10		; ��࠭���� BC
WIN_DE		EQU 12		; ��࠭���� DE
WIN_V_BEG	EQU 14		; ��砫� ���� �� ���⨪���
WIN_V_END	EQU 15		; ����� ���� �� ���⨪���
WIN_H_BEG	EQU 16		; ��砫� ���� �� ��ਧ��⠫�
WIN_H_END	EQU 17		; ����� ���� �� ��ਧ��⠫�
WIN_SIZE_REL	EQU 18		; ॠ��� ࠧ��� � ᨬ�����
WIN_MODE_E	EQU 19		; �������⥫�� ०�� ��࠭�
WIN_WORK_1	EQU 20		; ࠡ��� ��६����� 1
WIN_WORK_2	EQU 21		; ࠡ��� ��६����� 2
WIN_GRAF_X	EQU 24		; ��砫쭠� ���न��� �� X
WIN_GRAF_Y	EQU 26		; ��砫쭠� ���न��� �� Y

USER_VARS	EQU 0F000h	; ��६���� ���짮��⥫��

;SW_ROM	EQU 3CF9H

;	IF .PROJ4
;RGADR   EQU 0D0H
;RGSCR   EQU 0D1H
;RGMOD   EQU 0D2H
;RGACC   EQU 0D3H
;PGACC   EQU 0FCH

;PAGE0   EQU 0C0H
;PAGE1   EQU 0C5H
;PAGE2   EQU 0C2H
;PAGE3   EQU 0C0H

;	ELSE

;	ENDIF

PAGE0   EQU 082H
PAGE1   EQU 0A2H
PAGE2   EQU 0C2H
PAGE3   EQU 0E2H

;RGADR   EQU 089H
;RGSCR   EQU 0A9H
;RGMOD   EQU 099H
;RGACC   EQU 0B9H
PORT_Y	EQU 089H
RGADR   EQU 089H
RGSCR   EQU 0E9H
RGMOD   EQU 0C9H
;RGACC   EQU 0A9H
;PGACC   EQU 0FCH
CNF_PORT EQU 7Ch

ALTERA  EQU 1400H

WG_COM          EQU     00FH
WG_TRK          EQU     03FH
WG_SEC          EQU     05FH
WG_DATA         EQU     07FH
P_DOS_FF        EQU     0FFH

BUFER_RD        EQU     5D25H

PR_BUFER	EQU	05B00H
AUTO_5B08	EQU	05B08H
AUTO_5B5C	EQU	05B5CH
COPY_P128	EQU	05B5CH
AUTO_5BFF	EQU	05BFFH
K_STATE		EQU	05C00H
KEY_TIME	EQU	05C09H
REP_K_TYME	EQU	05C10H
ZG		EQU	05C36H
ERR_BEEP	EQU	05C38H
KEY_BEEP	EQU	05C39H
ERR_NR		EQU	05C3AH
FLAGS		EQU	05C3BH
TV_FLAG		EQU	05C3CH
ERR_SP		EQU	05C3DH
LIST_SP		EQU	05C3FH
MODE		EQU	05C41H
NEW_PPC		EQU	05C42H
NEW_S_PPC	EQU	05C44H
PPC		EQU	05C45H
SUB_PPC		EQU	05C47H
BORDER		EQU	05C48H
EDIT_PPC	EQU	05C49H
BAS_VARS	EQU	05C4BH
WORK_VAR	EQU	05C4DH
CHANS		EQU	05C4FH
CUR_CHL		EQU	05C51H
BAS_PROG	EQU	05C53H
NEXT_LINE	EQU	05C55H
DATA_ADR	EQU	05C57H
E_LINE		EQU	05C59H
K_CUR		EQU	05C5BH
CH_ADR		EQU	05C5DH
SINT_ER_AD	EQU	05C5FH
WORK_SP		EQU	05C61H
STK_BOT		EQU	05C63H
STK_END		EQU	05C65H
B_REG		EQU	05C67H
MEM_CALC	EQU	05C68H
FLAGS_2		EQU	05C6AH
L_SCR_SIZE	EQU	05C6BH
AUTO_LST_L	EQU	05C6CH
OLD_PPC		EQU	05C6EH
OLD_S_PPC	EQU	05C70H
FLG_INPUT	EQU	05C71H
S_VAR_LEN	EQU	05C72H
SINT_TB_ADR	EQU	05C74H
RAND_SEED	EQU	05C76H
FRAMES		EQU	05C78H
UDG		EQU	05C7BH
X_Y_COORD	EQU	05C7DH
PRN_POS		EQU	05C7FH
ADR_PR_BUF	EQU	05C80H
ECHO_E		EQU	05C82H
SCR_PL_M	EQU	05C84H
SCR_PL_L	EQU	05C86H
SCR_POS_M	EQU	05C88H
SCR_POS_L	EQU	05C8AH
SCROLL_ST	EQU	05C8CH
ATTR_P		EQU	05C8DH
MASK_P		EQU	05C8EH
ATTR_T		EQU	05C8FH
MASK_E		EQU	05C90H
FLAGS_ATR	EQU	05C91H
MEM_BOT		EQU	05C92H
AUTO_5C9A	EQU	05C9AH
NMI_ADR		EQU	05CB0H
TOP_CLEAR	EQU	05CB2H
P_RAMTOP	EQU	05CB4H
BEG_ADRESS	EQU	05CB6H
RET_INS		EQU	05CC2H
AUTO_5CC3	EQU	05CC3H
DISK_A		EQU	05CC8H
DISK_B		EQU	05CC9H
DISK_C		EQU	05CCAH
DISK_D		EQU	05CCBH
CAT_SEC		EQU	05CCCH
DRV_READY	EQU	05CCDH
RD_WR_COM	EQU	05CCEH
VAR_1		EQU	05CCFH
AUTO_5CD1	EQU	05CD1H
AUTO_5CD2	EQU	05CD2H
AUTO_5CD3	EQU	05CD3H
AUTO_5CD5	EQU	05CD5H
DOS_ERROR	EQU	05CD6H
MED_START	EQU	05CD7H
DOS_CH_ADR	EQU	05CD9H
MED_LEN		EQU	05CDBH
FL_NAME		EQU	05CDDH
FL_N_2		EQU	05CDFH
FL_N_4		EQU	05CE1H
FL_N_6		EQU	05CE3H
FL_N_7		EQU	05CE4H
FL_TYPE		EQU	05CE5H
FL_START	EQU	05CE6H

FL_LEN		EQU	05CE8H
START_CLASTER	EQU	FL_LEN

FL_SIZE		EQU	05CEAH
FL_PLACE	EQU	05CEBH
VAR_2		EQU	05CEDH
INTERF_I	EQU	05CEFH
VAR_2_0		EQU	05CF1H
VAR_2_1		EQU	05CF2H
CONT_SEC	EQU	05CF4H
CONT_TRK	EQU	05CF5H
OPER_DISK	EQU	05CF6H
DOS_FLAG	EQU	05CF7H
DISK_1_FLG	EQU	05CF8H
DISK_2_FLG	EQU	05CF9H
TIME_A		EQU	05CFAH
TIME_B		EQU	05CFBH
TIME_C		EQU	05CFCH
TIME_D		EQU	05CFDH
COMAND_WG	EQU	05CFEH
SEC_NUM		EQU	05CFFH
CONT_BUF_ADR	EQU	05D00H
WORK_2		EQU	05D02H
WORK_4		EQU	05D04H
S_NAME_NUM	EQU	05D06H
N_DEL_FLS	EQU	05D07H
FST_SYM_NAME	EQU	05D08H
VAR_3		EQU	05D09H
BUF_FLAG        EQU     05D0CH
BAS_DOS_FLG	EQU	05D0EH
DOS_ERR_2	EQU	05D0FH
ERR_3D00	EQU	05D10H
ADR_DOS_COM	EQU	05D11H
ERR_SP_COPY	EQU	05D13H
MSG_FLAG	EQU	05D15H
PDOS_COPY	EQU	05D16H
FLAG_BOOT	EQU	05D17H
INT_1_VAR	EQU	05D18H
CONT_DISK	EQU	05D19H
ADR_RET		EQU	05D1AH
DOS_SP		EQU	05D1CH
FL_NUMBER	EQU	05D1EH
COM_LN_COPY	EQU	05D20H
L_5D23		EQU	05D23H
BUFER		EQU	05D25H
AUTO_5D33	EQU	05D33H
CLEAR_SEC	EQU	05E06H
CLEAR_TRK	EQU	05E07H
TYPE_DISK	EQU	05E08H
N_FILES		EQU	05E09H
FREE_SEC	EQU	05E0AH
CODE_10H	EQU	05E0CH
DISK_MRK_1	EQU	05E0FH
DISK_ALT_NM	EQU	05E10H
N_DEL_FL	EQU	05E19H
DISK_NAME	EQU	05E1AH




;    ��p�� Sprinter. (����� PORT_X)<<
;    0  - port FF<<
;    1  - port keyboard<<
;    2  - port BORDER<<
;    3  - port 1FFDh<<
;    4  - port 7FFDh<<
;    5  - port 3FFDh<<
;    6  - port Start-ROM<<
;    7  - port Start-ROM-ALT<<
;    8  - port ROM-BASIC48<<
;    9  - port ROM-BASIC128<<
;    10 - port ROM-TR-DOS<<
;    11 - port ROM-EXPANSION<<
;    12 - port ROM-BASIC48-ALT<<
;    13 - port ROM-BASIC128-ALT<<
;    14 - port ROM-TR-DOS-ALT<<
;    15 - port ROM-EXPANSION-ALT<<
;    16 Ŀ<<
;    .. Ĵ<<
;    31 ���ports RAM-PAGES - ��p�� 㪠�뢠�騥, ����� ��p���� ���<<
;������祭� � ����⢥ ��p����� 0..F � ���䨣�p�樨 Scorpion.<<
;    33 - port RAM-0 ��p���� ��� ������砥��� � �㫥��� ���� �p����p�<<
;    34 - port RAM-5 ��p���� ��� ������砥��� � ��p��� ���� �p����p�<<
;    35 - port RAM-2 ��p���� ��� ������砥��� �� ��p�� ���� �p����p�<<
;    36 - port CONFIG<<
;    37 - port COVOX-1<<
;    38 - port COVOX-2<<
;    39 - port AY-3-8910-adr<<
;    40 - port AY-3-8910-dat<<
;    41 - port KEMPSTON<<
;    42 - port ISA-interface<<
;    43 Ŀreserv<<
;    .. Ĵ<<
;    47 ��<<
;    48 - 51 ��p�� ��93<<
;    52 - ��p� DOS-1<<
;    53 - ��p� DOS-2<<
;    54 Ŀ �㦥��� ��p��<<
;    .. Ĵ<<
;    63 ��<<
;    64 Ŀ ��p�� IDE interface<<
;    .. Ĵ<<
;    79 ��<<
;    80..127 - p���p�.<<
;    128..143 - ��p�� �����䨪��p� ��設� ( ⮫쪮 ��� �⥭��.)<<
;    144..254 - p���p�<<
;    255 - ���-��p� - �⪫�祭��� ���ﭨ�.<<
;

