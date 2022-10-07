#include "common.h"

bool load_asm_template(const char* name, std::string& assembly)
{
	FILE* file = nullptr;

	fopen_s(&file, name, "rb");

	if (!file) return false;

	fseek(file, 0, SEEK_END);
	int size = ftell(file);
	fseek(file, 0, SEEK_SET);

	char* mem = (char*)malloc(size + 1);

	if (!mem)
	{
		return false;
	}

	fread(mem, size, 1, file);
	fclose(file);

	mem[size] = 0;

	assembly = mem;

	free(mem);

	return true;
}

bool save_asm(const char* name, const std::string& assembly)
{
	FILE* file = nullptr;

	fopen_s(&file, name, "wb");

	if (!file) return false;

	fwrite(assembly.c_str(), assembly.length(), 1, file);

	fclose(file);

	return true;
}