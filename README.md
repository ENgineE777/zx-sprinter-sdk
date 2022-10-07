## zx-sprinter-sdk

This is SDK for Sprinter Computer (clone of ZX Spectrum). Code is based on Sprinter port of Evo version of the game Uwol: Quest For Money.
In the Spriter port lots of tools from evo SDK were adopted. Therefore philosophy behind Evo SDK was preserved and
continued in a form of user friendly toolset.

SDK shares philosophy out of the box ready, so everything inside the repository. Checking of examples is a good star point for
development of your games for Sprinter.

## Before you start

Important: before use SDK you need to execute registerSDK.bat in SDK folder for registering path to SDK
in enviroment variable and preparing ZXMak2 to launch your compiled games. Also this will make possible to store source of
your game at any location on a computer and be able to compile via SDK. After registration you need to restart your
session before compile any projects.

## Structure of your project


    +---root
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
First will go image for 8x8 tiles. Max size of tile sheet restricted to 256 x 64, but width always should be 256. Tiles
can be draw via sp_PrintAtInv or draw_tile. Next always will go sprite sheet with 16x16 sprites, max size also is restricted
to 256 x 64, and again width always should be 256. Sprite can be draw via add_sprite call.
Next goes 256x192 images whihc can be draw by unpack_screen call.

Sounds sit in Sound folder. Also descriptor file snd.lst in json format refers to your music files plus data for SFX.
You can have only one c file with harcoded name main, i.e. your code resides in main.c plus headers. To compile
you need to call _compile.bat.

If you don't need to run ZXMak after compile then you can remove "set runZXMak=Yes" in _compile.bat

## Demo projects

**Spaceship** demo project located in samples folder. Demo represents a small demo of flying spaceship with nice graphics

**UWOL** is a fulll game located in samples folder. This port made by BLADE gave a spark to this SDK. 

## Limitations of SDK

Only resolution 256 x 192, 256 colors supported by SDK for now. All used BMP must be with 256 color palette, but only
first 64 colors in pallete will be usded. Max size of tile sheet and sprite sheet restricted to 256 x 64, but width always
should be 256.

In terms of perfomance you can draw max 19 without perfomance problems on a real hardware

At first glance not much can be done, but remember, original ZX Spectrum 48 has much more tight restrictions and despite
them it is posible to creeate gems like Alien Neoplasma. 


