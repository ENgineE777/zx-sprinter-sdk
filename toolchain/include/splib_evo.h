//#include "genesis.h"

/* masks for joystick functions */

#define sp_START		0x0020
#define sp_FIRE			0x0010
#define sp_RIGHT		0x0008
#define sp_LEFT			0x0004
#define sp_DOWN			0x0002
#define sp_UP			0x0001
#define sp_ESC          0x0080
/* sprite types */

#define sp_MASK_SPRITE	0x00

/* Colour Attributes */

#define TRANSPARENT		0x80

/* Clear Rectangle Flags */

#define sp_CR_TILES		0x01

/* Print String Struct Flags */

#define sp_PSS_INVALIDATE	0x01

/* SP's Sprite Struct */

struct sp_SS {
   u8 active;
   i16 ptr;
   i16 x;
   i16 y;
   u16 tile;
};

/* Small Rectangles with 8-bit coordinates (used by SP where units are characters) */

struct sp_Rect {
   u8 row_coord;     /* coordinate of top left corner */
   u8 col_coord;
   u8 height;        /* size */
   u8 width;
};

u8 sp_tile_buf[32*24];
u8 sp_attr_buf[32*24];

/*const u8 spmask[] = {0x00,0x2e,0x10,0x02,0x00,0x34,
					 0x40,0x2e,0x10,0x02,0x00,0x34,
					 0x80,0x2e,0x10,0x02,0x00,0x34,
					 0x00,0x2e,0xe0,0x02,0x00,0x34,
					 0x40,0x2e,0xe0,0x02,0x00,0x34,
					 0x80,0x2e,0xe0,0x02,0x00,0x34};
const u8 splp[] =   {0x00,0x40,0x00,0x00,0x00,0x00,
 					 0x00,0x40,0x00,0x00,0x00,0x00,
 					 0x00,0x40,0x00,0x00,0x00,0x00};
*/

#define SPRITES_MAX	20

struct sp_SS spriteList[SPRITES_MAX];

//u8 spriteBuf[512];


void sp_Init(void)
{
	u16 i;
	
	for (i = 0; i < 32 * 24; i++)
	{
		sp_tile_buf[i] = 0;
		sp_attr_buf[i] = 0;
	}
	
	//for(i=0;i<SPRITES_MAX;i++) spriteList[i].active=FALSE;
//	for(i=0;i<sizeof(spriteBuf);i++) spriteBuf[i]=0;
}

void sp_AttrSet(i16 x,i16 y,u8 a)
{
	if(y<24) sp_attr_buf[(y<<5)+x]=a;
}

u8 sp_AttrGet(i16 x,i16 y)
{
	return (y<24?sp_attr_buf[(y<<5)+x]:0);
}

void sp_TileSet(u8 col,u8 row,u16 tile)
{
//u8 pal,layer;
//	layer = 0;
//    if(tile>80) pal=3; else if(tile>48) pal=2; else pal=1;
//    if(row<2||row>=22||col<2||col>=30) layer=1;

//	drawtile(col, row, tile,pal,layer);
	draw_tile(col, row, tile);
    
}

/* background tiles */

void sp_PrintAtInv(u8 row, u8 col, u8 colour, u8 udg)
{
    i16 ptr;
    
    ptr=(row<<5)+col;
    sp_attr_buf[ptr]=colour;
    sp_tile_buf[ptr]=udg;
//    sp_TileSet(col,row,udg);
	draw_tile(col, row, udg);
}

void sp_GetTiles(struct sp_Rect *r, u8 *dest)
{
	u16 i,j,ptr;
	
	ptr=(r->row_coord<<5)+r->col_coord;
	
	for(i=0;i<r->height;i++)
	{
		for(j=0;j<r->width;j++)
		{
			*dest++=sp_tile_buf[ptr++];
		}
		ptr+=(32-r->width);
	}
}

void sp_PutTiles(struct sp_Rect *r, u8 *src)
{
	u16 i,j,ptr;
	
	ptr=(r->row_coord<<5)+r->col_coord;
	
	for(i=0;i<r->height;i++)
	{
		for(j=0;j<r->width;j++)
		{
			sp_tile_buf[ptr]=*src++;
			sp_TileSet(r->col_coord+j,r->row_coord+i,sp_tile_buf[ptr++]);
		}
		ptr+=(32-r->width);
	}
}

/* sprites */

struct sp_SS *sp_CreateSpr(u8 type, u8 rows, u16 graphic, u8 plane, u8 extra)
{
	return 0;
}
/*struct sp_SS *sp_CreateSpr(u8 type, u8 rows, u16 graphic, u8 plane, u8 extra)
{
	u16 i;
	
	for(i=0;i<SPRITES_MAX;i++)
	{
		if(!spriteList[i].active)
		{
		    spriteList[i].active=TRUE;
		    spriteList[i].ptr=i;
		    spriteList[i].x=256;
		    spriteList[i].y=256;
		    spriteList[i].tile=graphic;
		    return &spriteList[i];
    	}
    }
    
    return NULL;
}*/

void sp_MoveSprAbs(struct sp_SS *sprite, struct sp_Rect *clip, u16 animate, u8 row, u8 col, u8 hpix, u8 vpix)
{
}
/*void sp_MoveSprAbs(struct sp_SS *sprite, struct sp_Rect *clip, u16 animate, u8 row, u8 col, u8 hpix, u8 vpix)
{
	if(sprite)
	{
//		if(animate<33+16) animate+=PALETTE_NUM(1);
		if(row<24)
		{
			sprite->x=(col<<3)+hpix+(col?0:300);
			sprite->y=(row<<3)+vpix+(col?0:300);
		}
		sprite->tile=animate;
	}
}*/

void sp_DeleteSpr(struct sp_SS *sprite)
{
	if(sprite)
	{
		sprite->active=FALSE;
	}
}

/* updater */

void sp_UpdateNow(void)
{
	end_sprite();
	swap_screen();
}
/*
void sp_UpdateNow(void)
{
	u8 i,cnt,spnum;
	u8 *buf;
	
	cnt=0;
	buf=spriteBuf;
	
	for(i=0;i<SPRITES_MAX;i++) if(spriteList[i].active) cnt++;
	
	spnum = cnt;
	if(!cnt)
	{
		*buf++=0;
		*buf++=0;
		*buf++=0;
		*buf++=0;
		*buf++=0;
		*buf++=0;
	}
	
	memcpy(buf,&splp[0],6);
	buf+=6; spnum++;
	for(i=SPRITES_MAX;i>0;i--)
	{
        if(!spriteList[i-1].active) continue;
        cnt--;
        *buf++=spriteList[i-1].y & 0xff;
        *buf++=0x22 | (spriteList[i-1].y >> 8);
        *buf++=spriteList[i-1].x & 0xff;
        *buf++= ((spriteList[i-1].tile & 0x8000) >> 8) | 2 | (spriteList[i-1].x >> 8);
        *buf++=spriteList[i-1].tile & 0xff;
        *buf++= ((spriteList[i-1].tile >> 8) & 0x7);
	}
	memcpy(buf,&splp[0],12);
	spnum+=2;
	copy_sprite(spriteBuf,spnum);
	pal_change();
 	vsync();
}*/

void sp_ClearRect(struct sp_Rect *area, u8 colour, u8 udg, u8 flags)
{
	u16 i,j;
	
	for(i=0;i<24;i++)
	{
		for(j=0;j<32;j++)
		{
			sp_PrintAtInv(i,j,0,0);
		}
	}
}

/* input */

u8 sp_GetKey(void)
{
    return (joystick()&(JOY_FIRE|JOY_START))?1:0;
}

/* additional stuff */

void sp_SetSpriteClip(struct sp_Rect *clip)
{
    struct sp_Rect empty;
    u16 i;
    
    empty.col_coord=0;
    empty.row_coord=0;
    empty.width=32;
    empty.height=24;
    
    if(!clip) clip=&empty;

    for(i=0;i<24;i++)
    {
//	    vram_fill(layer,x,yPLANE_B_ADR+((i*PLANE_WDT)<<1),0x8000+112+PALETTE_NUM(3),32,0);
//      tmap_fill(tmap_addr, value, len, delta);
//	    tmap_fill(128+(i<<8),0x3000 | 112,32,0);
    }
    
    for(i=0;i<clip->height;i++)
    {
//	    tmap_fill(128+(((clip->row_coord+i)<<8)+((clip->col_coord)<<1)),0,clip->width,0);
    } 
}

void sp_HideAllSpr(void)
{

}
/*void sp_HideAllSpr(void)
{
	u16 i;
	
	for(i=0;i<SPRITES_MAX;i++)
	{
		if(spriteList[i].active)
		{
			spriteList[i].x=0;
			spriteList[i].y=300;
		}
	}
	sp_UpdateNow();
}
*/