#define _CRT_SECURE_NO_WARNINGS
#include <stdlib.h>
#include <stdio.h>
#include <memory.h>
#include <string.h>

#define STARTUP_ADR	0xe000
#define STACK_SIZE	0x0400

unsigned char code_mem[65536];

int get_hex(char n)
{
	if (n >= '0' && n <= '9') return n - '0';
	if (n >= 'a' && n <= 'f') return n - 'a' + 10;
	if (n >= 'A' && n <= 'F') return n - 'A' + 10;

	return -1;
}

int get_hex_byte(char* str)
{
	return (get_hex(str[0]) << 4) + get_hex(str[1]);
}

int load_ihx(const char* name)
{
	FILE* file;
	char line[1024];
	int i, off, ptr, len, size;

	file = fopen(name, "rt");

	if (!file) return 0;

	size = 0;

	while (fgets(line, sizeof(line), file) != NULL)
	{
		len = get_hex_byte(&line[1]);
		ptr = (get_hex_byte(&line[3]) << 8) + get_hex_byte(&line[5]);
		off = 9;

		for (i = 0; i < len; i++)
		{
			code_mem[ptr++] = get_hex_byte(&line[off]);
			off += 2;
		}

		if (ptr > size) size = ptr;
	}

	fclose(file);

	return size;
}

bool load_bin(unsigned char* mem, int adr, const char* name)
{
	FILE* file;
	int size;

	file = fopen(name, "rb");

	if (!file) return false;

	fseek(file, 0, SEEK_END);
	size = ftell(file);
	fseek(file, 0, SEEK_SET);

	if (adr + size > 0x10000)
	{
		fclose(file);
		return false;
	}

	fread(code_mem + adr, size, 1, file);
	fclose(file);

	return true;
}

int pack_code(int argc, char* argv[])
{
	if (argc < 5)
	{
		printf("mkcode:Error: Please provide ihx, path to startup code and output file in parameters\n");
		return 1;
	}

	memset(code_mem, 0, 65536);

	int size = load_ihx(argv[2]);

	if (!size)
	{
		printf("mkcode:Error: Can't load Intel HEX from file\n");
		return 1;
	}

	int code_size = size;

	if (code_size >= STARTUP_ADR - STACK_SIZE)
	{
		printf("mkcode:Error: Out of memory, compiled code is too large\n");
		return 1;
	}

	if (!load_bin(code_mem, STARTUP_ADR, argv[3]))
	{
		printf("mkcode:Error: Can't load startup code\n");
		return 1;
	}

	FILE* file = fopen(argv[4], "wb");
	fwrite(code_mem, 65536, 1, file);
	fclose(file);

	return 0;
}