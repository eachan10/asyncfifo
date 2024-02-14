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

  logic [ADDR_SIZE:0] w_bin;
  logic [ADDR_SIZE:0] w_bin_next;
  logic [ADDR_SIZE:0] w_gray_next;
  logic full_next, almost_full_next;
  logic [ADDR_SIZE:0] r_bin;

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

  always_comb begin
    r_bin = r_ptr;
    for (int i = 1; i <= ADDR_SIZE; i++) begin
      r_bin ^= r_ptr >> i;
    end
  end

  always_comb begin
    if (full_next)
      almost_full_next = 1'b1;
    else begin
      if (w_bin_next > r_bin)
        almost_full_next = (w_bin_next - r_bin) > 5;
      else
        almost_full_next = (r_bin - w_bin_next) > 5;
    end
  end

  always_comb begin
    w_bin_next <= w_bin + (w_en & ~full);
    w_addr <= w_bin[ADDR_SIZE-1:0];
  end

  always_comb begin
    w_gray_next <= w_bin_next ^ (w_bin_next >> 1);
  end

  always_comb begin
    full_next <= (w_gray_next == {~r_ptr[ADDR_SIZE:ADDR_SIZE-1], r_ptr[ADDR_SIZE-2:0]});
  end
endmodule