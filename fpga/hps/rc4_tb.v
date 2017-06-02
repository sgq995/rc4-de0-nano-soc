module rc4_tb();

wire control_out;
wire [7:0] streamvalue;
reg clk, rst_n, control_in, write, read;
reg [7:0] keylength, keydata;

rc4 U1(
  .control_out(control_out),
  .streamvalue(streamvalue),
  .clk(clk),
  .rst_n(rst_n),
  .control_in(control_in),
  .keylength(keylength),
  .keydata(keydata),
  .write(write),
  .read(read)
);

initial begin
  clk = 0;
  rst_n = 1;
  
  control_in = 0; write = 0;
  
  keylength = 8'b0;
  keydata = 8'b0;
  
  write = 0;
  read = 0;
  
  #1;
  keylength = 3;
  keydata = 75;
  write = 1;
  
  #1 write = 0;
  
  #9;
  keydata = 101;
  write = 1;
  
  #1 write = 0;
  
  #9;
  keydata = 121;
  write = 1;
  
  #1 write = 0;
  
  #1525;
  control_in = 1; write = 1;
  #1 
  control_in = 0; write = 0;
  #10;
  control_in = 1; write = 1;
  #1 
  control_in = 0; write = 0;
  #10;
  control_in = 1; write = 1;
  #1 
  control_in = 0; write = 0;
  #10;
  control_in = 1; write = 1;
  #1 
  control_in = 0; write = 0;
  #10;
  control_in = 1; write = 1;
  #1 
  control_in = 0; write = 0;
  #10;
  control_in = 1; write = 1;
  #1 
  control_in = 0; write = 0;
  #10;
  control_in = 1; write = 1;
  #1 
  control_in = 0; write = 0;
  #10;
  control_in = 1; write = 1;
  #1 
  control_in = 0; write = 0;
  #10;
  control_in = 1; write = 1;
  #1 
  control_in = 0; write = 0;
  #10;
  control_in = 1; write = 1;
  #1 
  control_in = 0; write = 0;
  #10;
  control_in = 1; write = 1;
  #1 
  control_in = 0; write = 0;
  #10;
  control_in = 1; write = 1;
  #1 
  control_in = 0; write = 0;
  #10;
  control_in = 1; write = 1;
  #1 
  control_in = 0; write = 0;
  #10;
  control_in = 1; write = 1;
  #1 
  control_in = 0; write = 0;
  #10;
  control_in = 1; write = 1;
  #1 
  control_in = 0; write = 0;
  #10;
  control_in = 1; write = 1;
  #1 
  control_in = 0; write = 0;
  #10;
  control_in = 1; write = 1;
  #1 
  control_in = 0; write = 0;
  #10;
  control_in = 1; write = 1;
  #1 
  control_in = 0; write = 0;
  #10;
  control_in = 1; write = 1;
  #1 
  control_in = 0; write = 0;
  #10;
  control_in = 1; write = 1;
  #1 
  control_in = 0; write = 0;
  #10;
  control_in = 1; write = 1;
  #1 
  control_in = 0; write = 0;
  #10;
  control_in = 1; write = 1;
  #1 
  control_in = 0; write = 0;
  #10;
  control_in = 1; write = 1;
  #1 
  control_in = 0; write = 0;
  #10;
  control_in = 1; write = 1;
  #1 
  control_in = 0; write = 0;
end

always @(posedge clk) begin
  /*if (control_out) begin
    control_in = 0; write = 0;
  end*/
end

always #1 clk = ~clk;
endmodule
