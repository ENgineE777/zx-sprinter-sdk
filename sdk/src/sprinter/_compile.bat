..\..\thirdparty\sjasmplus\sjasmplus lib_startup.asm --exp=startup.exp

..\..\thirdparty\sdcc\bin\sdasz80 -g -o ..\..\bin\crt0.rel crt0.s

..\..\bin\exp2h startup.exp

..\..\thirdparty\sdcc\bin\sdcc -mz80 -I. -c sprinter.c

copy sprinter.rel ..\..\bin\sprinter.rel

pause