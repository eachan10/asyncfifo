module almost_test;
  timeunit 1ns;
  timeprecision 100ps;

  logic [2:0] w_addr, r_addr;
  logic almost_empty, almost_full, empty, full;
  almost almost (.*);

  task verify(logic [1:0] expects);
  begin
    $display ( "%t almost_empty=%b almost_full=%b", $time, almost_empty, almost_full);
    if ( {almost_empty, almost_full} !== expects) begin
      $display ( "almost_empty:%b almost_full:%b expects:%b_%b",
                  almost_empty, almost_full, expects[1], expects[0]);
      $display ( "ALMOST TESTS FAILED" );
      $finish;
    end
  end
  endtask

initial begin
  empty = 0;
  full = 0;
  w_addr = 3'b111;
  r_addr = 3'b100;
  #1 verify(2'b10);
  r_addr = 3'b011;
  #1 verify(2'b00);
  w_addr = 3'b000;
  r_addr = 3'b110;
  #1 verify(2'b10);
  r_addr = 3'b011;
  #1 verify(2'b00);
  r_addr = 3'b100;
  w_addr = 3'b000;
  #1 verify(2'b00);
  r_addr = 3'b000;
  w_addr = 3'b000;
  empty = 1;
  #1 verify(2'b10);

  $display ( "ALMOST TESTS PASSED" );
  $finish;
end
endmodule