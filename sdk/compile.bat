
set temp=_temp_

echo Building gfx.dat...

CD Sprites

%ZXSDK%\bin\mkimg.exe img.lst gfx.dat

CD ..\

echo Building wyz.bin (TODO)...

echo Compiling code...

mkdir %temp%
%ZXSDK%\thirdparty\sdcc\bin\sdcc -mz80 --code-loc 0x0006 --data-loc 0 --max-allocs-per-node 5000 --no-std-crt0 -I%ZXSDK%\include %ZXSDK%\bin\crt0.rel %ZXSDK%\bin\sprinter.rel --opt-code-speed main.c -o %temp%\out.ihx

echo Converting out.ihx...

CD %temp%

%ZXSDK%\bin\mkcode.exe out.ihx %ZXSDK%\bin\startup.bin

CD ..\

echo Creating exe...

copy /b /y %ZXSDK%\bin\loader.exe + %temp%\code.bin + Sound\wyz.bin + Sprites\gfx.dat %output%.exe

rd /s /q %temp%
