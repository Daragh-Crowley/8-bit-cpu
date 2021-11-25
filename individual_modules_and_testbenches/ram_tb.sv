module ram_tb;
  
  reg clk, we;
  wire [15:0] data_out;
  reg [7:0] addr;
  reg [15:0] tb_data;
  
  ram dut(we,clk,tb_data,addr,data_out);
  
  always #5 clk = ~clk;
  
  integer k;
  
  initial begin
    $display("k\tdata");
    clk <= 0;
    we <= 1; //set write enable high to enable writing to memory
    #10
    for (k=0; k<256; k=k+1) begin
   	  #10addr = k;
      tb_data = k*20; //store 20*k in each memory address k 
      
    end
    
    #20
    we<=0; // set write enable low to enable reading from memory
    #20
    for (k=0; k<256; k=k+1) begin
      addr = k;
      #10;
      if(data_out == (k*20))
        $display("PASS\t Expected:%p\tData out:%p",k*20,data_out);
      else
        $display("FAIL\t Expected:%p\tData out:%p",k*20,data_out);
      
    end
    
    #10 $finish;
  end
  
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
 
endmodule