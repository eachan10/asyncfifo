SRC_DIR = src
TEST_DIR = tests
SIMULATOR = xrun
SIM_FLAGS = 

all: send

mem: $(TEST_DIR)/mem_test.sv $(SRC_DIR)/mem.sv
	$(SIMULATOR) $^

sync: $(TEST_DIR)/sync_test.sv $(SRC_DIR)/sync.sv
	$(SIMULATOR) $^

r_empty: $(TEST_DIR)/r_empty_test.sv $(SRC_DIR)/r_empty.sv
	$(SIMULATOR) $^

w_full: $(TEST_DIR)/w_full_test.sv $(SRC_DIR)/w_full.sv
	$(SIMULATOR) $^

fifo: $(TEST_DIR)/fifo_test.sv $(SRC_DIR)/fifo.sv $(SRC_DIR)/mem.sv \
	$(SRC_DIR)/sync.sv $(SRC_DIR)/r_empty.sv $(SRC_DIR)/w_full.sv
	$(SIMULATOR) $^

send: $(TEST_DIR)/send_data.sv $(SRC_DIR)/fifo.sv $(SRC_DIR)/mem.sv \
	$(SRC_DIR)/sync.sv $(SRC_DIR)/r_empty.sv $(SRC_DIR)/w_full.sv
	$(SIMULATOR) $^
