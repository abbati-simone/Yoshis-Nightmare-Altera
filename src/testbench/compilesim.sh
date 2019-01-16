#!/usr/bin/env bash
iverilog -y ../modified -y ../original  -DICARUS_SIMULATOR=1 -g2001 -o yoshisim.out YoshiGame_tb.v

