**zx-sprinter-sdk**

This is SDK for Sprinter ZX-Spectrum (Nedo PC). Code is based on Sprinter port of Evo version of the game Uwol: Quest For Money.
In the Spriter port lots of tools from evo SDK were adopted. Therefore philosophy behind Evo SDK was preserved and
continued in a form of user friendly toolset.

SDK shares philosophy out of the box ready, so everything inside the repository. Checking of examples is a good starting for
development of your games for Sprinter.

**before you start**

Important: before use sdk you need to execute registerSDK.bat in sdk folder for registering path to sdk
in enviroment variable and preparing ZXMak2 to launch you compiled games. AAlso this will make possible to store source of
your game at any location on a computer and be able to compile via SDK. After registration you need to restart your
session before compile projects from samples folder.

**Structure of your project**

root

+---Sprites

    +---img.lst

    +---YourTilesImage256x64.bmp

    +---YourSpriesImage256x64.bmp

    +---Image01_256x198.bmp

    +---Image02_256x198.bmp

    +---...

+---Sound

    +---snd.lst

    +---Music001.mus

    +---Music002.mus

    +---...

_compile.bat

main.c

To fastest start please duplicate StartProject from samples anywhere at your computer. This will gives you simplest
compilable and workable project.

All images sits in Sprites folder. There you need to define img.lst with referecnes to your image files.
First will go image for 8x8 tiles. Size of tile sheet restricted to 256 x 64. Tiles can be draw via sp_PrintAtInv or draw_tile.
Second always will go sprite sheet of 16x16 sprites, size also is restricted to 256 x 64. Size draw via add_sprite call.
Next goes 256x192 images whihc can be draw by unpack_screen call.

Sounds sits in Sound. Also descriptor file snd.lst refers to your music files plus data for SFX.
You can have only one c file with harcoded name main, i.e. your code resides in main.c plus headers, to compile
please _compile.bat in Samples\StartProject

If you don't need to run ZXMak after compile then you can remove "set runZXMak=Yes" in _compile.bat

**Demo project**

Spaceship demo project located in samples folder. Demo represents a small demo of flying spaceship with nice graphics

UWOL is a fulll game located in sample folder. This port made by BLADE gave a spark to this SDK. 


