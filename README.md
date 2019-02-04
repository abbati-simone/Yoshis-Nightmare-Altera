# Yoshi's Nightmare porting for Altera FPGA EP4CE6E22C8N on Zr-Tech WXEDA board
This project is the Yoshi's Nightmare porting for Altera FPGA (EP4CE6E22C8N on Zr-Tech WXEDA board).
The original project is here: https://github.com/jconenna/Yoshis-Nightmare

The porting is needed because the original project is developed on Basys 3 development board which uses a Xilinx Artix-7 series FPGA, with 33k logic cells, and 1800 kbits of block RAM (likely a XC7A35T).
My board is Zr-Tech WXEDA developement board which uses Altera Cyclone IV FPGA (EP4CE6E22C8N), with 6272 LEs, and 276480 memory bits of block RAM, much less powerful than the one used by the original project.

![My FPGA board Zr-Tech WXEDA board](https://github.com/abbati-simone/Yoshis-Nightmare-Altera/blob/master/doc/images/Zr-Tech_WXEDA_board.png "My FPGA board Zr-Tech WXEDA board")

Of course I mapped the I/O PINs which are specific to my developement board. I also added a music during the init screen and another one during game play. Maybe I will add a game over music and a sound when Yoshi is hit. The music is converted from **MIDI** files to ROMs and played via two specific Verilog modules (*delay_unit* and *playnote*). Check these projects to have more information about music:
https://github.com/abbati-simone/Midi-to-ROM
https://github.com/abbati-simone/Midi-Altera

The main problem was the ROM synthesis. Reading Altera documentation a simple keyword (**(\* romstyle = "M9K" \*)**) on the source file would suffice to force compilation to use the internal block memory, but it does not work for me. Loading ROM data from MIF file using the IP for internal memory works instead.
Not using internal memory causes insufficient space on EP4CE6E22C8N. So I used the IP provided with Quartus to make use of the internal memory. Unfortunately the original ROM data is in the form of a Verilog source (with *case* statement), but Quartus does not accept it as source to load the ROM data. This is why I developed two **Python3** scripts to do this Job: convert a Verilog file with ROM data to Quartus MIF file (Memory Initialization file). These scripts can also be useful for many other purposes (copied in this project from this project: https://github.com/abbati-simone/Png-to-from-Verilog).

The conversion chain is Verilog -> PNG Image -> Quartus MIF file.
Of course writing a specific script Verilog -> Quartus MIF file conversion can be done directly, but I like to see the resulting PNG of the first step.
Under src/rom_conversion you can find the two Python scripts, the Verilog ROM files I extracted from original Project, the generated PNG images, the generated MIF files and a bash script to run these conversions as a single command.

Problems are not over, because the background ROM and the game logo ROM are too big for my poor FPGA (EP4CE6E22C8N has only 276480 memory bits, XC7A35T has 1800Kbits). I decided to remove the background ROM and to scale the game logo ROM size by about 50% (from 368x35 12bit pixels to 184x16 12bit pixels). Scaling game logo ROM has been done by converting the corresponding Verilog ROM to game_logo_rom.png, manually scaling this image to 50% maintaining proportions and without interpolation (wich leads to a 184x18 pixel image, see game_logo_rom_small.png) and then removing first and last row from this intermediate image to get the final image of 184x16 pixels (see game_logo_rom_small_2.png).

I also fixed some modules which have problems with default value (see ghost_bottom.v line 90 for example) and I wrote my own VGA module.

Game score is shown on the digital tubes (see screenshots).
I did not implemented a gamepad controller, I use the 4 buttons on my board. From the left, the first button moves Yoshi to the left, the second one makes Yoshi jump, the third one moves Yoshi to the right and the last one is the game start button.

YoshiGameConversion.cof is included in Quartus project to convert YoshiGame.sof to YoshiGame.jic (needed to write "permanently" the configuration to the FPGA).

Compilation Reports
-------------------
Without music
![Quartus Compilation Report](https://github.com/abbati-simone/Yoshis-Nightmare-Altera/blob/master/doc/images/Compilation_Success.png "Quartus Compilation Report")


With music
![Quartus Compilation Report Music](https://github.com/abbati-simone/Yoshis-Nightmare-Altera/blob/master/doc/images/Compilation_Success_Music.png "Quartus Compilation Report Music")

Problems
--------
- Sometimes jumping near the edge of a platform above Yoshi causes Yoshi to move to the upper wall edge forever. I do not know if this problem exists on the original project or has to do with the porting.
- The original project uses an external Reset signal wired to internal logic. My board does not have a phisical Reset button. Instead of using some of the pins on the "expansion" connector connected to an external button, I decided to not use this signal and use the Start button only. This causes bad Reset to the internal logic, and multiple push of the start button is needed to correctly setup internal logic.

Screenshots
-----------
![Game logo](https://github.com/abbati-simone/Yoshis-Nightmare-Altera/blob/master/doc/images/Screenshot_Game_1.jpg "Game logo")
![Game started](https://github.com/abbati-simone/Yoshis-Nightmare-Altera/blob/master/doc/images/Screenshot_Game_2.jpg "Game started")
![Game playing and score](https://github.com/abbati-simone/Yoshis-Nightmare-Altera/blob/master/doc/images/Screenshot_Game_3.jpg "Game playing and score")
![Game hit](https://github.com/abbati-simone/Yoshis-Nightmare-Altera/blob/master/doc/images/Screenshot_Game_4.jpg "Game hit")
![Game over](https://github.com/abbati-simone/Yoshis-Nightmare-Altera/blob/master/doc/images/Screenshot_Game_5.jpg "Game over")
![Board playing score](https://github.com/abbati-simone/Yoshis-Nightmare-Altera/blob/master/doc/images/Board_Playing_Score.jpg "Board playing score")

Icarus Verilog Simulation and VGA output capture
------------------------------------------------
Developing this project and not having (at the time) a CRT/LCD Monitor with VGA input, I developed a little program call **VirtualScreenGTK** to show an image starting from a "bitstream" (RGB data sequence) and I used Icarus Verilog Simulation tool to get the RGB output and "render" an image. More information about **VirtualScreenGTK** can be found here https://github.com/abbati-simone/VirtualScreenGTK

Under *src/testbench* are some files for simulation:
 * *compilesim.sh* is used to compile the testbench with *iverilog*
 * *runsim.sh* is used to run the simulation with *vvp*
 * *YoshiGame_tb.v* is the testbech main file
 * *yoshisim.out* is the compiled Icarus file to be run with *vvp*

To compile the testbech run:
```bash
$ ./compilesim.sh
```
*yoshisim.out* is created/updated.

To run simulation:
```bash
$ ./runsim.sh
```

Notice you will need virtualScreenGtk on your PATH (see VirtualScreenGTK project linked above).
A FIFO file is created under your home and is named yoshi_fifo. This FIFO is removed when the simulation end but may not work, so check and remove it manually if needed (rm ${HOME}/yoshi_fifo).


The following screenshot is captured when the first frame "rendering" is not finished:

![VirtualScreenGTK frame unfinished](https://github.com/abbati-simone/Yoshis-Nightmare-Altera/blob/master/doc/images/VirtualScreenGTK_1.png "VirtualScreenGTK frame unfinished")

The following screenshot is captured when the first frame "rendering" is finished and the next one just started:

![VirtualScreenGTK second frame](https://github.com/abbati-simone/Yoshis-Nightmare-Altera/blob/master/doc/images/VirtualScreenGTK_2.png "VirtualScreenGTK second frame")

The following screenshot is captured using the specific command line option:

![VirtualScreenGTK command line screenshot](https://github.com/abbati-simone/Yoshis-Nightmare-Altera/blob/master/doc/images/VirtualScreenGTK_3.jpg "VirtualScreenGTK command line screenshot")


The "rendering" is super slow but can be useful to capture a clean screenshot.

