module sync_test;

timeunit 1ns;
timeprecision 100ps;

logic [3:0] ptr_in, ptr_out;
logic rst = 1;
logic clk = 0;

always
  #5 clk = ~clk;

sync sync (.ptr_in(ptr_in), .ptr_out(ptr_out), .clk(clk), .rst(rst));

task verify (input [3:0] expects);
  begin
    $display ( "%t ptr_out=%b", $time, ptr_out);
    if (ptr_out !== expects) begin
      $display( "ptr_out:%b expect:%b", ptr_out, expects);
      $display( "SYNC TESTS FAILED");
      $finish;
    end
  end
endtask

initial begin
  @ (posedge clk)
  #1 rst = 0; #1 verify(3'b000);
  rst = 1;
  ptr_in = 3'b101;
  @ (posedge clk) @ (posedge clk) #1 verify(3'b101);
  ptr_in = 3'b011;
  @ (posedge clk) @ (posedge clk) #1 verify(3'b011);
  rst = 0; #1 verify(3'b000);

  $display( "SYNC TESTS PASSED");
  $finish;
end

endmodule