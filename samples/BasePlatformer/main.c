#include "sprinter.h"
#include "splib.h"

void main()
{
    sprites_start();

    wyz_play_music (0);

    unpack_screen(0, 2);


    u8 i,j;

    pal_select(0);
    pal_bright(15);

    while(1)
    {
        for (i = 0; i < 32; i++)
        {
            for (j = 0; j < 24; j++)
            {
                draw_tile(i, j, 2);
            }
        }

        sp_UpdateNow();
		
        if (sp_GetKey())
        {
            break;
        }
    }

    quit();
}