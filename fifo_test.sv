/*
 * I designed my tests such that they are not depedent on clock periods
 * so I can reuse the same set of tests but with different clock period
 * parameters to stress test the fifo. I just have to test the full and
 * empty edge conditions because I already tested other aspects with the
 * individual tests like wrapping of addresses.
*/

class Numbers;
  rand bit [7:0] numbers [16];
endclass

module sync_fifo_test (input logic start,
                       output logic done);

parameter int R_CLK_PERIOD = 20;
parameter int W_CLK_PERIOD = 12;
parameter int TEST_NUMBER = 0;

timeunit 1ns;
timeprecision 100ps;

logic r_clk = 1'b0;
logic w_clk = 1'b0;

logic [7:0] w_data, out;
logic w_en = 0;
logic r_en = 0;
logic rst = 1;
logic empty, full, almost_empty, almost_full;
Numbers arr;

sync_fifo sync_fifo(.w_data(w_data), .out(out),
                    .w_en(w_en), .r_en(r_en),
                    .rst(rst),
                    .r_clk(r_clk), .w_clk(w_clk),
                    .empty(empty), .full(full),
                    .almost_empty(almost_empty), .almost_full(almost_full));



always begin
  #(W_CLK_PERIOD/2) w_clk = ~w_clk;
end

always begin
  #(R_CLK_PERIOD/2) r_clk = ~r_clk;
end

task verify (logic [11:0] expects);
  // empty_r_ptr_r_addr
  begin
    $display ( "%t TEST%0d almost_empty=%b empty=%b almost_full=%b full=%b out=%b", $time, TEST_NUMBER,
               almost_empty, empty, almost_full, full, out);
    if ( {almost_empty, empty, almost_full, full, out} !== expects) begin
      $display ( "TEST%0d almost_empty:%b empty:%b almost_full:%b full:%b out:%b expects:%b_%b_%b_%b_%b",
                  TEST_NUMBER, almost_empty, empty, almost_full, full, out, expects[11], expects[10], expects[9], expects[8], expects[7:0]);
      // $display ("r_addr=%b w_addr=%b", sync_fifo.r_empty.r_bin, sync_fifo.r_empty.w_bin);
      $display ( "FIFO TESTS FAILED");
      $finish;
    end
  end 
endtask

initial
  begin
    done = 0;
    arr = new();
    void'(arr.randomize());
    // t=0
    rst <= 0;
    #1
    r_en = 1'b0;
    @ (posedge start)
    $display ( "BEGIN TEST%0d", TEST_NUMBER);
    {rst, w_en, w_data} = {2'b1_1, arr.numbers[0]};
    @ (posedge w_clk)  // write here
    // w_addr=1 r_addr=0
    #1 verify( {4'b1_1_0_0, arr.numbers[0]} );
    w_en = 1'b0;
    @(posedge r_clk)
    #1 verify( {4'b1_1_0_0, arr.numbers[0]} );
    @(posedge r_clk)
    @(posedge r_clk)
    // empty flag unset after 3 r_clk edges
    #1 verify( {4'b1_0_0_0, arr.numbers[0]} );
    {w_en, w_data} = {1'b1, arr.numbers[1]};
    @ (posedge w_clk)  // write #2 shouldn't change any output
    // w_addr=2 r_addr=0
    #1 verify( {4'b1_0_0_0, arr.numbers[0]} );
    w_data = arr.numbers[2];
    @ (posedge w_clk)  // write #3 shouldn't change any output
    // w_addr=3 r_addr=0
    #1 verify( {4'b1_0_0_0, arr.numbers[0]} );
    w_data = arr.numbers[3];
    @ (posedge w_clk)  // write #4 shouldn't change any output
    // w_addr=4 r_addr=0
    #1 verify( {4'b1_0_0_0, arr.numbers[0]} );
    w_en = 1'b0;
    @ (posedge r_clk)
    @ (posedge r_clk)
    @ (posedge r_clk)  // almost_empty should unset after 3 r_clk edges
    #1 verify( {4'b0_0_0_0, arr.numbers[0]} );
    w_en = 1'b1;
    w_data = arr.numbers[4];
    @ (posedge w_clk)  // write #5 shouldn't change any output
    // w_addr=5 r_addr=0
    #1 verify( {4'b0_0_0_0, arr.numbers[0]} );
    w_data = arr.numbers[5];
    @ (posedge w_clk)  // write #6 shouldn't change any output
    // w_addr=6 r_addr=0
    #1 verify( {4'b0_0_1_0, arr.numbers[0]} );
    w_data = arr.numbers[6];
    @ (posedge w_clk)  // write #7 shouldn't change any output
    // w_addr=7 r_addr=0
    #1 verify( {4'b0_0_1_0, arr.numbers[0]} );
    w_data = arr.numbers[7];
    @ (posedge w_clk)  // write #8 should be full now
    // w_addr=0 r_addr=0
    #1 verify( {4'b0_0_1_1, arr.numbers[0]} );
    w_data = arr.numbers[8];
    @ (posedge w_clk)
    w_en = 1'b0;
    @ (posedge r_clk)
    @ (posedge r_clk)
    @ (posedge r_clk) // need 3 r_clk to catch up the w_addr after writing so almost_empty updates as expected
    r_en = 1'b1;
    @ (posedge r_clk)
    // w_addr=0 r_addr=1
    #1 verify( {4'b0_0_1_1, arr.numbers[1]} );
    r_en = 1'b0;
    @ (posedge w_clk)
    @ (posedge w_clk)
    #1 verify( {4'b0_0_1_1, arr.numbers[1]} );
    @ (posedge w_clk)
    // 3 write clock rising edges then full should be unset
    #1 verify( {4'b0_0_1_0, arr.numbers[1]} );
    r_en = 1'b1;
    $display("READING");
    @ (posedge r_clk)
    // w_addr=0 r_addr=2
    #1 verify( {4'b0_0_1_0, arr.numbers[2]} );
    @ (posedge r_clk)
    // w_addr=0 r_addr=3
    #1 verify( {4'b0_0_1_0, arr.numbers[3]} );
    r_en = 1'b0;
    @ (posedge w_clk)
    @ (posedge w_clk)
    @ (posedge w_clk)  // 3 w_clk edges to unset almost_full
    #1 verify( {4'b0_0_0_0, arr.numbers[3]} );
    r_en = 1'b1;
    @ (posedge r_clk)
    // w_addr=0 r_addr=4
    #1 verify( {4'b0_0_0_0, arr.numbers[4]} );  // has 3 more to read now
    @ (posedge r_clk)
    // w_addr=0 r_addr=5
    #1 verify( {4'b1_0_0_0, arr.numbers[5]} );  // has 3 more to read now
    @ (posedge r_clk)
    // w_addr=0 r_addr=6
    #1 verify( {4'b1_0_0_0, arr.numbers[6]} );
    @ (posedge r_clk)
    // w_addr=0 r_addr=7
    #1 verify( {4'b1_0_0_0, arr.numbers[7]} );
    @ (posedge r_clk)
    // since full was high when w_data=numbers[9] nothing got written into
    // addr=000 so it should be numbers[0] still
    // w_addr=0 r_addr=0
    #1 verify( {4'b1_1_0_0, arr.numbers[0]} );  // this checks that write doesn't overwrite when full
    @ (posedge r_clk)
    #1 verify( {4'b1_1_0_0, arr.numbers[0]} );  // reading while empty does nothing

    $display ( "TEST%0d PASSED", TEST_NUMBER);

    done = 1;
  end
endmodule


module test;
  timeunit 1ns;
  timeprecision 100ps;

  logic start, done1, done2, done3, done4;
  sync_fifo_test #(20, 12, 1) test1(start, done1);
  sync_fifo_test #(12, 20, 2) test2(done1, done2,);
  sync_fifo_test #(70, 20, 3) test3(done2, done3);
  sync_fifo_test #(20, 70, 4) test4(done3, done4);

  initial begin
    start = 0;
    #1
    start = 1;

    @ (posedge done4)
    $display ("ALL FIFO TESTS PASSED");
    $finish;
  end
endmodule