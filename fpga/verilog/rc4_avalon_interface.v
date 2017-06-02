module rc4_avalon_interface(clk, reset_n, byteenable, readdata,  writedata, read, write, chipselect);

input clk, reset_n, read, write, chipselect;
input [3:0] byteenable;
input [31:0] writedata;
output [31:0] readdata;

wire local_reset_n, local_ready, local_enable;
wire [7:0] local_streamvalue, local_keydata;

assign local_reset_n = (chipselect & write & byteenable[3]) ? ~writedata[25] : 1'b1;
assign local_enable = (chipselect & write & byteenable[3]) ? writedata[24] : 1'b0;

assign local_keydata = (chipselect & write & byteenable[0]) ? writedata[7:0] : 8'b0;

rc4 U1(
  .clk(clk),
  .reset_n(reset_n & local_reset_n), 
  .streamvalue(local_streamvalue),
  .ready(local_ready),
  .keydata(local_keydata),
  .enable(local_enable)
);

assign readdata[24] = local_ready;

assign readdata[7:0] = local_streamvalue;

endmodule
