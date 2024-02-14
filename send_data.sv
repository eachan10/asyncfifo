`define ARR_LEN 128
`define R_CLK 10
`define W_CLK 6
class Data;
  rand bit [7:0] data [`ARR_LEN];
endclass

module send_data;
timeunit 1ns;
timeprecision 100ps;

Data src;
bit [7:0] dest [`ARR_LEN];

int w = 0;
int r = 0;

logic r_clk = 1'b0;
logic w_clk = 1'b0;

logic [7:0] w_data, out;
logic w_en = 0;
logic r_en = 0;
logic rst = 1;
logic empty, full, almost_empty, almost_full;


async_fifo async_fifo(.w_data(w_data), .out(out),
                    .w_en(w_en), .r_en(r_en),
                    .rst(rst),
                    .r_clk(r_clk), .w_clk(w_clk),
                    .empty(empty), .full(full),
                    .almost_empty(almost_empty), .almost_full(almost_full));

always
  #`R_CLK r_clk = ~r_clk;

always
  #`W_CLK w_clk = ~w_clk;

initial begin
  src = new();
  void'(src.randomize());
  rst=1;
  #1
  rst=0;
  #1
  rst=1;
end

always @ (posedge w_clk) begin
  #1
  if (w < `ARR_LEN) begin
    if (!full) begin
      w_en <= 1;
      w_data <= src.data[w];
      w++;
    end
    else
      w_en <= 0;
  end
end

always @ (posedge r_clk) begin
  #1
  if (r < `ARR_LEN) begin
    if (!empty) begin
      r_en <= 1;
      dest[r] <= out;
      r++;
    end
    else
      r_en <= 0;
  end
  else begin
    foreach (src.data[i]) begin
      $display("%d: src: %d dest: %d", i, src.data[i], dest[i]);
      if (src.data[i] !== dest[i]) begin
        $display("FAILED TESTS");
        $finish;
      end
    end
    $display ("PASSED TESTS");
    $finish;
  end
end

endmodule