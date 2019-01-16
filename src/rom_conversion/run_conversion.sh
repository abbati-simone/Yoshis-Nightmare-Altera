#!/usr/bin/env bash
./ROM2Png.py -i verilog/yoshi_rom.v -o png/yoshi_rom.png -f verilog -b 444 -x 16 -y 80
./ROM2Png.py -i verilog/yoshi_ghost_rom.v -o png/yoshi_gost_rom.png -f verilog -b 444 -x 16 -y 80
./ROM2Png.py -i verilog/eggs_rom.v -o png/eggs_rom.png -f verilog -b 444 -x 16 -y 80
./ROM2Png.py -i verilog/blocks_rom.v -o png/blocks_rom.png -f verilog -b 444 -x 16 -y 80
./ROM2Png.py -i verilog/walls_rom.v -o png/walls_rom.png -f verilog -b 444 -x 16 -y 32
./ROM2Png.py -i verilog/crazy_ghost_rom.v -o png/crazy_ghost_rom.png -f verilog -b 444 -x 16 -y 32
./ROM2Png.py -i verilog/normal_ghost_rom.v -o png/normal_ghost_rom.png -f verilog -b 444 -x 16 -y 32
./ROM2Png.py -i verilog/hearts_rom.v -o png/hearts_rom.png -f verilog -b 444 -x 16 -y 32
./ROM2Png.py -i verilog/background_ghost_rom.v -o png/background_ghost_rom.png -f verilog -b 444 -x 256 -y 256
./ROM2Png.py -i verilog/gameover_rom.v -o png/gameover_rom.png -f verilog -b 444 -x 78 -y 14
./ROM2Png.py -i verilog/game_logo_rom.v -o png/game_logo_rom.png -f verilog -b 444 -x 368 -y 35
./ROM2Png.py -i verilog/numbers_rom.v -o png/numbers_rom.png -f verilog -b 100 -x 16 -y 160

./Png2ROM.py -i png/yoshi_rom.png -o mif/yoshi_rom.mif -f quartus -b 444
./Png2ROM.py -i png/yoshi_gost_rom.png -o mif/yoshi_gost_rom.mif -f quartus -b 444
./Png2ROM.py -i png/eggs_rom.png -o mif/eggs_rom.mif -f quartus -b 444
./Png2ROM.py -i png/blocks_rom.png -o mif/blocks_rom.mif -f quartus -b 444
./Png2ROM.py -i png/walls_rom.png -o mif/walls_rom.mif -f quartus -b 444
./Png2ROM.py -i png/crazy_ghost_rom.png -o mif/crazy_ghost_rom.mif -f quartus -b 444
./Png2ROM.py -i png/normal_ghost_rom.png -o mif/normal_ghost_rom.mif -f quartus -b 444
./Png2ROM.py -i png/hearts_rom.png -o mif/hearts_rom.mif -f quartus -b 444
./Png2ROM.py -i png/background_ghost_rom.png -o mif/background_ghost_rom.mif -f quartus -b 444
./Png2ROM.py -i png/gameover_rom.png -o mif/gameover_rom.mif -f quartus -b 444 -k
./Png2ROM.py -i png/game_logo_rom.png -o mif/game_logo_rom.mif -f quartus -b 444 -k
./Png2ROM.py -i png/numbers_rom.png -o mif/numbers_rom.mif -f quartus -b 100

./Png2ROM.py -i png/game_logo_rom_small_2.png -o mif/game_logo_rom_small_2.mif -f quartus -b 444 -k

