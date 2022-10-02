#include "sprinter.h"
#include "splib_evo.h"
#include "evo_ts.h"

#define CANAL_FX        1

#define ROCK_SPRITE   5
#define START1_SPRITE 6
#define START2_SPRITE 7

#define ROCK_SPEED rand8() % 10 + 2
#define BIG_ROCK_SPEED rand8() % 4 + 2
#define BIG_ROCK_TIMER rand8() % 64 + 32
#define STAR_SPEED rand8() % 12 + 2

#define SPACESHIP_X 60
#define SPACESHIP_Y 75.0f
#define SPACESHIP_WAVE_HEIGHT 35.0f

struct sp_Rect *sp_ClipStruct;

struct sp_Rect spritesClipValues;
struct sp_Rect *spritesClip;

u8 rand8()
{
    return (u8)(rand16());
}

void make_black()
{
    i16 i,j;
 
    for(i=0;i<24;i++)
    {
        for(j=0;j<32;j++) sp_AttrSet(j,i,0);
    }
}

typedef struct
{
    u8 x, y, speed, sprite;
} Star;

u8 stars_count = 16;
Star stars[16];

typedef struct
{
    u8 x, y, speed;
} Rock;

u8 rocks_count = 4;
Rock rocks[4];

typedef struct
{
    i16 x;
    u8 y, speed;
} BigRock;

int big_rock_timer;
BigRock big_rock;

u8 spaceship_timer = 0;

void draw_big_rock()
{
    u8 drawX;
    u8 y1 = big_rock.y;
    u8 y2 = big_rock.y + 16;
    u8 y3 = big_rock.y + 32;

    i16 x = big_rock.x;

    if (x > 255)
    {
        return;
    }

    if (x >= 0)
    {
        drawX = (u8)x;

        add_sprite(drawX, y1, 0);
        add_sprite(drawX, y2, 16);
        add_sprite(drawX, y3, 32);
    }

    x += 16;

    if (x > 255)
    {
        return;
    }

    if (x >= 0)
    {
        drawX = (u8)x;

        add_sprite(drawX, y1, 1);
        add_sprite(drawX, y2, 17);
        add_sprite(drawX, y3, 33);
    }

    x += 16;

    if (x > 255)
    {
        return;
    }

    if (x >= 0)
    {
        drawX = (u8)x;

        add_sprite(drawX, y1, 2);
        add_sprite(drawX, y2, 18);
        add_sprite(drawX, y3, 34);
    }
}

void init()
{
    rand();

    u8 i;

    for (i = 0; i < stars_count; i++)
    {
        Star* star = &stars[i];

        star->x = rand8();
        star->y = rand8() % 192;
        star->speed = STAR_SPEED;
        star->sprite = rand8() % 2 ? START1_SPRITE : START2_SPRITE;
    }

    for (i = 0; i < rocks_count; i++)
    {
        Rock* rock = &rocks[i];

        rock->x = rand8();
        rock->y = rand8() % 192;
        rock->speed = ROCK_SPEED;
    }

    big_rock_timer = BIG_ROCK_TIMER;

    big_rock.x = 255;
    big_rock.y = rand8() % 144;
    big_rock.speed = BIG_ROCK_SPEED;
}

void main()
{
    sprites_start();

    wyz_play_music (0);

    pal_bright(15);
    unpack_screen(0, 2);

    init();

    u8 i;
    u8 spaceship_y;

    while (1)
    {
        //stars
        for (i = 0; i < stars_count; i++)
        {
            Star* star = &stars[i];

            if (star->x < star->speed)
            {
                star->x = 255;
                star->y = rand8() % 192;
                star->speed = STAR_SPEED;
                star->sprite = rand8() % 2 ? START1_SPRITE : START2_SPRITE;
            }
            else
            {
                star->x -= star->speed;
            }

            add_sprite(star->x, star->y, star->sprite);
        }

        //rocks
        for (i = 0; i < rocks_count; i++)
        {
            Rock* rock = &rocks[i];

            if (rock->x < rock->speed)
            {
                rock->x = 255;
                rock->y = rand8() % 192;
                rock->speed = ROCK_SPEED;
            }
            else
            {
                rock->x -= rock->speed;
            }

            add_sprite(rock->x, rock->y, ROCK_SPRITE);
        }

        //big rock

        if (big_rock_timer > 0)
        {
            big_rock_timer--;       
        }
        else
        {
            if (big_rock.x - big_rock.speed < -48)
            {
                big_rock_timer = BIG_ROCK_TIMER;

                big_rock.x = 255;
                big_rock.y = rand8() % 144;
                big_rock.speed = BIG_ROCK_SPEED;
            }
            else
            {
                big_rock.x -= big_rock.speed;

                draw_big_rock();
            }
        }
        
        //ship
        spaceship_timer++;

        float lerp = 0.0f;

        if (spaceship_timer < 100)
        {
            float k = (float)(spaceship_timer < 50 ? spaceship_timer : (100 - spaceship_timer)) / 50.0f;
            lerp = (1 - (1 - k) * (1 - k));
        }
        else
        if (spaceship_timer < 200)
        {
            float k = (float)(spaceship_timer < 150 ? (spaceship_timer - 100): (200 - spaceship_timer)) / 50.0f;
            lerp = -(1 - (1 - k) * (1 - k));
        }        
        else
        {
            spaceship_timer = 0;
        }

        lerp *= SPACESHIP_WAVE_HEIGHT;
        lerp += SPACESHIP_Y;

        add_sprite(SPACESHIP_X, (u8)lerp, 3);
        add_sprite(SPACESHIP_X + 16, (u8)lerp, 4);

        end_sprite();

        swap_screen();
    }
}