
u8 warp_palette[30 * 3];
u16 sprites_pal[16];
u16 tilesa_pal[16];
u16 tilesb_pal[16];
u16 tilesc_pal[16];
u16 needed_pal[64];
const u16 white_pal[16] = {0x6318,0x6318,0x6318,0x6318,
                           0x6318,0x6318,0x6318,0x6318,
                           0x6318,0x6318,0x6318,0x6318,
                           0x6318,0x6318,0x6318,0x6318};

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

/* initilize VDP */

void init_vdp(void)
{

}

void screen_enable(u16 enable)
{

}

void unpack_screen(const u8 id,u8 pal)
{
    draw_image(id);
    pal_select(pal);
    swap_screen();
    fade_from_black();
}

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

