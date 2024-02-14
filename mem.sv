// Memory to store the buffer with synchronous write and asynchronous read
// There is no reset because the read and write pointers should keep track
// of when the memory is valid data.
module fifo_mem #(parameter DATA_WIDTH=8, MEM_SIZE=8, ADDR_SIZE=3) (
  input logic [DATA_WIDTH-1:0] data,
  input logic [ADDR_SIZE-1:0] w_addr,
  input logic [ADDR_SIZE-1:0] r_addr,
  input logic w_en,
  input logic clk,
  output logic [DATA_WIDTH-1:0] out
);
  timeunit 1ns;
  timeprecision 100ps;

  logic [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];

  // synchronous write at positive clock edge
  always_ff @ (posedge clk) begin
    if (w_en)
      mem[w_addr] = data;
  end

  // asynchronous read
  always_comb begin
    out <= mem[r_addr];
  end

endmodule