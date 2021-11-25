module ram(input we, clk,
           input [15:0] din,
           input [7:0] addr,
           output reg [15:0] dout);
  reg [15:0] mem [256:0]; //256 16 bit regs
  
  //instructions are 16 bits but data is 8 bits. Pad the first byte of data with 0x00
   
  always @ (posedge clk) begin
    if (we) //when write enable is high, write the data on din to the address in memory
      mem[addr] <= din;
  end
  
  always @ (posedge clk) begin
    if (~we) // when write enable is low, read the data at the memory address and output it
      dout <= mem[addr];
  end
 
endmodule