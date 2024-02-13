module fifo_mem (
  input logic [7:0] data,
  input logic [2:0] w_addr,
  input logic [2:0] r_addr,
  input logic w_en,
  input logic clk,
  output logic [7:0] out
);
  timeunit 1ns;
  timeprecision 100ps;

  logic [7:0] mem [0:7];

  always_ff @ (posedge clk) begin
    if (w_en)
      mem[w_addr] = data;
  end

  always_comb begin
    out <= mem[r_addr];
  end

endmodule