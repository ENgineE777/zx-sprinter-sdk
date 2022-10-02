
set temp=_temp_

echo Compiling code...

mkdir %temp%
%ZXSDK%\thirdparty\sdcc\bin\sdcc -mz80 --code-loc 0x0006 --data-loc 0 --max-allocs-per-node 5000 --no-std-crt0 -I%ZXSDK%\include %ZXSDK%\bin\crt0.rel %ZXSDK%\bin\sprinter.rel --opt-code-speed main.c -o %temp%\out.ihx

if not exist %temp%\out.ihx (
    echo Error: Compilation errors in main.c...
    pause
    exit
)

echo Converting out.ihx...

CD %temp%

%ZXSDK%\bin\mkcode.exe out.ihx %ZXSDK%\bin\startup.bin

echo Building wyz.bin ...

%ZXSDK%\bin\mksound.exe %ZXSDK%\src\wyzplayer\wyzplayer.asm ..\Sound\snd.lst wyzplayer.asm

copy %ZXSDK%\src\wyzplayer\ayfxplay.asm ayfxplay.asm
copy %ZXSDK%\src\wyzplayer\env.dat env.dat
copy %ZXSDK%\src\wyzplayer\fmplay.bin fmplay.bin
copy %ZXSDK%\src\wyzplayer\notes.dat notes.dat
copy %ZXSDK%\src\wyzplayer\uwl.afb uwl.afb

%ZXSDK%\thirdparty\sjasmplus\sjasmplus wyzplayer.asm

if not exist wyzplayer.asm (
    echo Error: Compilation errors in wyzplayer.asm...
    pause
    end
)

CD ..\

echo Building gfx.dat...

CD Sprites

%ZXSDK%\bin\mkimg.exe img.lst gfx.dat

if not exist gfx.dat (
    echo Error: Can't create gfx.dat
    pause
    end
)

CD ..\

copy Sprites\gfx.dat %temp%\gfx.dat

del Sprites\gfx.dat

del %output%.exe

echo Creating exe...

copy /b /y %ZXSDK%\bin\loader.exe + %temp%\code.bin + %temp%\wyz.bin + %temp%\gfx.dat %output%.exe

if not exist %output%.exe (
    echo Error: Can't create %output%.exe
    pause
    end
)

if not %runZXMak%==Yes end

echo Copy to VHD...

call %ZXSDK%\zxmak\HDD\mount.bat

mkdir Z:\%output%
copy %output%.exe Z:\%output%\%output%.exe

call %ZXSDK%\zxmak\HDD\unmount.bat

rd /s /q %temp%

%ZXSDK%\zxmak\ZXMAK2.exe
