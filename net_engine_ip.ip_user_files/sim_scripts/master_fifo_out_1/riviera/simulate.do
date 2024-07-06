transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+master_fifo_out  -L xpm -L fifo_generator_v13_2_9 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.master_fifo_out xil_defaultlib.glbl

do {master_fifo_out.udo}

run 1000ns

endsim

quit -force
