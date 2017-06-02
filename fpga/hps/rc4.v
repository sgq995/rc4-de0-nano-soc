module rc4(clk, reset_n, streamvalue, ready, keydata, enable);
`define RC4_KEYREAD1 4'h0
`define RC4_KEYREAD2 4'h1

`define RC4_KSA1 4'h2
`define RC4_KSA2 4'h3
`define RC4_KSA3 4'h4

`define RC4_PRGA1 4'h5
`define RC4_PRGA2 4'h6
`define RC4_PRGA3 4'h7
`define RC4_PRGA4 4'h8
`define RC4_PRGA5 4'h9

// inputs
input clk;
input reset_n;

// outputs
output reg [7:0] streamvalue;
output reg ready;

// inputs
input [7:0] keydata; // one byte of key per cycle
input enable;

// internal
reg [7:0] keylength;
reg [7:0] key[0:255];

reg [3:0] state;

reg [7:0] stream[0:255];
reg [7:0] stream_temp;

reg [7:0] i;
reg [7:0] j;

reg [7:0] tmp;

// initialize
//assign control_in = (write & ~read) ? control : 1'bz;
//assign control = (~write & read) ? control_out : 1'bz;
assign control_out = ready;

initial begin
  streamvalue = 0;
  ready = 0;

  state = `RC4_KEYREAD1;

  i = 8'h00;
  j = 8'h00;
end

always @ (posedge clk) begin
  if (~reset_n) begin
    streamvalue = 0;
    ready = 0;

    state = `RC4_KEYREAD1;
    
    i = 8'h00;
    j = 8'h00;
  end else begin
    case (state)
      // read key every cylce until key length
      `RC4_KEYREAD1: begin
        if (enable) begin
          keylength = keydata;
          state = `RC4_KEYREAD2;
        end
      end
      
      `RC4_KEYREAD2: begin
        if (i == keylength) begin
          state = `RC4_KSA1;
          i = 8'h00;
        end else if (enable) begin
            $display("key[%d] = %02X", i, keydata);
            key[i] = keydata;
            i = i + 8'h01;
        end
      end
    
      // initialize stream
      `RC4_KSA1: begin
        stream[i] = i;
        if (i == 8'hff) begin
          state = `RC4_KSA2;
          i = 8'h00;
        end else begin
          i = i + 8'h01;
        end
      end
      
      // calcule j for use in next cycle
      `RC4_KSA2: begin
        state = `RC4_KSA3;
        stream_temp = stream[i];
        j = j + stream[i] + key[i % keylength];
      end
      
      // swap values in stream
      `RC4_KSA3: begin
        stream[i] = stream[j];
        // stream[j] = stream[i];
        stream[j] = stream_temp;
        
        if (i == 8'hff) begin
          // ready to use prga
          state = `RC4_PRGA1;

          i = 8'h01;
          j = stream[1];
        end else begin
          state = `RC4_KSA2;
          i = i + 8'h01;
        end
      end
      
      `RC4_PRGA1: begin
        if (enable) begin
          ready = 0;
          state = `RC4_PRGA2;
        end
      end
      
      // save data for swap
      `RC4_PRGA2: begin
        state = `RC4_PRGA3;
        stream_temp = stream[i];
      end
      
      // swap values in stream
      `RC4_PRGA3: begin    
        state = `RC4_PRGA4;
        stream[i] = stream[j];
        stream[j] = stream_temp;
      end
   
      `RC4_PRGA4: begin
        state = `RC4_PRGA5;     
        tmp = stream[i] + stream[j];
      end
   
      // take k and then output
      `RC4_PRGA5: begin
        ready = 1;
        streamvalue = stream[tmp];
        
        state = `RC4_PRGA1;
        
        if (i == 8'hff) j = j + stream[0];
        else j = j + stream[i + 1];
        i = i + 1;
      end
      
      default: begin
      end
    endcase
  end
end
endmodule
