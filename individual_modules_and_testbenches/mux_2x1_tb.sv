// test bench for 8 bit 2x1 mux
`timescale 10ns/1ps
module mux_2x1_tb;
  reg [7:0] A, B, Z;
  reg SEL;
  
  mux_2x1_8 mux_dut(.Z(Z),
                  .A(A), 
                  .B(B),
                  .SEL(SEL));
  
  initial begin
    $display("Result\tSEL\tA\tB\tZ"); //testbench output heading
    A <= 8'b01001000;
    B <= 8'b01010101;
    
    SEL = 0; // select A input
    #1
    if (Z == A) // check that the output matches the input on A
      $display ("PASS\t%p\t%p\t%p\t%p",SEL,A,B,Z);
    else
      $display ("FAIL\t%p\t%p\t%p\t%p",SEL,A,B,Z);
    
    #10 SEL = 1; // select B input
    
    #1
    if (Z == B) // check that the output matches the input on B
      $display ("PASS\t%p\t%p\t%p\t%p",SEL,A,B,Z);
    else
      $display ("FAIL\t%p\t%p\t%p\t%p",SEL,A,B,Z);
  	
    #10 SEL = 0;
  end
  
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
  
endmodule
