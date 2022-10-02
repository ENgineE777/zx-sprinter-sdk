
#include <vector>
#include <string>
#include "vjson/json.h"
#include "vjson/block_allocator.h"

std::string assembly;

block_allocator allocator(1 << 10);
json_value* root = nullptr;

struct MusicEntry
{
	std::string name;
	std::string file;
};

std::vector<MusicEntry> musics;

struct SoundEntry
{
	std::string name;
	std::vector<int> data;
};

std::vector<SoundEntry> sounds;

bool load_asm_template(const char* name)
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

bool load_list(const char* name)
{
	FILE* file = nullptr;

	fopen_s(&file, name, "rb");

	if (!file) return false;

	fseek(file, 0, SEEK_END);
	int size = ftell(file);
	fseek(file, 0, SEEK_SET);

	char* list = (char*)malloc(size + 1);

	if (!list)
	{
		return false;
	}

	fread(list, size, 1, file);
	fclose(file);

	list[size] = 0;

	char* errorPos = 0;
	char* errorDesc = 0;
	int errorLine = 0;

	root = json_parse((char*)list, &errorPos, &errorDesc, &errorLine, &allocator);

	auto* music = root->first_child;

	auto* music_entry = music->first_child;

	while (music_entry)
	{
		if (music_entry->first_child)
		{
			MusicEntry entry;
			entry.name = music_entry->first_child->name;
			entry.file = music_entry->first_child->string_value;

			musics.push_back(entry);
		}

		music_entry = music_entry->next_sibling;
	}

	auto* sound_entry = music->next_sibling->first_child;

	while (sound_entry)
	{
		if (sound_entry->first_child)
		{
			SoundEntry entry;
			entry.name = sound_entry->first_child->name;

			auto* data_entry = sound_entry->first_child->first_child;

			while (data_entry)
			{
				entry.data.push_back(data_entry->int_value);
				data_entry = data_entry->next_sibling;
			}

			sounds.push_back(entry);
		}

		sound_entry = sound_entry->next_sibling;
	}

	free(list);
	allocator.free();

	return true;
}

bool save_asm(const char* name)
{
	FILE* file = nullptr;

	fopen_s(&file, name, "wb");

	if (!file) return false;

	fwrite(assembly.c_str(), assembly.length(), 1, file);

	fclose(file);

	return true;
}

int main(int argc, char* argv[])
{
    if (argc < 4)
    {
        printf("Error: Please provide asm template, list of files and output asm file in parameters\n");
        return 1;
    }

	if (!load_asm_template(argv[1]))
	{
		printf("Error: can't load asm template\n");
		return 1;
	}

	if (!load_list(argv[2]))
	{
		printf("Error: can't load list\n");
		return 1;
	}

	std::string sfxTag = "[SFX]";
	std::string sfx = "TABLA_SONIDOS:  DW     ";

	for (int i = 0; i < sounds.size(); i++)
	{
		sfx += "SONIDO" + std::to_string(i);

		if (i != sounds.size() - 1)
		{
			sfx += ", ";
		}
	}

	sfx += "\n";

	for (int i = 0; i < sounds.size(); i++)
	{
		auto& sound = sounds[i];

		sfx += "SONIDO" + std::to_string(i) + std::string(":    DB ");

		for (int j = 0; j < sound.data.size(); j++)
		{
			sfx += std::to_string(sound.data[j]);

			if (j != sound.data.size() - 1)
			{
				sfx += ", ";
			}
		}

		sfx += "\n";
	}

	size_t start_pos = assembly.find(sfxTag);
	if (start_pos != std::string::npos)
	{
		assembly.replace(start_pos, sfxTag.length(), sfx);
	}

	std::string musicTag = "[MUSIC]";
	std::string music = "TABLA_SONG:     DW   ";

	for (int i = 0; i < musics.size(); i++)
	{
		music += "SONG_" + std::to_string(i);

		if (i != musics.size() - 1)
		{
			music += ", ";
		}
	}

	music += "\n";
	music += "DATOS_NOTAS:    INCBIN \"notes.DAT\"\n";
	music += "DATOS_ENV:      INCBIN \"env.DAT\"\n";

	for (int i = 0; i < musics.size(); i++)
	{
		music += "SONG_" + std::to_string(i) + std::string(":    INCBIN \"../Sound/") + musics[i].file + "\"\n";
	}

	start_pos = assembly.find(musicTag);
	if (start_pos != std::string::npos)
	{
		assembly.replace(start_pos, musicTag.length(), music);
	}

	save_asm(argv[3]);

	return 0;
}
