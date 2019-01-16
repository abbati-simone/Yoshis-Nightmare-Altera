#!/usr/bin/env bash
homedir=~
eval homedir=${homedir}
fifo_loc=${homedir}/yoshi_fifo
if [ ! -f ${fifo_loc} ]; then
	mkfifo ${fifo_loc}
fi

echo "Running simulation, read data from ${fifo_loc}, Ctrl-c and 'finish' to stop"
echo
echo
virtualScreenGtk -f ${fifo_loc} -x 640 -y 480 -p 25 -t -m RGB_4_4_4 -s ~/testout&
vvp yoshisim.out +fifo=${fifo_loc}

rm ${fifo_loc}
