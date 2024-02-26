all:
	genus -f ./tcl/run.tcl -log logs/syn.log

load: async_fifo.db tcl/load.tcl
	genus -f ./tcl/load.tcl -log logs/load.log

schematic: async_fifo.db tcl/load.tcl schematic.tcl
	genus -f ./tcl/schematic.tcl -log logs/schem.log

.PHONY: clean
clean:
	rm -f logs/*
	rm -f OUTPUT/reports/*
	rm -f OUTPUT/outputs/*
	rm -f .rs_echan14.tstamp
	rm -f top.mtarpt