module mem_test;

timeunit 1ns;
timeprecision 100ps;

logic [7:0] data, out;
logic [2:0] w_addr, r_addr;
logic w_en;
logic clk = 0;

always
  #2 clk = ~clk;

fifo_mem fifo_mem (.data(data), .out(out),
                   .w_addr(w_addr), .r_addr(r_addr),
                   .w_en(w_en), .clk(clk));

task verify (input [2:0] addr, input [7:0] expects);
  begin
    r_addr = addr; #1
    $display ( "%t r_addr=%b out=%b", $time, r_addr, out);
    if (out !== expects) begin
      $display( "out:%b expect:%b", out, expects);
      $display( "FIFOMEM TESTS FAILED");
      $finish;
    end
  end
endtask

initial begin
  @ (posedge clk)
  {data, w_addr, w_en} = 12'b01010101_000_1;
  @ (posedge clk)
  w_en = 1'b0; verify(3'b000, 8'b01010101);
  @ (posedge clk) verify(3'b000, 8'b01010101);
  {data, w_addr, w_en} = 12'b11111111_000_1;
  @ (posedge clk)
  verify(3'b000, 8'b11111111);
  {data, w_addr} = 11'b11110000_001;
  @ (posedge clk) verify(3'b001, 8'b11110000);

  {data, w_addr} = 11'b11101000_010;
  @ (posedge clk) verify(3'b010, 8'b11101000);

  {data, w_addr} = 11'b11011000_011;
  @ (posedge clk) verify(3'b011, 8'b11011000);

  {data, w_addr} = 11'b11100100_100;
  @ (posedge clk) verify(3'b100, 8'b11100100);

  {data, w_addr} = 11'b01101000_101;
  @ (posedge clk) verify(3'b101, 8'b01101000);

  {data, w_addr} = 11'b01101011_110;
  @ (posedge clk) verify(3'b110, 8'b01101011);

  {data, w_addr} = 11'b10101001_111;
  @ (posedge clk) verify(3'b111, 8'b10101001);
  w_en = 0;
  @ (posedge clk)
  @ (posedge clk)
  @ (posedge clk)
  verify(3'b000, 8'b11111111);
  verify(3'b001, 8'b11110000);
  verify(3'b010, 8'b11101000);
  verify(3'b011, 8'b11011000);
  verify(3'b100, 8'b11100100);
  verify(3'b101, 8'b01101000);
  verify(3'b101, 8'b01101000);
  verify(3'b110, 8'b01101011);
  verify(3'b111, 8'b10101001);

  $display ( "FIFOMEM TESTS PASSED");
  $finish;
end

endmodule