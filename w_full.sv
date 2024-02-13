module w_full (
  input logic [3:0] r_ptr,
  input logic w_en,
  input logic rst,
  input logic clk,
  output logic [2:0] w_addr,
  output logic [3:0] w_ptr,
  output logic full,
  output logic almost_full
);
  timeunit 1ns;
  timeprecision 100ps;

  logic [3:0] w_bin;
  logic [3:0] w_bin_next;
  logic [3:0] w_gray_next;
  logic full_next, almost_full_next;
  logic [3:0] r_bin;
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
    r_bin = r_ptr ^ (r_ptr >> 1);
    r_bin = r_bin ^ (r_ptr >> 2);
    r_bin = r_bin ^ (r_ptr >> 3);
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
    w_addr <= w_bin[2:0];
  end

  always_comb begin
    w_gray_next <= w_bin_next ^ (w_bin_next >> 1);
  end

  always_comb begin
    full_next <= (w_gray_next == {~r_ptr[3:2], r_ptr[1:0]});
  end
endmodule