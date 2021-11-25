/*
Testbench
Student Name: Daragh Crowley
Student number: 117318203
8 bit CPU design adapted from simplecpudesign.com
EE4023 Digital IC Design Project, UCC
*/

module computer_tb;
  
  wire SERIAL_OUT;
  
  reg NCLR, CLK;
  
  computer dut(NCLR, CLK, SERIAL_OUT);
  
  always #5 CLK =~CLK;
  
  initial begin
  	CLK = 1'b0;  
    NCLR = 1'b0; #5 NCLR=1'b1; #5 NCLR = 1'b0;
    
    
    // simple adding and subtracting instruction test
    // Read from memory, add number, write to memory, subtract numbers
    computer_tb.dut.memory.mem[8'h00] = 16'b1010000000000111; // INPUT ACC 7
	computer_tb.dut.memory.mem[8'h01] = 16'b0100000000001010; // ADD ACC 10
    computer_tb.dut.memory.mem[8'h02] = 16'b1110000000001000; // OUTPUT ACC, 8
    computer_tb.dut.memory.mem[8'h03] = 16'b0000000011111111; // LOAD ACC 255
    computer_tb.dut.memory.mem[8'h04] = 16'b0110000000000010; // SUB 2
    computer_tb.dut.memory.mem[8'h05] = 16'b1110000000001001; // OUTPUT ACC, 9
    computer_tb.dut.memory.mem[8'h06] = 16'b1000000000000000; // JUMP  00
    computer_tb.dut.memory.mem[8'h07] = 16'b0000000001100100; // DATA 100
    computer_tb.dut.memory.mem[8'h08] = 16'b0000000000000000; // DATA 0
    computer_tb.dut.memory.mem[8'h09] = 16'b0000000000000000; // DATA 0
    
    
    // Full instruction test set with traps that cause infinite loops 
    /*
    dut.memory.mem['h00] = 16'b0000000000000001; // LOAD ACC 0x01     -
    dut.memory.mem['h01] = 16'b0100000000000000; // ADD ACC, 0x00     - test NZ NC ACC=1    
    dut.memory.mem['h02] = 16'b0100000011111111; // ADD ACC, 0xFF     - test Z  C  ACC=0    
    dut.memory.mem['h03] = 16'b0000000010101010; // LOAD ACC 0xAA     -
    dut.memory.mem['h04] = 16'b0001000000001111; // AND ACC, 0x0F     - test NZ NC ACC=0x0A
    dut.memory.mem['h05] = 16'b0001000000000000; // AND ACC, 0x00     - test Z  NC ACC=0x00
    dut.memory.mem['h06] = 16'b0000000000000001; // LOAD ACC 0x01     -
    dut.memory.mem['h07] = 16'b0110000000000001; // SUB ACC, 0x01     - test Z  NC ACC=0x00
    dut.memory.mem['h08] = 16'b0110000000000001; // SUB ACC, 0x01     - test NZ C  ACC=0xFF
    dut.memory.mem['h09] = 16'b1110000011110000; // OUTPUT ACC, 0xF0  - test M[0xF0] = 0xFF
    dut.memory.mem['h0A] = 16'b0000000000000000; // LOAD ACC 0x00     -
    dut.memory.mem['h0B] = 16'b1010000011110000; // INPUT ACC, 0xF0   - test ACC = 0xFF
    dut.memory.mem['h0C] = 16'b0100000000000000; // ADD ACC, 0x00     - test NZ NC ACC=0x01
    dut.memory.mem['h0D] = 16'b1001010000001111; // JUMP NZ, 0x0F     - skip trap if correct
    dut.memory.mem['h0E] = 16'b1000000000001110; // JUMP 0x0E         - trap
    dut.memory.mem['h0F] = 16'b0100000000000001; // ADD ACC, 0x01     - test Z NC ACC=0x00
    dut.memory.mem['h10] = 16'b1001000000010010; // JUMP Z, 0x12      - skip trap if correct
    dut.memory.mem['h11] = 16'b1000000000010001; // JUMP 0x11         - trap
    dut.memory.mem['h12] = 16'b0000000000000010; // LOAD ACC 0x02
    dut.memory.mem['h13] = 16'b0100000011111111; // ADD ACC, 0xFF     - test NZ C ACC=0x01
    dut.memory.mem['h14] = 16'b1001100000010110; // JUMP C, 0x16      - skip trap if correct
    dut.memory.mem['h15] = 16'b1000000000010101; // JUMP 0x15         - trap
    dut.memory.mem['h16] = 16'b0110000000000001; // SUB ACC, 0x01     - test Z  NC ACC=0x00
    dut.memory.mem['h17] = 16'b1001100000011001; // JUMP NC, 0x19     - skip trap if correct
    dut.memory.mem['h18] = 16'b1000000000011000; // JUMP 0x15         - trap
    dut.memory.mem['h19] = 16'b1000000000000000; // JUMP 0x00         - loop
    */
    
  
    
    #50 // Hold reset for 5 clock cycles to ensure all registers initialize properly
    
    NCLR = 1'b1; // Turn off reset, processor begins operations
    
    
    
    #400
    // Verify that correct number is stored in memory from computation 100 + 10
    $display("\nCheck RAM ");
    $display("Expected:\t%b",16'b0000000001101110);
    $display("Data stored:\t%b",dut.memory.mem[8]);
    $finish;
  end
  
    
    
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
  
endmodule