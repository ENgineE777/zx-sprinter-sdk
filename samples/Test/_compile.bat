
path=..\..\sdk\sdcc\bin;..\..\sdk\bin;

set temp=_temp_

mkdir %temp%
sdcc -mz80 --code-loc 0x0006 --data-loc 0 --max-allocs-per-node 5000 --no-std-crt0 -I..\..\sdk\include ..\..\sdk\bin\crt0.rel ..\..\sdk\bin\sprinter.rel --opt-code-speed main.c -o %temp%\out.ihx

mkcode %temp%\out.ihx ..\..\sdk\bin\startup.bin

copy /b /y ..\..\sdk\bin\loader.exe + code.bin + Sound\wyz.bin + Sprites\gfx.dat hello.exe

pause 0
