transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source {/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source/walls_rom.v}
vlog -vlog01compat -work work +incdir+/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source {/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source/vga_sync.v}
vlog -vlog01compat -work work +incdir+/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source {/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source/score_display.v}
vlog -vlog01compat -work work +incdir+/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source {/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source/platforms.v}
vlog -vlog01compat -work work +incdir+/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source {/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source/numbers_rom.v}
vlog -vlog01compat -work work +incdir+/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source {/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source/hearts_rom.v}
vlog -vlog01compat -work work +incdir+/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source {/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source/hearts_display.v}
vlog -vlog01compat -work work +incdir+/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source {/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source/grounded.v}
vlog -vlog01compat -work work +incdir+/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source {/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source/ghost_normal_rom.v}
vlog -vlog01compat -work work +incdir+/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source {/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source/ghost_crazy_rom.v}
vlog -vlog01compat -work work +incdir+/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source {/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source/game_state_machine.v}
vlog -vlog01compat -work work +incdir+/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source {/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source/enemy_collision.v}
vlog -vlog01compat -work work +incdir+/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source {/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source/eggs_rom.v}
vlog -vlog01compat -work work +incdir+/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source {/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source/eggs.v}
vlog -vlog01compat -work work +incdir+/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source {/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source/display_top.v}
vlog -vlog01compat -work work +incdir+/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source {/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source/blocks_rom.v}
vlog -vlog01compat -work work +incdir+/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source {/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source/binary2bcd.v}
vlog -vlog01compat -work work +incdir+/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source {/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source/yoshi_ghost_rom.v}
vlog -vlog01compat -work work +incdir+/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source {/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source/yoshi_rom.v}
vlog -vlog01compat -work work +incdir+/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source {/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source/yoshi_sprite.v}
vlog -vlog01compat -work work +incdir+/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source {/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source/ghost_bottom.v}
vlog -vlog01compat -work work +incdir+/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source {/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source/ghost_crazy.v}
vlog -vlog01compat -work work +incdir+/home/abbakus/2ndhome/abbakus/Develop/Quartus_Projects/YoshiGame {/home/abbakus/2ndhome/abbakus/Develop/Quartus_Projects/YoshiGame/pll.v}
vlog -vlog01compat -work work +incdir+/home/abbakus/2ndhome/abbakus/Develop/Quartus_Projects/YoshiGame/db {/home/abbakus/2ndhome/abbakus/Develop/Quartus_Projects/YoshiGame/db/pll_altpll.v}
vlog -vlog01compat -work work +incdir+/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source {/home/abbakus/2ndhome/abbakus/Develop/Yoshis-Nightmare/source/ghost_top.v}

