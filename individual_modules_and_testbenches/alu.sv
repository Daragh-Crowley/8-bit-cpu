// Use behavioural modelling to achieve correct ALU performance 
// Arithemtic logic unit
module cpu_alu (input [7:0] A, B,
                input [4:0] SEL,
                output reg [7:0] Z,
                output reg Cout);
  always @ (A, B, SEL) begin
    case (SEL)
      // S4 S3 S2 S1 S0
      5'b00000: {Cout,Z} = A+B; //add
      5'b00001: {Cout,Z} = A & B; // bitwise and
      5'b00010: Z = A; // input A
      5'b00011: Z = B; // input B
      5'b01100: {Cout,Z} = A-B; //subtract
      5'b10100: {Cout,Z} = A + 1; //increment
      5'b10000: Z = A; // input A
      5'b00100: {Cout,Z} = A+B+1; // add and increment
      5'b01000: {Cout,Z} = A-B-1; //subtract and decrement
      default: Z=8'b00000000; // default case to prevent latching
    endcase
  end
  
endmodule