// Logic to determine current and next read addresses
// in memory, and to determine the empty and almost_empty
// flags. Synchronous to read clock domain.
module r_empty #(parameter ADDR_SIZE=3) (
  input logic [ADDR_SIZE:0] w_ptr,
  input logic r_en,
  input logic rst,
  input logic clk,
  output logic [ADDR_SIZE-1:0] r_addr,
  output logic [ADDR_SIZE:0] r_ptr,
  output logic empty,
  output logic almost_empty
);
  timeunit 1ns;
  timeprecision 100ps;

  logic [ADDR_SIZE:0] r_bin;
  logic [ADDR_SIZE:0] r_bin_next;
  logic [ADDR_SIZE:0] r_gray_next;
  logic empty_next, almost_empty_next;
  logic [ADDR_SIZE:0] w_bin;

  // update gray code and binary address at clock edge or asynchronous reset
  always_ff @ (posedge clk or negedge rst) begin
    if (!rst) begin
      r_bin <= 0;
      r_ptr <= 0;
    end
    else if (r_en) begin
      r_bin <= r_bin_next;
      r_ptr <= r_gray_next;
    end
  end

  // update empty and almost empty flags at clock edge
  always_ff @ (posedge clk or negedge rst) begin
    if (!rst) begin
      empty <= 1;
      almost_empty <= 1;
    end
    else begin
      empty <= empty_next;
      almost_empty <= almost_empty_next;
    end
  end

  // compute the binary value from read clock synchronized write gray code
  always_comb begin
    w_bin = w_ptr;
    for (int i = 1; i <= ADDR_SIZE; i++) begin
      w_bin ^= w_ptr >> i;
    end
  end

  // use the sychronized binary write address to calculate almost empty condition
  always_comb begin
    if (r_bin_next[ADDR_SIZE-1:0] == w_bin[ADDR_SIZE-1:0])
      almost_empty_next = empty_next;
    else begin
      if (r_bin_next > w_bin)
      // figure out what to do here
        almost_empty_next = (r_bin_next - w_bin) < 4;
      else
        almost_empty_next = (w_bin - r_bin_next) < 4;
    end
  end

  // update next binary address and the read address
  always_comb begin
    r_bin_next <= r_bin + (r_en & ~empty);
    r_addr <= r_bin[ADDR_SIZE-1:0];
  end

  // compute the next gray code
  always_comb begin
    r_gray_next <= r_bin_next ^ (r_bin_next >> 1);
  end

  // compute the next empty flag
  always_comb begin
    empty_next <= (r_gray_next == w_ptr);
  end
endmodule