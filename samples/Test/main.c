#include "sprinter.h"
#include "splib_evo.h"
#include "evo_ts.h"

#include "resources.h"

struct sp_Rect spritesClipValues;
struct sp_Rect *spritesClip;

#define CANAL_FX        1

void make_black()
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
    make_black();
}

void wait_for_a_key(i16 timer)
{ 
    i8 res = 1;

    if (timer<0)
    {
        timer=-timer;
        res=2;
    }

    while(timer>0)
    {
        sp_UpdateNow();
		
        if (sp_GetKey() && res == 1)
        {
            res = 0;
            break;
        }

        timer--;
    }
}

void main (void)
{
    spritesClipValues.row_coord = 2;
    spritesClipValues.col_coord = 4;
    spritesClipValues.height = 20;
    spritesClipValues.width = 24;
    spritesClip = &spritesClipValues;
    sprites_clip(1);
    sprites_start();

    pal_bright(0);
    unpack_screen(IMG_MOJON, PAL_MOJON);
    wyz_play_sound(7, CANAL_FX);
    wait_for_a_key(200);
    fade_out();
    pal_select(PAL_CREDITS);
    unpack_screen(IMG_CREDITS, PAL_CREDITS);
    wyz_play_sound (7, CANAL_FX);
    wait_for_a_key(500);
    fade_out();


    /*pal_bright(15);

    u8 i;

	sprites_start();
	fases_init();
	clear_screen(0);

	for (i = 0; i < 255; i++)
	{
		draw_tile (i % 32, i / 32, i);
	}

	//pal_select(0);
	swap_screen();
	espera_activa(500);

	draw_image(0);
	//pal_select(2);
	espera_activa(200);

	draw_image(1);
	//pal_select(3);
	espera_activa(200);

	draw_image(2);
	//pal_select(4);
	espera_activa(200);

	draw_image(3);
	//pal_select(5);
	espera_activa(200);

	draw_image(4);
	//pal_select(6);
	espera_activa(200);

	draw_image(5);
	//pal_select(7);
	espera_activa(200);

	draw_image(6);
	//pal_select(8);
	espera_activa(200);

	pal_select(0);
	//draw_screen(0);
	swap_screen();
	wyz_play_music(1);
	while (1) 
	{
		maincounter++;
        for (i = 0; i < 10; i ++)
        {	
            if (monedas[i].type != 0)
            {
                xx = monedas[i].x;
                yy = monedas[i].y;
                type = monedas[i].type == 1 ? monedas_anim[monedas_frame] :
                                              monedas_take_anim[(monedas[i].type - 2) / 2];
                //if(!slowpoke || monedas[i].type!=1)
                add_sprite(xx, yy, type);
                if (monedas[i].type > 1)
                {
                    monedas[i].type++;
//                    monedas[i].type++;

                    if (monedas[i].type < 12) monedas[i].y -= 2; else monedas[i].y += 2;
                    if (monedas[i].type > 20)
                    {
                        monedas [i].type = 0;
//                        sp_MoveSprAbs(monedas[i].sp,type,0,256,0);
                       // sprnr--;
//                        sp_DeleteSpr(monedas[i].sp);
//                        monedas[i].sp=NULL;
                    }
                }
                else
                {
                }
            }
        }
        if (!(maincounter & 3))
        {
            monedas_frame++;
            if (monedas_frame == 10) monedas_frame = 0;
//            monedas_frame=(monedas_frame+1)%(sizeof(monedas_anim)/sizeof(u16));
        }
        end_sprite();
        swap_screen();		
	}*/
}