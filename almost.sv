module almost (input logic [2:0] w_addr, r_addr,
               input logic empty, full,
               output logic almost_empty, almost_full);
  timeunit 1ns;
  timeprecision 100ps;

  logic [3:0] addr_diff;

  always_comb begin
    if (w_addr > r_addr)
      addr_diff = {1'b0, w_addr} - {1'b0, r_addr};
    else
      addr_diff = 4'b1000 - {1'b0, r_addr} + {1'b0, w_addr};
  // if difference is 0 then use full and empty flags to determine which is right
    if (addr_diff == 4'b1000) begin // happens when r_addr = w_addr
      almost_empty <= empty;
      almost_full <= full;
    end
    else if (addr_diff < 4) begin
      almost_empty <= 1;
      almost_full <= 0;
    end
    else if (addr_diff > 5) begin
      almost_empty <= 0;
      almost_full <= 1;
    end
    else begin
      almost_empty <= 0;
      almost_full <= 0;
    end
  end
endmodule