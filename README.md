# zx-sprinter-sdk

This is SDK for Sprinter ZX-Spectrum (Nedo PC). Code is based on Sprinter port of Evo version of the game Uwol: Quest For Money.
In the Spriter port lots of tools from evo SDK were adopted. Therefore philosophy behind Evo SDK was preserved and
continued in a form of user friendly toolset.

SDK shares philosophy out of the box ready, so everything inside the repository. Checking of examples is a good starting for
development of your games for Sprinter.

Important: before use sdk you need to execute registerSDK.bat in sdk folder for registering path to sdk
in enviroment variable and preparing ZXMak2 to launch you compiled games. AAlso this will make possible to store source of
your game at any location on a computer and be able to compile via SDK. After registration you need to restart your
session before compile projects from samples folder.

Resources of your project:

All images sits in Sprites folder. There you need to define img.lst with referecnes to your files.
Sounds sits in Sound. Also descriptor file snd.lst refers to your music files plus data for SFX.
You can have only one c files, to compile it please _compile.bat in Samples\Spaceship

