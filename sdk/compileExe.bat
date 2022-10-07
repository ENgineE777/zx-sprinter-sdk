
set temp=_temp_

echo off
echo Compiling code...

mkdir %temp%
%ZXSDK%\thirdparty\sdcc\bin\sdcc -mz80 --code-loc 0x0006 --data-loc 0 --max-allocs-per-node 5000 --no-std-crt0 -I%ZXSDK%\include %ZXSDK%\bin\crt0.rel %ZXSDK%\bin\sprinter.rel --opt-code-speed main.c -o %temp%\out.ihx

if not exist %temp%\out.ihx (
    echo Error: Compilation errors in main.c...
    pause
    goto CLEANUP:
)

echo Converting out.ihx...

CD %temp%

%ZXSDK%\bin\packer.exe -mkcode out.ihx %ZXSDK%\bin\startup.bin code.bin

echo Compiling loader

copy %ZXSDK%\src\loader\bios_equ.asm bios_equ.asm
copy %ZXSDK%\src\loader\dss_equ.asm dss_equ.asm
copy %ZXSDK%\src\loader\sprint00.asm sprint00.asm

%ZXSDK%\bin\packer.exe -mkloader %ZXSDK%\src\loader\loader.asm loader.asm %output% %version%
%ZXSDK%\thirdparty\sjasmplus\sjasmplus loader.asm

echo Building wyz.bin ...

%ZXSDK%\bin\packer.exe -mksound %ZXSDK%\src\wyzplayer\wyzplayer.asm.template ..\Sound\snd.lst wyzplayer.asm

copy %ZXSDK%\src\wyzplayer\ayfxplay.asm ayfxplay.asm
copy %ZXSDK%\src\wyzplayer\env.dat env.dat
copy %ZXSDK%\src\wyzplayer\fmplay.bin fmplay.bin
copy %ZXSDK%\src\wyzplayer\notes.dat notes.dat
copy %ZXSDK%\src\wyzplayer\uwl.afb uwl.afb

%ZXSDK%\thirdparty\sjasmplus\sjasmplus wyzplayer.asm

if not exist wyzplayer.asm (
    echo Error: Compilation errors in wyzplayer.asm...
    pause
    goto CLEANUP:
)

CD ..\

echo Building gfx.dat...

CD Sprites

%ZXSDK%\bin\mkimg.exe img.lst gfx.dat

if not exist gfx.dat (
    echo Error: Can't create gfx.dat
    pause
    goto CLEANUP:
)

CD ..\

copy Sprites\gfx.dat %temp%\gfx.dat

del Sprites\gfx.dat

set output=%output:~0,8%

setlocal enableDelayedExpansion

for %%A in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    set "output=!output:%%A=%%A!"
)

del %output%.EXE

echo Creating EXE...

copy /b /y %temp%\loader.exe + %temp%\code.bin + %temp%\wyz.bin + %temp%\gfx.dat %output%.EXE

if not exist %output%.EXE (
    echo Error: Can't create %output%.EXE
    pause
    goto CLEANUP:
)

if not "%runZXMak%"=="Yes" (
    rd /s /q %temp%
    goto CLEANUP:
)

echo Copy to VHD...

call %ZXSDK%\zxmak\HDD\mount.bat

mkdir Z:\%output%
copy %output%.exe Z:\%output%\%output%.EXE

call %ZXSDK%\zxmak\HDD\unmount.bat

echo Launching ZXMAK2...
%ZXSDK%\zxmak\ZXMAK2.exe

:CLEANUP:
rd /s /q %temp%
