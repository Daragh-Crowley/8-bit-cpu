// Use hierarchical design to create registers

module dff (input D, CE, CLR, C,
            output reg Q);

  always @(posedge C, CLR) begin
    case ({CLR, CE}) 
      2'b1x: Q <= 0; // set output to zero on clear signal
      2'b01: Q <= D; // on rising clock edge, set output to data if enabled
      2'b00: Q <= Q; // hold output when disabled
      default: Q <= 0; // default to prevent latch being formed
    endcase
  end  
endmodule


module register_4 (input [3:0] D, 
                   input CLK, CE, CLR,
                   output [3:0] Q);
  dff(D[0], CE, CLR, CLK, Q[0]); // connect each input and output to flip flop
  dff(D[1], CE, CLR, CLK, Q[1]);
  dff(D[2], CE, CLR, CLK, Q[2]);
  dff(D[3], CE, CLR, CLK, Q[3]);
endmodule

module register_8 (input [7:0] D,
                   input CLK, CE, CLR,
                   output [7:0] Q);
  register_4(D[3:0],CLK,CE,CLR,Q[3:0]); //use 2 4 bit registers to create 8 bit register
  register_4(D[7:4],CLK,CE,CLR,Q[7:4]);
endmodule

module register_16 (input [15:0] D,
                    input CLK, CE, CLR,
                    output [15:0] Q);
  register_8(D[7:0],CLK,CE,CLR,Q[7:0]); // use 2 8 bit registers to create 16 bit register
  register_8(D[15:8],CLK,CE,CLR,Q[15:8]);
endmodule
