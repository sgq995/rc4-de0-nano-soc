module reg32(clk, reset_n, d, q, byteenable);

input clk, reset_n;
input [23:0] d;
input [3:0] byteenable;
output reg [23:0] q;

always @(posedge clk) begin
  if (~reset_n) begin
    q = 32'b0;
  end else begin
    // if (byteenable[3]) q[31:24] = d[31:24];
    if (byteenable[2]) q[23:16] = d[23:16];
    if (byteenable[1]) q[15:8] = d[15:8];
    if (byteenable[0]) q[7:0] = d[7:0];
  end
end

endmodule
