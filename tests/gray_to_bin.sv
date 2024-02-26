module gray_to_bin (
  input logic [3:0] ptr,
  output logic [3:0] bin
);
  always_comb begin
    bin = ptr;
    for (int i = 1; i <= 4; i++) begin
      bin ^= ptr >> i;
    end
  end
endmodule

module test;
  logic [3:0] ptr, bin;
  gray_to_bin g2b (.*);
  initial begin
    ptr = 4'b0000;
    #1 $display( "gray: %b bin: %b", ptr, bin);
    ptr = 4'b0001;
    #1 $display( "gray: %b bin: %b", ptr, bin);
    ptr = 4'b0011;
    #1 $display( "gray: %b bin: %b", ptr, bin);
    ptr = 4'b0010;
    #1 $display( "gray: %b bin: %b", ptr, bin);
    ptr = 4'b0110;
    #1 $display( "gray: %b bin: %b", ptr, bin);
    ptr = 4'b0111;
    #1 $display( "gray: %b bin: %b", ptr, bin);
    ptr = 4'b0101;
    #1 $display( "gray: %b bin: %b", ptr, bin);
    ptr = 4'b0100;
    #1 $display( "gray: %b bin: %b", ptr, bin);
    ptr = 4'b1100;
    #1 $display( "gray: %b bin: %b", ptr, bin);
    ptr = 4'b1101;
    #1 $display( "gray: %b bin: %b", ptr, bin);
    ptr = 4'b1111;
    #1 $display( "gray: %b bin: %b", ptr, bin);
    ptr = 4'b1110;
    #1 $display( "gray: %b bin: %b", ptr, bin);
    ptr = 4'b1010;
    #1 $display( "gray: %b bin: %b", ptr, bin);
    ptr = 4'b1011;
    #1 $display( "gray: %b bin: %b", ptr, bin);
    ptr = 4'b1001;
    #1 $display( "gray: %b bin: %b", ptr, bin);
    ptr = 4'b1000;
    #1 $display( "gray: %b bin: %b", ptr, bin);
  end
endmodule