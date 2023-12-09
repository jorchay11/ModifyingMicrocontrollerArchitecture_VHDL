onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+cpuram -L xpm -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.cpuram xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {cpuram.udo}

run -all

endsim

quit -force
