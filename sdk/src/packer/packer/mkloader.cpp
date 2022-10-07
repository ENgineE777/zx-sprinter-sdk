#include "common.h"

int pack_loader(int argc, char* argv[])
{
	if (argc < 5)
	{
		printf("mkloader:Error: Please provide loader asm template, output asm file, name and version(optional) in parameters\n");
		return 1;
	}
	
	std::string assembly;

	if (!load_asm_template(argv[2], assembly))
	{
		printf("mkloader:Error: can't load asm template\n");
		return 1;
	}

	const char* loading_tag = "LOADING...";

	size_t start_pos = assembly.find(loading_tag);
	if (start_pos != std::string::npos)
	{
		std::string str = std::string("Loading ") + argv[4];

		printf("mkloader:Error: can't load asm template %i %s\n", argc, argv[5]);

		if (argc <= 6 && argv[5])
		{
			str += std::string(" ") + argv[5];
		}

		str += "...";

		assembly.replace(start_pos, strlen(loading_tag), str);
	}

	if (!save_asm(argv[3], assembly))
	{
		printf("mksound:Error: can't save asm file\n");
		return 1;
	}

	return 0;
}