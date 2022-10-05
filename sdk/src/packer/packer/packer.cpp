
#include <string.h>
#include <stdio.h>
#include <stdlib.h> 

extern int pack_sound(int argc, char* argv[]);
extern int pack_code(int argc, char* argv[]);
extern int pack_image(int argc, char* argv[]);

int main(int argc, char* argv[])
{
	if (argc > 1 && _stricmp(argv[1], "-mksound") == 0)
	{
		return pack_sound(argc, argv);
	}

	if (argc > 1 && _stricmp(argv[1], "-mkcode") == 0)
	{
		return pack_code(argc, argv);
	}

	if (argc > 1 && _stricmp(argv[1], "-mkimage") == 0)
	{
		return pack_image(argc, argv);
	}

	printf("Error: Please set -mksound or -mkcode or -mkimage and pass needed parameters\n");

	return 1;
}
