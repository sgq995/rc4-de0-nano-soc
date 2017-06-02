module rc4_old_tb();
wire ready;
wire [7:0] k;

reg clk;
reg rst;
reg [7:0] keyinput;

reg [7:0] msg[0:8];
reg [3:0] i;

rc4 my_rc4(ready, k, clk, rst, keyinput);
defparam my_rc4.keylength = 3;

initial begin
  clk = 0;
  rst = 1;
    
  msg[0] = 80;
  msg[1] = 108;
  msg[2] = 97;
  msg[3] = 105;
  msg[4] = 110;
  msg[5] = 116;
  msg[6] = 101;
  msg[7] = 120;
  msg[8] = 116;
  
  i = 0;
  
  #1 rst = 0;
  keyinput = 75;
  #1 keyinput = 101;
  #2 keyinput = 121;
end

always #1 clk = ~clk;

always @ (posedge ready) begin
  if (i < 4'h9) begin
    $display("msg[%d] = %02X, k = %02X, rc4: %02X", i, msg[i], k, k ^ msg[i]);
    i = i + 4'h1;
  end
end

endmodule
