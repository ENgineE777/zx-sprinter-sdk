#include <string.h>
#include <stdio.h>
#include <stdlib.h> 
#include <stdint.h>

#define PAGE_SIZE 16384

constexpr int image_mem_size = PAGE_SIZE * 32;

unsigned char image_mem[image_mem_size];

struct {
	unsigned char* data;
	int offset;
	int bpp;
	int wdt, hgt;
	bool flip;
} BMP;

void trim_str(char* line)
{
	unsigned int i;

	for (i = 0; i < strlen(line); i++)
	{
		if (line[i] < 0x20)
		{
			line[i] = 0;
			break;
		}
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

int __cdecl mkcolor(int a1, int a2, int a3)
{
	int v4; // [esp-8h] [ebp-8h]

	if (a3 > 15)
	{
		v4 = (a3 - 15) * a2 / 15 + a1;
		if (v4 > a2)
			v4 = a2;
	}
	else
	{
		v4 = a3 * a1 / 15;
		if (v4 > a2)
			v4 = a2;
	}
	return v4;
}


bool load_bmp(const char* filename, int index, int page)
{
	FILE* file = nullptr;
	fopen_s(&file, filename, "rb");

	if (!file) return 1;

	fseek(file, 0, SEEK_END);
	int size = ftell(file);
	fseek(file, 0, SEEK_SET);

	BMP.data = (unsigned char*)malloc(size);
	fread(BMP.data, size, 1, file);

	fclose(file);

	if (BMP.data[0] != 'B' || BMP.data[1] != 'M')
	{
		printf("mkimage:Error: Not BMP file format (%s)\n", filename);
		return false;
	}

	BMP.offset = read_dword(&BMP.data[10]);
	BMP.wdt = read_dword(&BMP.data[18]);
	BMP.hgt = read_dword(&BMP.data[22]);
	BMP.bpp = read_word(&BMP.data[28]);
	int rle = read_dword(&BMP.data[30]);

	if ((BMP.wdt & 7) || (BMP.hgt & 7))
	{
		printf("mkimage:Error: Width and height should be 8px aligned (%s)\n", filename);
		return false;
	}

	if (rle != 0 || (BMP.bpp != 4 && BMP.bpp != 8))
	{
		printf("mkimage:Error: Only uncompressed 16 and 256 colors BMP supported (%s)\n", filename);
		return false;
	}

	BMP.flip = (BMP.hgt > 0) ? false : true;

	//load pallete
	{
		unsigned char* src = &BMP.data[54];
		unsigned char* dest = &image_mem[192 * index];

		int index = 54;

		for (int i = 0; i < 64; i++)
		{
			unsigned char r = BMP.data[index++];
			unsigned char g = BMP.data[index++];
			unsigned char b = BMP.data[index++];

			dest[i * 3 + 0] = b;
			dest[i * 3 + 1] = g;
			dest[i * 3 + 2] = r;

			index++;
		}

		index++;
	}

	//load bmp
	{
		unsigned char* src = &BMP.data[BMP.offset];
		unsigned char* dest = &image_mem[page * PAGE_SIZE];

		if (BMP.flip)
		{
			int size = BMP.wdt * BMP.hgt;
			memcpy(dest, src, size);
		}
		else
		{
			for (int i = 0; i < BMP.hgt; i++)
			{
				memcpy(&dest[(BMP.hgt - 1 - i) * BMP.wdt], &src[i * BMP.wdt], 256);
			}
		}
	}

	free(BMP.data);

	return true;
}

int pack_image(int argc, char* argv[])
{
	if (argc < 4)
	{
		printf("mkimage:Error: Please provide image list and output file in parameters\n");
		return 1;
	}

	FILE* list;
	char line[1024];

	memset(image_mem, 0, image_mem_size);

	fopen_s(&list, argv[2], "rt");

	if (!list)
	{
		printf("mkimage:Error: Can't open image list\n");
		return 1;
	}

	int img_count = 0;
	int page = 1;

	while (fgets(line, sizeof(line), list) != NULL)
	{
		if (img_count == 256)
		{
			printf("ERR: Too many images\n");
			return 1;
		}

		trim_str(line);

		if (load_bmp(line, img_count, page))
		{
			printf("mkimage: Image added %s, page %i\n", line, page);

			page += (img_count < 2) ? 1 : 3;
			img_count++;
		}
	}

	fclose(list);

	for (int i = 0; i <= 30; ++i)
	{
		for (int j = 0; j <= 255; ++j)
		{
			int index = (i << 8) + j + 0x2000;
			image_mem[index] = mkcolor(j, 255, i);
		}
	}

	FILE* file = nullptr;
	fopen_s(&file, argv[3], "wb");

	if (!file)
	{
		printf("mkimage:Error: Can't save gfx file\n");
		return 1;
	}

	fwrite(image_mem, PAGE_SIZE * page, 1, file);
	fclose(file);

	return 0;
}