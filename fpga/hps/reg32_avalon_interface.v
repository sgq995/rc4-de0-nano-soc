module reg32_avalon_interface(clk, reset_n, byteenable, writedata, readdata, write, read, chipselect);

input clk, reset_n, read, write, chipselect;
input [3:0] byteenable;
input [31:0] writedata;
output [31:0] readdata;

wire local_reset_n;
wire [3:0] local_byteenable;
wire [23:0] to_reg, from_reg;

assign local_reset_n = (chipselect & write & byteenable[3]) ? ~writedata[24] : 1'b1;
assign local_byteenable = (chipselect & write) ? byteenable : 4'b0;
assign to_reg = (chipselect & write) ? writedata[23:0] : 24'b0;

reg32 U1(
  .clk(clk),
  .reset_n(reset_n & local_reset_n),
  .d(to_reg),
  .q(from_reg),
  .byteenable(local_byteenable)
);

assign readdata[23:16] = from_reg[7:0];
assign readdata[15:8] = from_reg[15:8];
assign readdata[7:0] = from_reg[23:16];

endmodule
