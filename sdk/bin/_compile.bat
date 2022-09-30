
set temp=_temp_

echo Building gfx.dat...

CD Sprites

..\..\..\sdk\bin\mkimg.exe img.lst gfx.dat

CD ..\

echo Building wyz.bin (TODO)...

echo Compiling code...

mkdir %temp%
..\..\sdk\thirdparty\sdcc\bin\sdcc -mz80 --code-loc 0x0006 --data-loc 0 --max-allocs-per-node 5000 --no-std-crt0 -I..\..\sdk\include ..\..\sdk\bin\crt0.rel ..\..\sdk\bin\sprinter.rel --opt-code-speed main.c -o %temp%\out.ihx

echo Converting out.ihx...

CD %temp%

..\..\..\sdk\bin\mkcode.exe out.ihx ..\..\..\sdk\bin\startup.bin

CD ..\

echo Creating exe...

copy /b /y ..\..\sdk\bin\loader.exe + %temp%\code.bin + Sound\wyz.bin + Sprites\gfx.dat %output%.exe

rd /s /q %temp%
