#define _CRT_SECURE_NO_WARNINGS
#include <stdlib.h>
#include <stdio.h>
#include <memory.h>
#include <string.h>


struct {
	unsigned char* data;
	int offset;
	int bpp;
	int wdt,hgt;
	bool flip;
} BMP;

unsigned char sprinter_mem[256 * 16384];
unsigned char mem[65536];

FILE *fileBatMLZ;
FILE *fileBatSCL;

unsigned char *tileData;

int fileCnt;

struct {
	int tile;
	int wdt,hgt;
} IMGLIST[256];

#define STARTUP_ADR	0xe000
#define STACK_SIZE	0x0400

#define MUS_COUNT	0x49fe
#define SMP_COUNT	0x49ff
#define MUSLIST_ADR	0x4a00	//3*256
#define SMPLIST_ADR	0x4d00	//4*256
#define SFX_ADR		0x5100

#define PAL_ADR		0x0000
#define IMGLIST_ADR	0x1000

#define TSPR_ADR	0xfa00

//фиксированные номера страниц

#define SPRBUF_PAGE	8	//4 страницы
#define SPRTBL_PAGE	6	//параметры спрайтов

#define CC_PAGE0	0	//код
#define CC_PAGE1	1
#define CC_PAGE2	2
#define CC_PAGE3	3

#define SND_PAGE	4	//код звука и эффекты
#define PAL_PAGE	5	//палитры

#define GFX_PAGE	7	//графика начинается с фиксированной страницы

#define PACK_PIXELS(col1,col2) (((col1)&7)|(((col1)&8)<<3)|(((col2)&7)<<3)|(((col2)&8)<<4))



void clear_mem (void)
{
	memset(mem, 0, 65536);
}

void clear_bmp (void)
{
	memset(BMP.data, 0, 4 * 1024 * 1024);
}


int get_hex(char n)
{
	if(n>='0'&&n<='9') return n-'0';
	if(n>='a'&&n<='f') return n-'a'+10;
	if(n>='A'&&n<='F') return n-'A'+10;

	return -1;
}



int get_hex_byte(char *str)
{
	return (get_hex(str[0])<<4)+get_hex(str[1]);
}



//чтение Intel HEX файла в память, без всяких проверок

int load_ihx(const char* name)
{
	FILE *file;
	char line[1024];
	int i,off,ptr,len,size;

	file = fopen(name,"rt");

	if (!file) return 0;

	size = 0;

	while (fgets(line, sizeof(line), file) != NULL)
	{
		len = get_hex_byte(&line[1]);
		ptr = (get_hex_byte(&line[3]) << 8) + get_hex_byte(&line[5]);
		off = 9;

		for (i = 0; i < len; i++)
		{
			mem[ptr++] = get_hex_byte(&line[off]);
			off += 2;
		}
		
		if (ptr > size) size = ptr;
	}

	fclose(file);

	return size;
}



bool load_bin(int adr,const char* name)
{
	FILE *file;
	int size;

	file=fopen(name,"rb");

	if(!file) return false;

	fseek(file,0,SEEK_END);
	size=ftell(file);
	fseek(file,0,SEEK_SET);

	if(adr+size>0x10000)
	{
		fclose(file);
		return false;
	}

	fread(mem+adr,size,1,file);
	fclose(file);

	return true;
}



//проверка страницы на наличие ненулевых данных

bool page_is_empty(int page)
{
	int i;

	page<<=14;

	for(i=0;i<16384;i++)
	{
		if(mem[i+page]) return false;
	}

	return true;
}



bool page_save(int slot,int page)
{
	char name[1024];
	FILE *file;

	fprintf(fileBatMLZ,"megalz page_%i.bin >nul\n",page);
	fprintf(fileBatMLZ,"call _getsize.bat page_%i.bin.mlz %i\n",page,page);
	fprintf(fileBatSCL,"trdtool + disk.scl page_%i.bin.mlz\n",page);

	sprintf(name,"_temp_/page_%i.bin",page);

	file=fopen(name,"wb");

	if(!file) return false;

	fwrite(&mem[slot<<14],16384,1,file);
	fclose(file);

	fileCnt++;

	return true;
}



void error(void)
{
	fclose(fileBatMLZ);
	fclose(fileBatSCL);

	if(tileData) free(tileData);
}



bool load_palette(const char* filename, unsigned char* dst)
{
	FILE *file;
	unsigned char bmp[1078];
	int i,pp,size,bpp,r,g,b;
	int colors;

	file = fopen(filename,"rb");

	if (!file) return false;

	fseek(file, 0, SEEK_END);
	size = ftell(file);
	if (size > 1078) size = 1078;
	fseek(file, 0, SEEK_SET);
	fread(bmp, size, 1, file);
	fclose(file);
	
	if (bmp[0] != 'B' || bmp[1] != 'M')
	{
		printf("ERR: Not BMP file format (%s)\n", filename);
		return false;
	}
	
	bpp = bmp[28] + (bmp[29] << 8);
	
	if (bpp != 4 && bpp != 8)
	{
		printf("ERR: Only uncompressed 16 and 256 colors BMP supported (%s)\n",filename);
		return false;
	}

	colors = (bpp == 4) ? 16 : 256;
	pp=54;

	memset(&dst[0], 0, 768);

	for (i = 0; i < colors; i++)
	{
		b = bmp[pp++];
		g = bmp[pp++];
		r = bmp[pp++];
		pp++;

		dst[i]       = b;
		dst[i + 256] = g;
		dst[i + 512] = r;		
	}

	return true;
}



//inline void convert_tile(unsigned char* tile,int tx,int ty)
inline void convert_tile(int tile, int tx, int ty)
{
	int i,j,pp,pd;
	unsigned char chr[8][8];
	
	switch(BMP.bpp)
	{
	case 4:
		{
			pd = BMP.flip ? BMP.offset + (ty << 3) * (BMP.wdt >> 1) + (tx << 2) : 
			                BMP.offset + (BMP.hgt - 1 - (ty << 3)) * (BMP.wdt >> 1) + (tx << 2);
			
			for (i = 0; i < 8; ++i)
			{
				pp = pd;

				for (j = 0; j < 8; j += 2)
				{
					chr[i][j + 0] = BMP.data[pp] >> 4;
					chr[i][j + 1] = BMP.data[pp] & 15;
					++pp;
				}

				pd += BMP.flip ? (BMP.wdt >> 1) : 0 - (BMP.wdt >> 1);
			}
		}
		break;

	case 8:
		{
			pd = BMP.flip ? BMP.offset + (ty << 3) * BMP.wdt + (tx << 3) :
			                BMP.offset + (BMP.hgt - 1 - (ty << 3)) * BMP.wdt + (tx << 3);
			
			for (i = 0; i < 8; ++i)
			{
				pp = pd;

				for (j = 0; j < 8; ++j)
				{
					chr[i][j] = BMP.data[pp++];
				}

				pd += BMP.flip ? BMP.wdt : 0 - BMP.wdt;
			}
		}
		break;
	}

	pp = 0;

	pp = (GFX_PAGE * 16384) + ((tile & 0x1F) << 3) + ((tile & 0xFFE0) << 6);
	for (i = 0; i < 8; ++i)
	{
		for (j = 0; j < 8; ++j)
		{
			sprinter_mem[pp + j] = chr[i][j];
		}
		pp += 256; 
	}
}

///
inline void convert_sprite(int spr_page_start, int tile, int tx, int ty)
{
	int i,j,pp,pd;
	unsigned char chr[16][16];
	
	switch(BMP.bpp)
	{
	case 8:
		{
			pd = BMP.flip ? BMP.offset + (ty << 4) * BMP.wdt + (tx << 4) :
			                BMP.offset + (BMP.hgt - 1 - (ty << 4)) * BMP.wdt + (tx << 4);
			
			for (i = 0; i < 16; ++i)
			{
				pp = pd;

				for (j = 0; j < 16; ++j)
				{
					chr[i][j] = BMP.data[pp++];
				}

				pd += BMP.flip ? BMP.wdt : 0 - BMP.wdt;
			}
		}
		break;
	}

	pp = 0;

	pp = (spr_page_start * 16384) + ((tile & 0x0F) << 4) + ((tile & 0xFFF0) << 8);
	for (i = 0; i < 16; ++i)
	{
		for (j = 0; j < 16; ++j)
		{
			sprinter_mem[pp + j] = chr[i][j];
		}
		pp += 256; 
	}
}


unsigned int read_dword(unsigned char* data)
{
	return data[0] + (data[1] << 8) + (data[2] << 16) + (data[3] << 24);
}



unsigned int read_word(unsigned char* data)
{
	return data[0] + (data[1] << 8);
}



//unsigned char* load_graphics(const char* filename, int tile_ptr, int &tilecnt, int &tsizex, int &tsizey)
int load_graphics(const char* filename, int tile_ptr, int &tilecnt, int &tsizex, int &tsizey)
{
	FILE *file;
	int i,j,ptr,rle,size,tssize;
	unsigned char* tileset;

	file = fopen(filename, "rb");

	if (!file) return 0;

	fseek(file, 0, SEEK_END);
	size = ftell(file);
	fseek(file, 0, SEEK_SET);

	if (size > (4 *1024 * 1024))
	{
		fclose(file);
		printf("ERR: BMP file too large (%s)\n",filename);
		return 0;
	}

	//BMP.data=(unsigned char*)malloc(size);
	clear_bmp();
	fread(BMP.data, size, 1, file);
	fclose(file);
	
	if (BMP.data[0] != 'B' || BMP.data[1] != 'M')
	{
		printf("ERR: Not BMP file format (%s)\n", filename);
		return 0;
	}
	
	BMP.offset = read_dword(&BMP.data[10]);
	BMP.wdt = read_dword(&BMP.data[18]);
	BMP.hgt = read_dword(&BMP.data[22]);
	BMP.bpp = read_word (&BMP.data[28]);
	rle = read_dword(&BMP.data[30]);
	
	if ((BMP.wdt & 7) || (BMP.hgt & 7))
	{
		printf("ERR: Width and height should be 8px aligned (%s)\n", filename);
		return 0;
	}

	if (rle != 0 || (BMP.bpp != 4 && BMP.bpp != 8))
	{
		printf("ERR: Only uncompressed 16 and 256 colors BMP supported (%s)\n", filename);
		return 0;
	}

	
	BMP.flip = (BMP.hgt > 0) ? false : true;
	if (BMP.flip) BMP.hgt = 0 - BMP.hgt;

	tsizex = BMP.wdt >> 3;
	tsizey = BMP.hgt >> 3;

	tilecnt = tsizex * tsizey; //(BMP.wdt>>3)*(BMP.hgt>>3);
	//tssize=tilecnt<<5;
	//tileset=(unsigned char*)malloc(tssize);
	
	ptr=0;
	
	for (i = 0; i < tsizey; i++)
	{
		for(j = 0; j < tsizex; j++)
		{
			//convert_tile(&tileset[ptr],j,i);
			convert_tile(tile_ptr, j, i);
			tile_ptr++; //ptr+=32;
		}
	}

	return 1; //tileset;
}


int load_sprites(const char* filename, int spr_page_start, int tile_ptr, int &tilecnt)
{
	FILE *file;
	int i,j,ptr,rle,size,tssize;
	int tsizex, tsizey;
	unsigned char* tileset;

	file = fopen(filename, "rb");

	if (!file) return 0;

	fseek(file, 0, SEEK_END);
	size = ftell(file);
	fseek(file, 0, SEEK_SET);

	if (size > (4 *1024 * 1024))
	{
		fclose(file);
		printf("ERR: BMP file too large (%s)\n",filename);
		return 0;
	}

	//BMP.data=(unsigned char*)malloc(size);
	clear_bmp();
	fread(BMP.data, size, 1, file);
	fclose(file);
	
	if (BMP.data[0] != 'B' || BMP.data[1] != 'M')
	{
		printf("ERR: Not BMP file format (%s)\n", filename);
		return 0;
	}
	
	BMP.offset = read_dword(&BMP.data[10]);
	BMP.wdt = read_dword(&BMP.data[18]);
	BMP.hgt = read_dword(&BMP.data[22]);
	BMP.bpp = read_word (&BMP.data[28]);
	rle = read_dword(&BMP.data[30]);
	
	if ((BMP.wdt & 15) || (BMP.hgt & 15))
	{
		printf("ERR: Width and height should be 16px aligned (%s)\n", filename);
		return 0;
	}

	if (rle != 0 || BMP.bpp != 8)
	{
		printf("ERR: Sprite sheet should be 256 colors uncompressed BMP (%s)\n", filename);
		return 0;
	}

	
	BMP.flip = (BMP.hgt > 0) ? false : true;
	if (BMP.flip) BMP.hgt = 0 - BMP.hgt;

	tsizex = BMP.wdt >> 4;
	tsizey = BMP.hgt >> 4;

	tilecnt = tsizex * tsizey; 
	
	ptr=0;
	
	for (i = 0; i < tsizey; i++)
	{
		for(j = 0; j < tsizex; j++)
		{
			convert_sprite(spr_page_start, tile_ptr, j, i);
			tile_ptr++; //ptr+=32;
		}
	}

	return 1; //tileset;
}


void trim_str(char* line)
{
	unsigned int i;

	for(i=0;i<strlen(line);i++)
	{
		if(line[i]<0x20)
		{
			line[i]=0;
			break;
		}
	}
}



int main(int argc,char* argv[])
{
	const char cc_page[4]={CC_PAGE0,CC_PAGE1,CC_PAGE2,CC_PAGE3};
	FILE *list,*file;
	char line[1024];
	unsigned char *data;
	int i,pp,off,ptr,size,page,img_count;
	int mus_offset[256],mus_page[256];
	int smp_offset[256],smp_page[256],smp_pitch[256];
	int mus_count,mus_page_start,mus_pages,gfx_pages;
	int code_size,code_pages;
	int spr_page_start,spr_pages;
	int smp_page_start,smp_pages,smp_count;
	int tile_ptr,tile_cnt;
	int wdt,hgt,cnt,pitch;
	int tile_load;
	int pages_all;

	printf("EVOSDK Resource Compiler by Shiru and Alone Coder 03'12\n");

	if(argc<3)
	{
		printf("EVOSDK Resource Compiler by Shiru and Alone Coder 03'12\n");
		printf("Error: Some parameters are missing\n");
		return 1;
	}

	BMP.data = (unsigned char*)malloc(4 * 1024 * 1024);

	//код программы

	printf("Load ihx\n");

	clear_mem();

	size = load_ihx(argv[1]);
	
	if (!size)
	{
		printf("Error: Can't load Intel HEX from file\n");
		exit(1);
	}

	code_size = size;

	if (code_size >= STARTUP_ADR - STACK_SIZE)
	{
		printf("Error: Out of memory, compiled code is too large\n");
		exit(1);
	}

	if (!load_bin(STARTUP_ADR, argv[2]))
	{
		printf("Error: Can't load startup code\n");
		exit(1);
	}

	code_pages = 4;

	/*for(i=0;i<4;i++)
	{
		if(!page_is_empty(i))
		{
			page_save(i,cc_page[i]);
			code_pages++;
		}
	}*/

	memcpy(&sprinter_mem[0], &mem[0], 65536);

	printf("load complete\n");
	printf("\nCompiled code size %i bytes (%i max, %i left)\n\n", code_size, STARTUP_ADR - STACK_SIZE, STARTUP_ADR - STACK_SIZE - code_size);

	file = fopen("code.bin","wb");
	fwrite(&sprinter_mem[0],4 * 16384,1,file);
	fclose(file);

	return 0;
}