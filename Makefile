mem: mem_test.sv mem.sv
	xrun $^

sync: sync_test.sv sync.sv
	xrun $^

r_empty: r_empty_test.sv r_empty.sv
	xrun $^

w_full: w_full_test.sv w_full.sv
	xrun $^

fifo: fifo_test.sv fifo.sv mem.sv sync.sv r_empty.sv w_full.sv
	xrun $^

send: send_data.sv fifo.sv mem.sv sync.sv r_empty.sv w_full.sv
	xrun $^