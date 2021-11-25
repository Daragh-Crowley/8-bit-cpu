// Test bench for arithemtic logic unit
module alu_tb;
  wire [7:0] Z;
  wire Cout;
  reg [4:0] SEL;
  reg [7:0] A, B;
  cpu_alu alu_dut(.A(A), .B(B), .SEL(SEL), .Z(Z), .Cout(Cout));
  
  initial begin 
    // Test ADD
    $display("\nTest ADD");
    $display("A\t\tB\t\tZ\t\tCout\tSEL\t\tTest Result");    
    SEL = 5'b00000;
    A = 8'b00000110;
    B = 8'b00001000;
    #5
    if ( {Cout,Z}==A+B )
      $display("%b\t%b\t%b\t%b\t%b\t\tPASS", A,B,Z,Cout,SEL);
    else
      $display("%b\t%b\t%b\t%b\t%b\t\tFAIL", A,B,Z,Cout,SEL);
    
    A = 8'b11111111;
    B = 8'b00001000;
    #5
    if ( {Cout,Z}==A+B )
      $display("%b\t%b\t%b\t%b\t%b\t\tPASS", A,B,Z,Cout,SEL);
    else
      $display("%b\t%b\t%b\t%b\t%b\t\tFAIL", A,B,Z,Cout,SEL);
    
    //*********************************************************\\
    
    // Test bitwise and
    $display("\nTest bitwise AND");
    $display("A\t\tB\t\tZ\t\tCout\tSEL\t\tTest Result");    
    SEL = 5'b00001;
    A = 8'b00000110;
    B = 8'b00001000;
    #5
    $display("%b\t%b\t%b\t%b\t%b\t\tPASS", A,B,Z,Cout,SEL);
    
    A = 8'b11111111;
    B = 8'b00001000;
    #5
    $display("%b\t%b\t%b\t%b\t%b\t\tPASS", A,B,Z,Cout,SEL);
    
    //*********************************************************\\
    
    // test A pass through
    $display("\nTest A pass through");
    $display("A\t\tB\t\tZ\t\tCout\tSEL\t\tTest Result");    
    SEL = 5'b00010;
    A = 8'b00000110;
    B = 8'b00001000;
    #5
    if ( Z==A )
      $display("%b\t%b\t%b\t%b\t%b\t\tPASS", A,B,Z,Cout,SEL);
    else
      $display("%b\t%b\t%b\t%b\t%b\t\tFAIL", A,B,Z,Cout,SEL);
    
    A = 8'b11111111;
    B = 8'b00001000;
    #5
    if ( Z==A )
      $display("%b\t%b\t%b\t%b\t%b\t\tPASS", A,B,Z,Cout,SEL);
    else
      $display("%b\t%b\t%b\t%b\t%b\t\tFAIL", A,B,Z,Cout,SEL);
    
    //*********************************************************\\
    
    // test B pass through
    $display("\nTest B pass through");
    $display("A\t\tB\t\tZ\t\tCout\tSEL\t\tTest Result");    
    SEL = 5'b00011;
    A = 8'b00000110;
    B = 8'b11101100;
    #5
    if ( Z==B )
      $display("%b\t%b\t%b\t%b\t%b\t\tPASS", A,B,Z,Cout,SEL);
    else
      $display("%b\t%b\t%b\t%b\t%b\t\tFAIL", A,B,Z,Cout,SEL);
    
    A = 8'b11111111;
    B = 8'b01001011;
    #5
    if ( Z==B )
      $display("%b\t%b\t%b\t%b\t%b\t\tPASS", A,B,Z,Cout,SEL);
    else
      $display("%b\t%b\t%b\t%b\t%b\t\tFAIL", A,B,Z,Cout,SEL);
    
    //*********************************************************\\
    
   	// test subtract A-B
    $display("\nTest subtract");
    $display("A\t\tB\t\tZ\t\tCout\tSEL\t\tTest Result");    
    SEL = 5'b01100;
    A = 8'b00000110;
    B = 8'b11101100;
    #5
    if ( Z==A-B )
      $display("%b\t%b\t%b\t%b\t%b\t\tPASS", A,B,Z,Cout,SEL);
    else
      $display("%b\t%b\t%b\t%b\t%b\t\tFAIL", A,B,Z,Cout,SEL);
    
    A = 8'b11111111;
    B = 8'b01001011;
    #5
    if ( Z==A-B )
      $display("%b\t%b\t%b\t%b\t%b\t\tPASS", A,B,Z,Cout,SEL);
    else
      $display("%b\t%b\t%b\t%b\t%b\t\tFAIL", A,B,Z,Cout,SEL);
    
    //*********************************************************\\
    
    // test increment Z
    $display("\nTest increment");
    $display("A\t\tB\t\tZ\t\tCout\tSEL\t\tTest Result");    
    A = 8'b00000110;
    SEL = 5'b10100; // change to increment mode
    #5
    if ( Z==8'b00000111 )
      $display("%b\t%b\t%b\t%b\t%b\t\tPASS", A,B,Z,Cout,SEL);
    else
      $display("%b\t%b\t%b\t%b\t%b\t\tFAIL", A,B,Z,Cout,SEL);
	
    A = 8'b11111111;
    #5
    if ( {Cout,Z} == 9'b100000000 )
      $display("%b\t%b\t%b\t%b\t%b\t\tPASS", A,B,Z,Cout,SEL);
    else
      $display("%b\t%b\t%b\t%b\t%b\t\tFAIL", A,B,Z,Cout,SEL);
    
    //*********************************************************\\
    
    // test add and increment
    $display("\nTest ADD and increment");
    $display("A\t\tB\t\tZ\t\tCout\tSEL\t\tTest Result");    
    SEL = 5'b00100;
    A = 8'b00000110;
    B = 8'b11101100;
    #5
    if ( {Cout,Z}==A+B+1 )
      $display("%b\t%b\t%b\t%b\t%b\t\tPASS", A,B,Z,Cout,SEL);
    else
      $display("%b\t%b\t%b\t%b\t%b\t\tFAIL", A,B,Z,Cout,SEL);
    
    A = 8'b11111111;
    B = 8'b01001011;
    #5
    if ( {Cout,Z}==A+B+1 )
      $display("%b\t%b\t%b\t%b\t%b\t\tPASS", A,B,Z,Cout,SEL);
    else
      $display("%b\t%b\t%b\t%b\t%b\t\tFAIL", A,B,Z,Cout,SEL);
    
    //*********************************************************\\
    
    // test subtract and decrement
    $display("\nTest subtract and decrement");
    $display("A\t\tB\t\tZ\t\tCout\tSEL\t\tTest Result");    
    SEL = 5'b01000;
    A = 8'b11101100;
    B = 8'b00000110;
    
    #5
    if ( {Cout,Z}==A-B-1 ) 
      $display("%b\t%b\t%b\t%b\t%b\t\tPASS", A,B,Z,Cout,SEL);
    else
      $display("%b\t%b\t%b\t%b\t%b\t\tFAIL", A,B,Z,Cout,SEL);
    
    A = 8'b11111111;
    B = 8'b01001011;
    #5
    if ( Z==A-B-1 )
      $display("%b\t%b\t%b\t%b\t%b\t\tPASS", A,B,Z,Cout,SEL);
    else
      $display("%b\t%b\t%b\t%b\t%b\t\tFAIL", A,B,Z,Cout,SEL);
    
    //*********************************************************\\
    
    // test default
    $display("\nTest default");
    $display("A\t\tB\t\tZ\t\tCout\tSEL\t\tTest Result");    
    SEL = 5'b11111;
    A = 8'b00000110;
    B = 8'b11101100;
    #5
    if ( Z==8'b00000000 )
      $display("%b\t%b\t%b\t%b\t%b\t\tPASS", A,B,Z,Cout,SEL);
    else
      $display("%b\t%b\t%b\t%b\t%b\t\tFAIL", A,B,Z,Cout,SEL);
    
    A = 8'b11111111;
    B = 8'b01001011;
    #5
    if ( Z==8'b00000000 )
      $display("%b\t%b\t%b\t%b\t%b\t\tPASS", A,B,Z,Cout,SEL);
    else
      $display("%b\t%b\t%b\t%b\t%b\t\tFAIL", A,B,Z,Cout,SEL);
    
    
  end
  
  initial begin
    //dump waveform
    $dumpfile("dump.vcd"); $dumpvars;    
  end
endmodule