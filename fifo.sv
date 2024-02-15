// Full asynchronous fifo module
module async_fifo #(parameter DATA_WIDTH=8, ADDR_SIZE=3) (
  input logic [7:0] w_data,
  input logic w_en,
  input logic r_en,
  input logic rst,
  input logic w_clk,
  input logic r_clk,
  output logic [7:0] out,
  output logic empty,
  output logic full,
  output logic almost_empty,
  output logic almost_full
);
  timeunit 1ns;
  timeprecision 100ps;

  logic [2:0] w_addr;
  logic [2:0] r_addr;
  logic [3:0] r_ptr, sync_r_ptr;
  logic [3:0] w_ptr, sync_w_ptr;
  logic write;

  // write wire goes into memory module to disable writing to memory
  // when the buffer is full
  always_comb begin
    write <= (w_en & ~full);
  end

  fifo_mem #(DATA_WIDTH, ADDR_SIZE) mem
               (.data(w_data),
                .w_addr(w_addr),
                .r_addr(r_addr),
                .w_en(write),
                .clk(w_clk),
                .out(out));

  sync #(ADDR_SIZE) w2r_sync
                (.ptr_in(w_ptr),
                 .clk(r_clk),
                 .rst(rst),
                 .ptr_out(sync_w_ptr));

  sync #(ADDR_SIZE) r2w_sync
                (.ptr_in(r_ptr),
                 .clk(w_clk),
                 .rst(rst),
                 .ptr_out(sync_r_ptr));

  w_full #(ADDR_SIZE) w_full
                (.r_ptr(sync_r_ptr),
                 .w_en(w_en),
                 .rst(rst),
                 .clk(w_clk),
                 .w_addr(w_addr),
                 .w_ptr(w_ptr),
                 .full(full),
                 .almost_full(almost_full));
  
  r_empty #(ADDR_SIZE) r_empty
                (.w_ptr(sync_w_ptr),
                 .r_en(r_en),
                 .rst(rst),
                 .clk(r_clk),
                 .r_addr(r_addr),
                 .r_ptr(r_ptr),
                 .empty(empty),
                 .almost_empty(almost_empty));

endmodule