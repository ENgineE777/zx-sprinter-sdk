
path=..\..\toolchain\sdcc\bin;..\..\toolchain\bin;

set temp=_temp_

mkdir %temp%
sdcc -mz80 --code-loc 0x0006 --data-loc 0 --max-allocs-per-node 5000 --no-std-crt0 -I..\..\toolchain\include ..\..\toolchain\bin\crt0.rel ..\..\toolchain\bin\sprinter.rel --opt-code-speed main.c -o %temp%\out.ihx

mkcode %temp%\out.ihx ..\..\toolchain\bin\startup.bin

copy /b /y ..\..\toolchain\bin\loader.exe + code.bin + Sound\wyz.bin + Sprites\gfx.dat hello.exe

pause 0
