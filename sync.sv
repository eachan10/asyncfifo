module sync (
  input logic [3:0] ptr_in,
  input logic clk,
  input logic rst,
  output logic [3:0] ptr_out
);
  timeunit 1ns;
  timeprecision 100ps;

  logic [3:0] ptr;

  always_ff @ (posedge clk or negedge rst) begin
    if (!rst) begin
      ptr_out <= 'b0;
      ptr <= 'b0;
    end
    else begin
      ptr_out <= ptr;
      ptr <= ptr_in;
    end
  end
endmodule