#pragma disable_warning 85

//����������� ����� ����������

typedef unsigned char u8;
typedef   signed char i8;
typedef unsigned  int u16;
typedef   signed  int i16;
typedef unsigned long u32;
typedef   signed long i32;

#define TRUE	1
#define FALSE	0

//����� ������ ���������

#define JOY_RIGHT	0x01
#define JOY_LEFT	0x02
#define JOY_DOWN	0x04
#define JOY_UP		0x08
#define JOY_FIRE	0x10
#define JOY_START   0x20
#define JOY_ESC     0x80

//������� � ������� ������ �������

#define BRIGHT_MIN	0
#define BRIGHT_MID	15
#define BRIGHT_MAX	30

//���������� ������ �������� ���������

void memset(void* m,u8 b,u16 len) __naked;

//����������� ������, ������� �� ������ ������������

void memcpy(void* d,void* s,u16 len) __naked;

//��������� 16-������� ���������������� �����

u16 rand16(void) __naked;

//��������� ����� �������, 0..7

void border(u8 n) __naked;

// �������� ����� �����
void vsync(void) __naked;

//����� kempston ��������� � ��������� ������ � ��������
//��� ������ ������ ���� ��������� JOY_

u8 joystick(void) __naked;

//��������� ������� ������ BRIGHT_MIN..BRIGHT_MID..BRIGHT_MAX (0..15..30)
//�� ��������� ������� ������ �� ���������� ������� �� ��������� ������ ������

void pal_bright(u8 bright) __naked;

void pal_bright16(u8 subpal, u8 bright) __naked;

//����� ��������������� ������� �� ������

void pal_select(u8 id) __naked;

//����������� ������� ������� � ������

void pal_copy(u8 start, u8 count, u8* pal) __naked;

//��������� ���� ������ � ������� ���������� �� �������

void pal_custom(u8 start, u8 count, u8* pal) __naked;

//��������� �����

void draw_tile(u8 x,u8 y,u16 tile) __naked;

//��������� �����������

void draw_image(u8 x) __naked;

//������� �������� ������ ������ ������ 0..255

void clear_screen(u8 color) __naked;

//������������ �������, ������� ���������� �������
//�������� ����� ����������� �������������, vsync ����� ������� ���� ������� �� �����
//������� ����� ��������� �������, ���� ��� ��������

void swap_screen(void) __naked;

void sprites_clip(u8 clip) __naked;


//������ ������� ������ ��������
//�� ������� ������ ������ ���� �����������, ������ �������� ����� �������� �������
//��� ������� ����������� ��������, ���������� ����������� �������� ������ ������
//����� ���� ��� ������� ���������, ��� ����� ������������� ���������� ��� swap_screen

void sprites_start(void) __naked;

//������� ������� ������ ��������

void sprites_stop(void) __naked;

//�������� ������ � ������ ������
//x ���������� 0..240
//y ���������� 0..176
//spr ����� ����������� �������
void add_sprite(u8 x,u8 y,u16 spr) __naked;

// ����� ������ ��������
void end_sprite(void) __naked;

//����� � ������� ������� ��������� � ������

u32 time(void) __naked;

//��������, �������� � ������ (1/50 �������)

void delay(u16 time) __naked;

void wyz_play_music (unsigned char song_number) __naked;
void wyz_play_sound (unsigned char fx_number, unsigned char fx_channel) __naked;
void wyz_stop_sound (void) __naked;

void quit(void) __naked;

void fade_to_black(void)
{
    u8 a;
    for (a = 16; a > 0; a--)
    {
        pal_bright(a - 1);
        vsync();
    }
}

void fade_from_black(void)
{
    u8 a;
    for(a = 0;a <= 15; a++)
    {
        pal_bright(a);
        vsync();
    }
}

void unpack_screen(const u8 id,u8 pal)
{
    draw_image(id);
    pal_select(pal);
    swap_screen();
    fade_from_black();
}

void check_to_quit(u8 any_key)
{
    u8 j = joystick();
    
    if (j == JOY_ESC || (any_key && j&(JOY_FIRE|JOY_START)))
    {
        quit();
    }
}

