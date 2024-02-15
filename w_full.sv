// Logic to determine current and next write addresses
// in memory, and to determine the full and almost_full
// flags. Synchronous to write clock domain.
module w_full #(parameter ADDR_SIZE=3) (
  input logic [ADDR_SIZE:0] r_ptr,
  input logic w_en,
  input logic rst,
  input logic clk,
  output logic [ADDR_SIZE-1:0] w_addr,
  output logic [ADDR_SIZE:0] w_ptr,
  output logic full,
  output logic almost_full
);
  timeunit 1ns;
  timeprecision 100ps;

  localparam MEM_SIZE = 1 << ADDR_SIZE;

  logic [ADDR_SIZE:0] w_bin;
  logic [ADDR_SIZE:0] w_bin_next;
  logic [ADDR_SIZE:0] w_gray_next;
  logic full_next, almost_full_next;
  logic [ADDR_SIZE:0] r_bin;

  // update gray code and binary at clock edge or asynchronous reset
  always_ff @ (posedge clk or negedge rst) begin
    if (!rst) begin
      w_bin <= 0;
      w_ptr <= 0;
    end
    else if (w_en) begin
      w_bin <= w_bin_next;
      w_ptr <= w_gray_next;
    end
  end

  // update full and almost full flags at clock edge
  always_ff @ (posedge clk or negedge rst) begin
    if (!rst) begin
      full <= 0;
      almost_full <= 0;
    end
    else begin
      full <= full_next;
      almost_full <= almost_full_next;
    end
  end

  // compute the binary value from write clock synchronized read gray code
  always_comb begin
    r_bin = r_ptr;
    for (int i = 1; i <= ADDR_SIZE; i++) begin
      r_bin ^= r_ptr >> i;
    end
  end

  // use the synchronized binary read address to calculate almost full condition
  always_comb begin
    if (full_next)
      almost_full_next = 1'b1;
    else begin
      if (w_bin_next > r_bin)
        almost_full_next = (w_bin_next - r_bin) >= (MEM_SIZE - (MEM_SIZE >> 2));
      else
        almost_full_next = (r_bin - w_bin_next) >= (MEM_SIZE - (MEM_SIZE >> 2));
    end
  end

  // update next binary address and the write address
  always_comb begin
    w_bin_next <= w_bin + (w_en & ~full);
    w_addr <= w_bin[ADDR_SIZE-1:0];
  end

  // compute the next gray code
  always_comb begin
    w_gray_next <= w_bin_next ^ (w_bin_next >> 1);
  end

  // compute the next full flag
  always_comb begin
    full_next <= (w_gray_next == {~r_ptr[ADDR_SIZE:ADDR_SIZE-1], r_ptr[ADDR_SIZE-2:0]});
  end
endmodule