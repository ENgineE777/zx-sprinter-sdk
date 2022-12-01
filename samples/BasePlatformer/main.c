// Jias jias - Este es como el subaquatic, que lleva en desarrollo tanto
// tiempo que el cуdigo de aquн abajo da miedo miedor.
#include "sprinter.h"
#include "splib.h"

/* Game constants */

#define uwol_r_1a       0
#define uwol_r_2a       1
#define uwol_r_3a       2
#define uwol_l_1a       3
#define uwol_l_2a       4
#define uwol_l_3a       5
#define wolfi_1a        6
#define franki_1a       7
#define vampi_1a        8
#define fanti_r_1a      9
#define fanti_l_1a      10
#define uwolpelot_r_1a  11
#define uwolpelot_r_2a  12
#define uwolpelot_r_3a  13
#define uwolpelot_l_1a  14
#define uwolpelot_l_2a  15
#define uwolpelot_l_3a  16
#define uwolmuete_1a    17
#define arrow_1a        18
#define coin_1a			19

#define PAL_TILES	0

#define EST_NORMAL       0
#define EST_NUDE         1
#define EST_PARP         2
#define EST_MUR          4
#define EST_EXIT         8
#define EST_EXIT_LEFT   16
#define EST_EXIT_RIGHT  32

#define CANAL_FX        1       // Canal por el que suenan los efectos de sonido

#define HEX__(n) 0x##n##LU

#define B8__(x) ((x&0x0000000FLU)?1:0) \
+((x&0x000000F0LU)?2:0) \
+((x&0x00000F00LU)?4:0) \
+((x&0x0000F000LU)?8:0) \
+((x&0x000F0000LU)?16:0) \
+((x&0x00F00000LU)?32:0) \
+((x&0x0F000000LU)?64:0) \
+((x&0xF0000000LU)?128:0)

#define B8(d) ((u8)B8__(HEX__(d)))

typedef struct
{
    u8 descriptor;
    u16 obj[10];
    u16 movil[3];
    u8 coin[10];
} FASE;

FASE fases[1];

const u8 fases_data[]={

    B8(00001101),

    B8(11000010), B8(00000000),
    B8(00110000), B8(00010011),
    B8(00110000), B8(10000011),
    B8(00100000), B8(01010101),
    B8(00110000), B8(00010111),
    B8(00110000), B8(10000111),
    B8(11001100), B8(00001001),
    B8(00000000), B8(00000000),
    B8(00000000), B8(00000000),
    B8(00000000), B8(00000000),

    B8(00010101), B8(00011010),
    B8(01100011), B8(00011010),
    B8(00000000), B8(00000000),

    B8(00010010),
    B8(00110010),
    B8(10000010),
    B8(10100010),
    B8(01010100),
    B8(01100100),
    B8(00010110),
    B8(00110110),
    B8(10000110),
    B8(10100110),
};

void fases_init(void)
{
    u16 i,j,tmp;
    const u8 *ptr;

    ptr=fases_data;
 
    for (i=0;i<1;i++)
    {
        fases[i].descriptor=*ptr++;

        for (j=0;j<10;j++)
        {
            tmp=*ptr++;
            tmp=(*ptr++<<8)|tmp;
            fases[i].obj[j]=tmp;
        }

        for (j=0;j<3;j++)
        {
            tmp=*ptr++;
            tmp=(*ptr++<<8)|tmp;
            fases[i].movil[j]=tmp;
        }

        for (j=0;j<10;j++)
        {
            fases[i].coin[j]=*ptr++;
        }
    }
}

i8 play;
u8 slowpoke;

/* Manage keys and joystick at the same time: */

/* fade out screen */
void fade_screen(u16 out)
{
    u16 i;

    if(out)
    {
        fade_to_black();
    }
    else
    {
        fade_from_black();
    }
}

/* Manage keys and joystick at the same time: */

u16 joyfunc(void)
{
    u8 i;
    u16 res;
 
    i = joystick();
 
    res = 0;
    if (i & JOY_LEFT)   res |= sp_LEFT;
    if (i & JOY_RIGHT)  res |= sp_RIGHT;
    if (i & JOY_UP)     res |= sp_UP;
    if (i & JOY_DOWN)   res |= sp_DOWN;
    if (i & JOY_FIRE)   res |= sp_FIRE;
    if (i & JOY_START)	res |= sp_START;
    if (i & JOY_ESC)    res |= sp_ESC;
 
    return res ^ 0xFFFF;
}

/* Data types */

typedef struct
{
    i16 x, y;
    i16 vx, vy;
    i8 g, ax, rx;
    u8 salto, cont_salto;
    u8 saltando;
    u16 frame, subframe, facing;
    u8 estado;
    u8 ct_estado;
    u16 ground,nojump;
} INERCIA;

INERCIA player;

i8 pantalla;
i8 lives;


// Estructura de datos para los objetos mуviles:
typedef struct {
    u8 x, y;
    i16 vx, vy;
    u8 t1, t2;
    i16 rx, ry;
    u16 current_frame, next_frame;
    i8 tipo;
} MOVILES;

MOVILES moviles[3];
//struct sp_SS *sp_moviles [3];
u8 sp_moviles [3];

// Almacena las monedas del nivel actual

typedef struct {
//    u16 type;
    u8 type;
    u16 x,y;
//    struct sp_SS *sp;
    u8 sp;
} MONEDA;

MONEDA monedas[10];
u8 num_monedas;

// Para ahorrar IFs...
const u16 enem_frames [8] = {
    wolfi_1a,       wolfi_1a,
    franki_1a,      franki_1a,
    vampi_1a,       vampi_1a,
    fanti_l_1a,     fanti_r_1a
};

i8 flag1, flag2;
u8 playing;
i8 level;

// Espacio para guardar 12 bloques de fondo.
u8 tile_buffer01 [8];
u8 tile_buffer02 [8];
u8 tile_buffer03 [8];
u8 tile_buffer04 [8];
u8 tile_buffer05 [8];
u8 tile_buffer06 [8];
u8 tile_buffer07 [8];
u8 tile_buffer08 [8];
u8 tile_buffer09 [8];
u8 tile_buffer10 [8];
u8 tile_buffer11 [8];
u8 tile_buffer12 [8];
u8 *tile_buffer [] = {tile_buffer01, tile_buffer02, tile_buffer03, tile_buffer04, tile_buffer05, tile_buffer06,
                      tile_buffer07, tile_buffer08, tile_buffer09, tile_buffer10, tile_buffer11, tile_buffer12};
u8 j, x, y, xx, yy, xt, yt;
i8 i;
//struct sp_SS *sp_prueba;
u8 sp_prueba;
u8 *wyz_music_flag;
u8 *allpurposepuntero;
u8 maincounter;

u16 total_coins;
u8 xcami, ycami;
struct sp_Rect rectangulo;
u8 prueba[8];
i8 bonus1, bonus2;

u8 cheat;
u8 monedas_frame;

#define coin_1a			19

const u16 monedas_anim[]={
    coin_1a,coin_1a+1,coin_1a+2,coin_1a+2,coin_1a+1,coin_1a,coin_1a+3,coin_1a+4,coin_1a+4,coin_1a+3
};

const u16 monedas_take_anim[]={
    coin_1a,coin_1a+1,coin_1a+2,coin_1a+4,coin_1a+5,coin_1a+6,coin_1a+7,coin_1a+8,coin_1a+9,coin_1a+10
};

const u16 player_anim[]={
    uwol_r_1a,uwol_r_2a,uwol_r_3a,uwol_r_2a,
    uwol_l_1a,uwol_l_2a,uwol_l_3a,uwol_l_2a,
    uwolpelot_r_1a,uwolpelot_r_2a,uwolpelot_r_3a,uwolpelot_r_2a,
    uwolpelot_l_1a,uwolpelot_l_2a,uwolpelot_l_3a,uwolpelot_l_2a
};

#define SPTW 4/7//2/3

#define zona1_data 0

// Pelotingui o vestido:
u8 rand ()
{
    return (u8)(rand16());
}

void todo_a_negro ()
{
    i16 i,j;
 
    for(i=0;i<24;i++)
    {
        for(j=0;j<32;j++) sp_AttrSet(j,i,0);
    }
}

void fade_out ()
{
    fade_screen(TRUE);
    todo_a_negro();
}

u16 collision_v(u16 x,u16 y,u16 h)
{
    u16 i;

    h--;
    h=((y+h)>>3)-(y>>3)+1;
 
    for(i=0;i<h;i++)
    {
        if(sp_AttrGet(x>>3,y>>3)>63) return TRUE;
        y+=8;
    }

    return FALSE;
}

u16 collision_h(u16 x,u16 y,u16 w)
{
    u16 i;

    w--;
    w=((x+w)>>3)-(x>>3)+1;
 
    for(i=0;i<w;i++)
    {
        if(sp_AttrGet(x>>3,y>>3)>63) return TRUE;
        x+=8;
    }

    return FALSE;
}

void move (u16 i)
{
    u8 xx, yy;
    u8 x, y;
    u16 off;

    if (player.vy < 512*SPTW/*256*/)
        player.vy += player.g;
    else
        player.vy = 512*SPTW/*256*/;

    player.y += player.vy;
    if (player.y < 0)
        player.y = 0;

    x = player.x >> 6;              // dividimos entre 64 para pixels, y luego entre 8 para tiles.
    y = player.y >> 6;
    xx = x >> 3;
    yy = y >> 3;

    if (player.vy < 0)
    {            // estamos ascendiendo
        if (player.y >= 1024)
            if(collision_h(x+2,y+4,16-4)) {
                // paramos y ajustamos:
                player.y = player.y-player.vy;
                player.vy = 0;
            }
        player.ground=FALSE;
    }
    else if (player.vy > 0)
    {     // estamos descendiendo
        if(collision_h(x+2,y+16,16-4))
        {
            // paramos y ajustamos:
            player.vy = 0;
            player.y = yy << 9;
            if(!player.ground)
            {
                player.ground=TRUE;
                player.nojump=TRUE;
                wyz_play_sound (0, CANAL_FX);
            }
        }
        else
        {
            player.ground=FALSE;
        }
    }

    if ( !player.nojump && (i & sp_FIRE) == 0 && player.vy == 0 && player.saltando == 0 && player.ground)
    {
        player.saltando = 1;
        player.cont_salto = 0;
        wyz_play_sound (7, CANAL_FX);
    }

    if ( (i & sp_FIRE) == 0 && player.saltando )
    {
        player.vy -= (player.salto + 48*SPTW/*16*/ - (player.cont_salto>>1));
        if (player.vy < -256/*128*/) player.vy = -256/*128*/;

        player.cont_salto ++;
        if (player.cont_salto == 6/*8*/)
            player.saltando = 0;
    }

    if ( (i & sp_FIRE) != 0)
    {
        player.saltando = 0;
        player.nojump=FALSE;
    }

    if ( ! ((i & sp_LEFT) == 0 || (i & sp_RIGHT) == 0))
    {
        if (player.vx > 0)
        {
            player.vx -= player.rx;
            if (player.vx < 0)
                player.vx = 0;
        }
        else if (player.vx < 0)
        {
            player.vx += player.rx;
            if (player.vx > 0)
                player.vx = 0;
        }
    }

    if ((i & sp_LEFT) == 0)
    {
        if (player.vx > -192*SPTW)
        {
            player.facing = 0;
            player.vx -= player.ax;
        }
    }

    if ((i & sp_RIGHT) == 0)
    {
        if (player.vx < 192*SPTW)
        {
            player.vx += player.ax;
            player.facing = 1;
        }
    }

    player.x = player.x + player.vx;

    /* Ahora, como antes, vemos si nos chocamos con algo, y en ese caso
       paramos y reculamos */

    y = player.y >> 6;
    x = player.x >> 6;
    yy = y >> 3;
    xx = x >> 3;

    if (player.y >= 512/*1024*/)
    {
        if (player.vx < 0)
        {
            if(collision_v(x+2,y+4,16-4))
            {
                // paramos y ajustamos:
                player.x = player.x-player.vx;
                player.vx = 0;
            }
        }
        else
        {
            if(collision_v(x+16-2,y+4,16-4))
            {
                // paramos y ajustamos:
                player.x = player.x-player.vx;
                player.vx = 0;
            }
        }
    }

    // Calculamos el frame que hay que poner:

    if(player.vx!=0) player.subframe++;
    off=(player.subframe>>1)&3;
    if(player.facing==0) off+=4;
    if(player.estado&EST_NUDE) off+=8;
    player.frame=player_anim[off];

    // Wrap around
 
    if (player.x <= 1088)
        player.x = 14270;
 
    if (player.x >= 14272)      player.x = 1090;
 
    // Morir en un pit
 
    if (player.y > 10752) {
        player.frame = uwolmuete_1a;
        player.estado |= EST_MUR;
        player.vy = - 7*SPTW * (player.salto);
        player.y = 10750;
        lives --;

        wyz_play_sound(11, CANAL_FX);
    }
 
    // Saliendo de la fase
 
    if (!(i & sp_DOWN))
    {
        if ( player.estado & EST_EXIT ) {
            if ( player.x > 2204 && player.x < 2880 )
                player.estado |= EST_EXIT_LEFT;
            if ( player.x > 12480 && player.x < 13120 )
                player.estado |= EST_EXIT_RIGHT;
        }
    }
}

void death_sequence()
{
    if (player.vy < 1024*SPTW/*256*/)
        player.vy += player.g;
    else
        player.vy = 1024*SPTW/*256*/;

    player.y += player.vy;
 
    if (player.y > 11264)
    {
        player.estado = EST_PARP;
        player.x = 32 << 6;
        player.y = 144 << 6;
        player.vx = player.vy = 0;
        player.ct_estado = 32*3/2;                      // Tiempo de inmunidad.
        flag1 = 3;
        playing = 0;
    }
}

void draw_minitile(i8 y, i8 x, u8 c, u8 tile)
{
	if(x<28&&y<22) sp_PrintAtInv (y, x, c, tile);
}

void draw_tiles (i8 x, i8 y, u8 c, u8 tile, u8 off)
{
    draw_minitile( off + y,    off + x,    c, tile);
    draw_minitile( off + y,   (off^1) + x, c, tile + 1);
    draw_minitile((off^1) + y, off + x,    c, tile + 2);
    draw_minitile((off^1) + y,(off^1) + x, c, tile + 3);
}

void draw_screen (u16 r_pant)
{
    struct sp_Rect rectangulo;
    u8 x,y;
    i8 l,n,v,t1,t2,t;
    u16 i,j,n_pant;
    u8 bd_atr, bd_pap, bd_ink;
 
    clear_screen(0);
    n_pant = r_pant % 45;
 
    bd_atr = (level == 10) + (fases[n_pant].descriptor & 63);
    bd_ink = bd_atr & 7;
    bd_pap = bd_atr >> 3;

    if (bd_ink < bd_pap)
    {
        i = bd_pap;
        bd_pap = bd_ink;
        bd_ink = i;
    }

    bd_atr = bd_ink + (bd_pap << 3);
 
    // Ea, ahora el Anju se queda contento :-P
 
    // Calculamos el tile de fondo segъn la altura:
    if (level < 4)
        t = 1;
    else if (level < 7)
        t = 5;
    else if (level < 9)
        t = 9;
    else
        t = 13;
 
    // Primero el fondo
    for (y = 0; y < 10; y++)
        for (x = 0; x < 12; x++)
        {
            draw_tiles (4 + (x<<1), 2 + (y<<1), bd_atr, t,0);
        }

    // Objetos
    for (i = 0; i < 10; i ++) {
        if (fases[n_pant].obj[i] != 0) {
            x = (u8) (fases[n_pant].obj[i] >> 12) & 15;
            y = (u8) (fases[n_pant].obj[i] >> 8) & 15;
            l = (u8) (fases[n_pant].obj[i] >> 4) & 15;
            n = (u8) (fases[n_pant].obj[i] >> 1) & 7;

            if ( (fases[n_pant].obj[i] & 1) == 0 )
            {
                // plataforma horizontal
                for (j = x; j < x + l; j ++)
                    draw_tiles (5 + (j<<1), 3 + (y<<1), bd_atr, 16 + t,1);
                for (j = x; j < x + l; j ++)
                    draw_tiles (4 + (j<<1), 2 + (y<<1), 64, 49 + (n<<2),0);
            } else {
                // plataforma vertical
                for (j = y; j < y + l; j ++)
                    draw_tiles (5 + (x<<1), 3 + (j<<1), bd_atr, 16 + t,1);
                for (j = y; j < y + l; j ++)
                    draw_tiles (4 + (x<<1), 2 + (j<<1), 64, 49 + (n<<2),0);
            }
        }
    }
 
    // Monedas:
    // Act 20091201 :: Sуlo pintamos monedas si la habitaciуn NO ha sido visitada :-)
 
    {
        num_monedas = 0;
 
        rectangulo.width = rectangulo.height = 2;
 
        for ( i = 0; i < 10; i ++)
        {
            // Primero copiamos los valores en nuestra estructura
            monedas [i].type = fases [n_pant].coin [i]?1:0;
 
            if (fases [n_pant].coin [i] != 0) {
                // Y ahora dibujamos
                x = (u8) (fases [n_pant].coin [i] >> 4);
                y = (u8) (fases [n_pant].coin [i] & 15);

                monedas[i].x=(4+(x<<1))<<3;
                monedas[i].y=(2+(y<<1))<<3;
     
                num_monedas ++;
            }
        }
    }
 
    // Cargamos ahora los objetos mуviles
    for (i = 0; i < 3; i ++) {
        if (fases [n_pant].movil [i] == 0)      // Enemigo desactivado.
            moviles [i].tipo = -1;
        else {
            v = (u8) (fases [n_pant].movil [i] & 1);
            n = (u8) (fases [n_pant].movil [i] >> 1) & 7;
            y = (u8) (fases [n_pant].movil [i] >> 4) & 15;
            t1 = (u8) (fases [n_pant].movil [i] >> 12) & 15;
            t2 = (u8) (fases [n_pant].movil [i] >> 8) & 15;
 
 
            moviles [i].x = moviles [i].t1 = 32 + (t1 << 4);
            moviles [i].t2 = 32 + (t2 << 4);
            moviles [i].y = 16 + (y << 4);
            moviles [i].vx = v*SPTW + 1;
            moviles [i].tipo = n;
 
            if (n != 3)
                moviles [i].next_frame = enem_frames [ 1 + (n << 1) ];
            moviles[i].current_frame=moviles[i].next_frame;
        }
    }
 
    for(i=0;i<24;i++)
    {
        sp_AttrSet(2,i,sp_AttrGet(26,i));
        sp_AttrSet(3,i,sp_AttrGet(27,i));
        sp_AttrSet(28,i,sp_AttrGet(2,i));
        sp_AttrSet(29,i,sp_AttrGet(3,i));
    }
}

i8 abs8 (i8 x)
{
    return x < 0 ? -x : x;
}

void move_moviles ()
{
    // Esto mueve los tres mуviles (en caso de estar definidos, o sea, con tipo != 0 
    u8 i;
 
    for (i = 0; i < 3; i ++)
        if ( moviles [i].tipo == 3)
        {
            // Fanty
            if ((player.x > moviles [i].rx) && (moviles[i].vx < 120*SPTW))
            {
                moviles [i].vx +=4*SPTW;
                moviles [i].next_frame = enem_frames [ 1 + (moviles [i].tipo << 1) ];
            }
            else if ((player.x < moviles [i].rx) && (moviles [i].vx > (i8)-120*SPTW))
            {
                moviles [i].vx -=4*SPTW;
                moviles [i].next_frame = enem_frames [ moviles [i].tipo << 1 ];
            }
 
            if ((player.y > moviles [i].ry) && (moviles [i].vy < 120*SPTW))
                moviles [i].vy +=4*SPTW;
            else if ((player.y < moviles [i].ry) && (moviles [i].vy > -120*SPTW))
                moviles [i].vy -=4*SPTW;
 
            moviles [i].rx += moviles [i].vx;
            moviles [i].ry += moviles [i].vy;
 
            moviles [i].x = (u8) (moviles [i].rx >> 6);
            moviles [i].y = (u8) (moviles [i].ry >> 6);
        }
        else if ( (moviles [i].tipo > -1) && !( player.estado & EST_EXIT ))
        {
            // Franky o Vampy o Wolfi
            moviles [i].x += moviles [i].vx;
            if ( moviles [i].x <= moviles [i].t1) {
                moviles [i].vx = abs8 (moviles [i].vx);
                moviles [i].next_frame = enem_frames [ 1 + (moviles [i].tipo << 1) ];
            }
 
            if ( moviles [i].x >= moviles [i].t2) {
                moviles [i].vx = -abs8 (moviles [i].vx);
                moviles [i].next_frame = enem_frames [ moviles [i].tipo << 1 ];
            }
        }
}

void game()
{
    u8 salida;
    u8 aux;
    u8 fade;
    static u8 sprnr;
    u16 i,j,idx;
    u16 type;
    u16 pause,pause_cnt;
    u16 arrow_yoff;

    salida=0;
    flag1 = 0;
    idx=0;
    player.x = 32 << 6;
    player.y = 144 << 6;
    player.vy = 0;
    player.g = 32*SPTW; //8;
    player.vx = 0;
    player.ax = 24*SPTW; //8;
    player.rx = 32*SPTW; //8;
    player.salto = 64*SPTW;
    player.cont_salto = 1;
    player.saltando = 0;
    player.frame = 0;
    player.subframe = 0;
    player.facing = 1;
    player.estado = EST_NORMAL;
    player.ct_estado = 0;
    player.ground=TRUE;
    player.nojump=FALSE;
 
    todo_a_negro ();
    pal_select(PAL_TILES);
    draw_screen(0);
    sp_UpdateNow();
    sprites_start();

    maincounter = 0;
    playing = 1;
 
    player.frame = uwol_r_2a;

    wyz_play_music(zona1_data);

    // Si la habitaciуn ya fue visitada, mostramos las salidas y al fantasmilla. 
    monedas_frame=0;
 
    fade=0;
    pause=FALSE;
    pause_cnt=25;
    arrow_yoff=0;

    while (playing)
    {
        maincounter ++;     // Como es un u8, irб siempre de 0 a 255, con ciclos potencias de 2.

        if(pause_cnt) pause_cnt--;
     
    	j = joyfunc(); // Leemos del teclado
    	
        if ((j^0xffff)&sp_ESC)
        {
            quit();
        }

    	if((j^0xffff)&sp_START)
    	{
    		if(!pause_cnt)
    		{
    			pause^=TRUE;
    			pause_cnt=25;
    			wyz_play_sound( 7, CANAL_FX );
    			if(pause)
    			{
                    pal_bright(7);                        
    			}
    			else
    			{
                    pal_bright(15);
    			}
    		}
    	}
    	
    	if(pause)
    	{
            if ((j ^ 0xFFFF) & sp_ESC)
            {
                playing = 0;
                salida = 3;
                flag1 = 3;
    			pause ^= TRUE;
    			pause_cnt = 25;                
            }

            vsync();
    		continue;
    	}

        sp_UpdateNow();

        sprnr=0;

        if ( !(player.estado & EST_MUR) )
        {
            move (j);
        }
        else
        {
            salida = 2;
            death_sequence ();
        }
 
        move_moviles ();

        x = player.x >> 6;
        y = player.y >> 6;

        /* Collisions & game mechanics: */
 
        if ( player.estado & EST_PARP )
        {
            // Duraciуn de la inmunidad:
            player.ct_estado --;
            if (player.ct_estado == 0)
            {
                player.estado = player.estado & (~EST_PARP);
            }
        }
 
        if ( !( player.estado & EST_PARP ) && !( player.estado & EST_MUR ) &&!cheat)        // Colisiуn con enemigos:
            for ( i = 0; i < 3; i ++ )
                if ( moviles [i].tipo > -1 && ( !( player.estado & EST_EXIT ) )  ) {
                    if (y >= moviles [i].y - 14 && y <= moviles [i].y + 14 && x >= moviles [i].x - 14 && x <= moviles [i].x + 14)
                    {
                        if ( !(player.estado & EST_NUDE) )
                        {
                            player.estado |= EST_NUDE;
                            player.estado |= EST_PARP;                  // Parpadeamos inmunes.
                            player.ct_estado = 32*3/2;                      // Tiempo de inmunidad.
 
                            do
                            {
                                xcami = 32 + ((rand () % 12) << 4);
                                ycami = 16 + ((1 + (rand () % 8)) << 4);
                            } while ( sp_AttrGet ( xcami >> 3, ycami >> 3) > 63 );
 
                            rectangulo.row_coord = ycami >> 3;
                            rectangulo.col_coord = xcami >> 3;
                            sp_GetTiles ( &rectangulo, tile_buffer12 );
                            draw_tiles (xcami >> 3, ycami >> 3, 22, 85,0);

                            // El jugador "rebota" una poca.
                            player.vy = - 4*SPTW * (player.salto);
                            player.vx = ((player.x >> 6) - moviles [i].x) * (16*SPTW);
                        } else {
                            player.vy = - 7 * (player.salto);
                            lives --;

                            player.estado |= EST_MUR;
                            player.frame = uwolmuete_1a;
                        }

                        wyz_play_sound (1, CANAL_FX);
                        moviles [i].vx =- moviles [i].vx;
                    }
                }

        if ( player.estado & EST_NUDE )     // Colisiуn con la camiseta
            if (y >= ycami - 14 && y <= ycami + 15 && x >= xcami - 15 && x <= xcami + 15)
            {
                wyz_play_sound (3, CANAL_FX);
 
                player.estado &= (~EST_NUDE);
                player.estado |= EST_PARP;
                player.ct_estado = 32*3/2;
 
                rectangulo.row_coord = ycami >> 3;
                rectangulo.col_coord = xcami >> 3;
                sp_PutTiles ( &rectangulo, tile_buffer12 );
            }
 
        // Vemos si colisionamos con alguna moneda.
        for (i = 0; i < 10; i ++)
            if (monedas [i].type != 0) {
                xx=monedas[i].x;
                yy=monedas[i].y;
                type=monedas[i].type==1?monedas_anim[monedas_frame]:monedas_take_anim[(monedas[i].type-2)/2];

                if (!slowpoke || monedas[i].type!=1)
                    add_sprite(xx,yy,type);

                if(monedas[i].type>1)
                {
                    monedas[i].type++;

                    if(monedas[i].type<12) monedas[i].y-=2; else monedas[i].y+=2;

                    if(monedas[i].type>20)
                    {
                        monedas [i].type = 0;
                    }
                }
                else
                {
                    if (y >= yy - 10 && y <= yy + 10 && x >= xx - 10 && x <= xx + 10) {
                        wyz_play_sound (5, CANAL_FX);
 
                        monedas [i].type = 2;
                        num_monedas --;
                        total_coins ++;

                        if(slowpoke)
                        {
                            rectangulo.row_coord = (yy>>3);
                            rectangulo.col_coord = (xx>>3);
                            sp_PutTiles ( &rectangulo, tile_buffer [i] );
                        }
                    }
                }
            }

        if(!(maincounter&3))
        {
            monedas_frame++;
            if(monedas_frame==10)
            {
                monedas_frame=0;
            }
        }

        if(player.estado&EST_EXIT)
        {
        	if ( sp_AttrGet ( 5, 19) < 64 && sp_AttrGet ( 6, 19) < 64)
        	{
                add_sprite((5<<3),(18<<3)+arrow_yoff,arrow_1a);
        	}

        	if ( sp_AttrGet (25, 19) < 64 && sp_AttrGet (26, 19) < 64)
        	{
                add_sprite((25<<3),(18<<3)+arrow_yoff,arrow_1a);
        	}

        	if(!(maincounter&3))
        	{
        		arrow_yoff++;
        		if(arrow_yoff>=3) arrow_yoff=0;
        	}
        }
        
        if(num_monedas==0)
        {
            if ( !(player.estado & EST_EXIT) )
            {
                if ( sp_AttrGet ( 5, 19) < 64 && sp_AttrGet ( 6, 19) < 64)
                    draw_tiles ( 5, 20, 86, level < 10 ? 113 : 123 ,0);
                if ( sp_AttrGet (25, 19) < 64 && sp_AttrGet (26, 19) < 64)
                    draw_tiles (25, 20, 86, level < 10 ? 117 : 123 ,0);
 
                player.estado |= EST_EXIT;
 
                if(salida!=2)
                {
                    wyz_play_sound (9, 0 /* CANAL_FX*/ );
                }
            }
        }

        // Retardo para quitar cafeнna cuando no hay bishos.
        if ( player.estado & EST_EXIT )
            for (i = 0; i < 126; i ++)
                xt ++;

        // Salir IZQ/DER
        if ( player.estado & EST_EXIT_LEFT )
        {
            salida = 0;
            playing = 0;
        }
        else if ( player.estado & EST_EXIT_RIGHT )
        {
            salida = 1;
            playing = 0;
        }
 
        // Vidas extra a los 1000 y a los 2500
        aux = 0;

        if (aux)
        {
            player.estado |= EST_PARP;
            if(lives<99) lives ++;
            player.ct_estado = 32*3/2;
            wyz_play_sound (3, CANAL_FX);
        }
 
        /* Render */
        if ( !(player.estado & EST_EXIT) )
            for ( i = 0; i < 3; i ++ )
                if ( moviles [i].tipo > -1)
                {
                    add_sprite((moviles [i].x), moviles [i].y, moviles [i].current_frame);
                    moviles [i].current_frame = moviles [i].next_frame;
                }
 
        if ( !(player.estado & EST_PARP) || !(maincounter & 1) )
            add_sprite ((x), y,player.frame);

        end_sprite();
    }
 
    wyz_stop_sound ();

    fade_out ();
    swap_screen();
}

void uwol_preinit_variables(void)
{
    play = 0;
    playing = 1;
    maincounter = 0;
    slowpoke=0;
}

int main ()
{
    sp_Init();
    fases_init();
    uwol_preinit_variables();
    fade_screen(0);
    game();

    return 0;
}
