// 8 bit 2x1 mux

module mux_2x1_8 (output reg [7:0] Z,
                  input [7:0] A, B, 
                  input SEL);
  always @ (A, B, SEL)
    case (SEL)
      0: Z <= A; // if sel is 0 select A input
      1: Z <= B; // if sel is 1 select B input
      default: Z <= 8'b00000000; //default case to prevent latch being instantiated
    endcase
endmodule