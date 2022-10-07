#include "sprinter.h"
#include "splib.h"

void main()
{
    sprites_start();

    wyz_play_music (0);

    unpack_screen(0, 2);

    while(1)
    {
        sp_UpdateNow();
		
        if (sp_GetKey())
        {
            break;
        }
    }

    quit();
}