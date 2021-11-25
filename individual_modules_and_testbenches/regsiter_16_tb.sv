module register_16_tb;
  wire [15:0] q;
  reg clk, ce, clr;
  reg [15:0] d;
  
  register_16 reg_dut(d,clk,ce,clr,q);
  always #5 clk = ~clk; // set up clock 

	initial begin
      clk = 1'b0;
	  clr = 1; # 10; clr = 0; #10;  // assert reset cycle to initialize the register
      
      ce = 1'b0; //disable the register
      d = $urandom%65535; // no output should appear while the register is disabled
      #10
      
      ce = 1'b1; // enable register and test some random numbers
      d = $urandom%65535;
      #10
      d = $urandom%65535;
      #10
      d = $urandom%65535;
      #10
      d = $urandom%65535;
      #10
      clr=1'b1;
      #10
      $finish;
    end
  
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule