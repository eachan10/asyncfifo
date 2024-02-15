module r_empty_test;
timeunit 1ns;
timeprecision 100ps;

logic [3:0] w_ptr, r_ptr;
logic r_en = 0;
logic empty;
logic [2:0] r_addr;
logic rst = 1;
logic clk = 0;

always
  #5 clk = ~clk;

r_empty r_empty(.*);

task verify (logic [7:0] expects);
  // empty_r_ptr_r_addr
  begin
    $display ( "%t empty=%b r_ptr=%b r_addr=%b", $time, empty, r_ptr, r_addr);
    if ( {empty, r_ptr, r_addr} !== expects) begin
      $display ( "empty:%b r_ptr:%b r_addr:%b expects:%b_%b_%b",
                  empty, r_ptr, r_addr, expects[7], expects[6:3], expects[2:0]);
      $display ( "R_EMPTY TESTS FAILED");
      $finish;
    end
  end 
endtask

initial begin
  @ (posedge clk)
  rst = 0;
  w_ptr = 4'b0000;
  @ (posedge clk)
  rst = 1;
  #1 verify(8'b1_0000_000);
  @ (posedge clk)
  #1 verify(8'b1_0000_000);
  r_en = 1;
  @ (posedge clk)
  #1 verify(8'b1_0000_000);
  w_ptr = 4'b0111;  // 5
  @ (posedge clk)
  @ (posedge clk)
  #1 verify(8'b0_0001_001);
  @ (posedge clk)
  #1 verify(8'b0_0011_010);
  @ (posedge clk)
  #1 verify(8'b0_0010_011);
  @ (posedge clk)
  #1 verify(8'b0_0110_100);
  @ (posedge clk)
  #1 verify(8'b1_0111_101);
  w_ptr = 4'b1100;  // 8
  @ (posedge clk)
  #1 verify(8'b0_0111_101);
  @ (posedge clk)  // need extra clock cycle to update to be not empty
  #1 verify(8'b0_0101_110);
  @ (posedge clk) // now it can increment r_addr
  #1 verify(8'b0_0100_111);
  @ (posedge clk)
  #1 verify(8'b1_1100_000);
  r_en = 0;
  w_ptr = 4'b1000;
  @ (posedge clk)
  #1 verify(8'b0_1100_000);
  r_en = 1;
  @ (posedge clk)
  #1 verify(8'b0_1101_001);
  @ (posedge clk)
  #1 verify(8'b0_1111_010);
  w_ptr = 4'b0011;
  @ (posedge clk)
  #1 verify(8'b0_1110_011);
  @ (posedge clk)
  #1 verify(8'b0_1010_100);
  @ (posedge clk)
  #1 verify(8'b0_1011_101);
  @ (posedge clk)
  #1 verify(8'b0_1001_110);
  @ (posedge clk)
  #1 verify(8'b0_1000_111);
  @ (posedge clk)
  #1 verify(8'b0_0000_000);

  $display ( "R_EMPTY TESTS PASSED");
  $finish;
end

endmodule