module w_full_tests;
timeunit 1ns;
timeprecision 100ps;

logic [3:0] r_ptr, w_ptr;
logic w_en = 0;
logic full;
logic [2:0] w_addr;
logic rst = 1;
logic clk = 0;

always
  #5 clk = ~clk;

w_full w_full(.*);

task verify (logic [7:0] expects);
  // full_w_ptr_w_addr
  begin
    $display ( "%t full=%b w_ptr=%b w_addr=%b", $time, full, w_ptr, w_addr);
    if ( {full, w_ptr, w_addr} !== expects) begin
      $display ( "full:%b w_ptr:%b w_addr:%b expects:%b_%b_%b",
                  full, w_ptr, w_addr, expects[7], expects[6:3], expects[2:0]);
      $display ( "W_FULL TESTS FAILED");
      $finish;
    end
  end 
endtask

initial begin
  @ (posedge clk)
  rst = 0;
  r_ptr = 4'b0000;
  @ (posedge clk)
  rst = 1;
  #1 verify(8'b0_0000_000);
  @ (posedge clk)
  #1 verify(8'b0_0000_000);
  w_en = 1;
  @ (posedge clk)
  #1 verify(8'b0_0001_001);
  @ (posedge clk)
  #1 verify(8'b0_0011_010);
  @ (posedge clk)
  #1 verify(8'b0_0010_011);
  @ (posedge clk)
  #1 verify(8'b0_0110_100);
  @ (posedge clk)
  #1 verify(8'b0_0111_101);
  @ (posedge clk)
  #1 verify(8'b0_0101_110);
  @ (posedge clk)
  #1 verify(8'b0_0100_111);
  @ (posedge clk)
  #1 verify(8'b1_1100_000);
  r_ptr = 4'b0100;  // 7
  @ (posedge clk)  // update full
  #1 verify(8'b0_1100_000); // 8
  @ (posedge clk)  // can write again
  #1 verify(8'b0_1101_001); // 9
  w_en = 0;
  @ (posedge clk)
  #1 verify(8'b0_1101_001); // 9
  w_en = 1;
  @ (posedge clk)
  #1 verify(8'b0_1111_010); // 10
  @ (posedge clk)
  #1 verify(8'b0_1110_011); // 11
  @ (posedge clk)
  #1 verify(8'b0_1010_100); // 12
  @ (posedge clk)
  #1 verify(8'b0_1011_101); // 13
  r_ptr = 4'b1111; // 10
  @ (posedge clk)
  #1 verify(8'b0_1001_110); // 14
  @ (posedge clk)
  #1 verify(8'b0_1000_111); // 15
  @ (posedge clk)
  #1 verify(8'b0_0000_000); // 0

  $display ( "W_FULL TESTS PASSED");
  $finish;
end

endmodule