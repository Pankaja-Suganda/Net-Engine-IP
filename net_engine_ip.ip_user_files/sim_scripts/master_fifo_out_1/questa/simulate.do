onbreak {quit -f}
onerror {quit -f}

vsim  -lib xil_defaultlib master_fifo_out_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {master_fifo_out.udo}

run 1000ns

quit -force
