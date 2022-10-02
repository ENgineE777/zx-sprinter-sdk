
..\..\thirdparty\sdcc\bin\sdcc -mz80 --code-loc 0x0000 --data-loc 0 --max-allocs-per-node 5000 --no-std-crt0 --opt-code-speed sprinter.c -o sprinter.ihx
copy sprinter.rel ..\..\bin\sprinter.rel
