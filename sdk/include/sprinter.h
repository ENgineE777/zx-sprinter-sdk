#pragma disable_warning 85

//определени€ типов переменных

typedef unsigned char u8;
typedef   signed char i8;
typedef unsigned  int u16;
typedef   signed  int i16;
typedef unsigned long u32;
typedef   signed long i32;

#define TRUE	1
#define FALSE	0

//флаги кнопок джойстика

#define JOY_RIGHT	0x01
#define JOY_LEFT	0x02
#define JOY_DOWN	0x04
#define JOY_UP		0x08
#define JOY_FIRE	0x10
#define JOY_START   0x20
#define JOY_ESC     0x80

//крайние и средний уровни €ркости

#define BRIGHT_MIN	0
#define BRIGHT_MID	15
#define BRIGHT_MAX	30

//заполнение пам€ти заданным значением

void memset(void* m,u8 b,u16 len) __naked;

//копирование пам€ти, области не должны пересекатьс€

void memcpy(void* d,void* s,u16 len) __naked;

//генераци€ 16-битного псевдослучайного числа

u16 rand16(void) __naked;

//установка цвета бордюра, 0..7

void border(u8 n) __naked;

// ожидание конца кадра
void vsync(void) __naked;

//опрос kempston джойстика и курсорных клавиш с пробелом
//дл€ опроса кнопок есть константы JOY_

u8 joystick(void) __naked;

//установка €ркости экрана BRIGHT_MIN..BRIGHT_MID..BRIGHT_MAX (0..15..30)
//от полностью чЄрного экрана до нормальной €ркости до полностью белого экрана

void pal_bright(u8 bright) __naked;

void pal_bright16(u8 subpal, u8 bright) __naked;

//выбор предопределЄнной палитры по номеру

void pal_select(u8 id) __naked;

//копирование текущей палитры в массив

void pal_copy(u8 start, u8 count, u8* pal) __naked;

//установка всех цветов в палитре значени€ми из массива

void pal_custom(u8 start, u8 count, u8* pal) __naked;

//отрисовка тайла

void draw_tile(u8 x,u8 y,u16 tile) __naked;

//отрисовка изображени€

void draw_image(u8 x) __naked;

//очистка теневого экрана нужным цветом 0..255

void clear_screen(u8 color) __naked;

//переключение экранов, теневой становитс€ видимым
//ожидание кадра выполн€етс€ автоматически, vsync перед вызовом этой функции не нужен
//функци€ также обновл€ет спрайты, если они включены

void swap_screen(void) __naked;

void sprites_clip(u8 clip) __naked;


//запуск системы вывода спрайтов
//на видимом экране должно быть изображение, поверх которого будут выведены спрайты
//эта функци€ выполн€етс€ медленно, происходит копирование большого объЄма данных
//после того как спрайты разрешены, они будут автоматически выводитьс€ при swap_screen

void sprites_start(void) __naked;

//останов системы вывода спрайтов

void sprites_stop(void) __naked;

//добавить спрайт в список вывода
//x координата 0..240
//y координата 0..176
//spr номер изображени€ спрайта
void add_sprite(u8 x,u8 y,u16 spr) __naked;

// конец списка спрайтов
void end_sprite(void) __naked;

//врем€ с момента запуска программы в кадрах

u32 time(void) __naked;

//задержка, значение в кадрах (1/50 секунды)

void delay(u16 time) __naked;


void wyz_play_music (unsigned char song_number) __naked;
void wyz_play_sound (unsigned char fx_number, unsigned char fx_channel) __naked;
void wyz_stop_sound (void) __naked;

//void fm_sound_on (void) __naked;
//u8 tfm_stat(void) __naked;

// выход в DSS
void quit(void) __naked;