# 8-Bit CPU Design and Implementation in Verilog

## Introduction

The aim of this project is to design a simple CPU and implement the design in Verilog. The CPU presented (from http://www.simplecpudesign.com/simple_cpu_v1/index.html) in this project is capable of adding and subtracting 8 bit numbers, reading data from memory and writing data to memory. The design is broken down into different modules to make use of hierarchies in Verilog. This makes it easy to build and test each component on its own before integrating them together. Testbenches are developed to test each stage of the design and the overall performance of the CPU and memory.

## Architecture

This CPU has five main components: multiplexers, an arithmetic logic unit (ALU), a decoder, registers, and memory (RAM) as seen here:

![image](https://user-images.githubusercontent.com/38920671/143467294-04c3cbf2-b13c-48aa-b84d-518a5ac969fc.png)

The CPU is comprised of 3 multiplexers, 3 registers, a decoder and the ALU. The CPU connects to a 256 address by 16 bit RAM module via data buses.

### Multiplexers

This design requires the use of 2-to-1 and 4-to-1 8 bit multiplexers for selecting data lines. The ALU uses a 4-to-1 internal multiplexer and the inputs to the ALU are selected using 2-to-1 multiplexers.

### ALU

The ALU has eight functions: addition, bitwise AND, input A, input B, subtraction, increment, add-and-increment and subtract-and-decrement. The function is selected by the 5 selection bits inputs. While the design presented on simplecpudesign.com creates individual modules with gate level modelling for each function, it was decided to implement the same functionality in one module using behavioural modelling and case statements and allowing Verilog to synthesise the logic itself. This saved a lot of design complexity and makes use of Synopsys’ intelligent simulation and synthesis tools.

### Registers

The registers use D type flip flops to store data on the rising edge of the clock input. An 8 bit register uses 8 D type flip flops to store each bit individually and similarly the 16 bit register uses 16 flip flops. The registers were created in a hierarchical manner by combining two 2 bit register to create the 4 bit register, two 4 bit registers to create the 8 bit register and so on. This shows the power of using hierarchical design to simplify design flow.

The program counter (PC) is an 8 bit register that stores the address in memory of the current instruction being executed. The accumulator is an 8 bit register that stores the data to be processed by the ALU and to store results produced. The instruction register (IR) is a 16 bit register that stores the instruction to be processed at the end of each fetch phase.

### Decoder

The processor has four operating states: fetch, decode, execute and increment. The instruction stored in the address of the RAM pointed to by the IR is loaded during the fetch state. During decode, the first byte of the 2 byte instruction is decoded by the instruction decoder. These instructions are load, add, AND, subtract, input, output and four jump instructions (go to address in memory of next instruction to be fetched, depending if there is a carry bit or a zero bit from the ALU add, subtract and AND functions). During the execute phase the ALU carries out the computation or passes through data and stores the result in the accumulator register. In the increment phase, the program counter gets updated with the next memory address to go to in the next cycle.

The instruction decoder is used to decode the instruction from machine code (1 byte). It is a combinational logic block with a one-hot encoded output as the processor can only carry out one instruction at a time. The instruction decoder was built in Verilog using case statements derived from the control signals.

To control the state of the processor, a sequence generator was created using a one-hot encoded ring oscillator with four outputs: fetch, decode, execute, and increment. On each clock pulse, the sequence generator progresses to the next state. It can be reset to the fetch state using the active high clear input and its current state can be held constant by setting the enable pin to low.

The jump instruction tells the system whether it needs to increment the PC or not, depending on if the next instruction has already been called from memory using the input instruction. The control logic for taking jumps is mainly combinational with a D type flip flop to store the output from the combinational logic for the next clock cycle. The block diagram for the decoder is shown here:

![image](https://user-images.githubusercontent.com/38920671/143467961-2b273c1f-c015-4a61-8216-54d2d9ca1683.png)

### Memory

This processor system uses a von Neumann architecture for the random access memory. The instructions and data are stored in the same memory. This has the advantages of being simpler to handle, requiring less physical space and being cheaper than other memory architectures. Its disadvantages are it is prone to memory leaks and the fetch rate is impacted by the need for data and instructions to share the same buses connecting it to the processor.

The memory implemented in this design stores 16 bits in 256 locations giving it a total storage of 512 bytes, or half a kilobyte. As the instructions are 16 bits but the data is only 8 bits, the data needs to be padded with a byte of zeros at the start. This results in only 50% of the data memory capacity being utilised. However, this approach is simpler than splitting instructions between memory locations or storing two data bytes in each memory location.

## Testing

The modules were tested individually during their development. This made it easier to find bugs in the designs and is in keeping with the hierarchical design and verification mindset used in industry.

### Multiplexers

To test the multiplexer design, different values were applied to each input and the testbench cycles through the inputs using the select pins to make sure the outputs match. 

### ALU

The ALU was also tested using self-checking logic. The tests are not exhaustive and are mainly used to check the ALU is operating in the correct mode for specific SEL inputs.

### Registers

The 16 bit register is tested by first asserting a reset cycle to set all bits to zero. The register is then enabled with the CE pin. Random data is passed to the data input and the waveform window is checked to ensure the data appears on the output on the next rising clock edge. The data is held by the register if the CE pin is set low and the register can also be reset using the CLR pin. Inputting and holding data for one clock cycle is seen in the following figure. The data at the input is seen at the output immediately after the next rising clock edge when the enable pin is held high.

![image](https://user-images.githubusercontent.com/38920671/143468334-c801cc5c-aa50-4a6c-af38-49196a5faf0d.png)


Random numbers were generated for the data in the testbench using the $urandom command in Verilog. This is useful for testing modules with random different data values. As the 16 bit register is made using the 8 bit, 4 bit and D flip flops in a hierarchical structure, verifying the functionality of the 16 bit register shows that the lower levels of hierarchy are working correctly.

### Decoder

As the decoder’s functionality is dependent on the whole system it was difficult to test individually. The testbench written for the decoder simply made sure that the decoder module compiled correctly. The instruction decoder was tested separately by making sure the instruction was correctly decoded and the correct output was set high and all others were low (one-hot encoded output). The decoder interprets machine code according to the following instruction set:

```
Load ACC kk   : 0000 XXXX KKKKKKKK
Add ACC kk    : 0100 XXXX KKKKKKKK
And ACC kk    : 0001 XXXX KKKKKKKK
Sub ACC kk    : 0110 XXXX KKKKKKKK
Input ACC pp  : 1010 XXXX PPPPPPPP
Output ACC pp : 1110 XXXX PPPPPPPP
Jump U aa     : 1000 XXXX AAAAAAAA
Jump Z aa     : 1001 00XX AAAAAAAA
Jump C aa     : 1001 10XX AAAAAAAA
Jump NZ aa    : 1001 01XX AAAAAAAA
Jump NC aa    : 1001 11XX AAAAAAAA
```

### Memory

The RAM module was tested by storing a value in each memory location by holding write enable high and looping through all the memory addresses. The data was then read from each memory location by holding write enable low and again cycling through each memory address. The testbench used self-checking to make sure that the data read from each address was the same as the data that was written to that address.

## System Testing

After verifying the functionality of each of the individual modules, the entire system was assembled following the architecture in the following figure.

![image](https://user-images.githubusercontent.com/38920671/143469009-54c5c693-5b38-4a6b-a8f3-5d685bb9df7e.png)

The testbench to test the entire system used a clock set at 100 MHz (a clock period of 10 ns). The system uses an active low reset pin. The system is initialized by holding the reset pin low for 5 clock cycles to ensure all registers get reset. Machine code programmed using the legend in the above instruction set is written to the RAM starting from address 0.

The processor was first tested by reading numbers from memory, adding and subtracting and verifying the correct result was seen on the accumulator output. The address mux first selects the PC register with initial value 0. The data at RAM address 0 is read and the instruction (INPUT) is stored in the IR. On the decode phase the decoder identifies the instruction as INPUT and the control logic is configured to read the address stored in the lower byte of the input instruction (address 6). The data stored at address 6 (100) is then loaded and the PC increments to address 2. The instruction to ADD 10 is fetched, decoded and executed and the output of the accumulator (ACC_Q) changes to 0110 1110 (110 in decimal, the correct result). This result gets stored in memory address 7. The number 255 (1111 1111) is then loaded into the data mux and 2 is subtracted from it to give the result 1111 1101 as seen on ACC_Q at the 300 ns mark. The waveforms showing this process are seen in the following figure.

![image](https://user-images.githubusercontent.com/38920671/143469170-89ef5192-0b53-43f7-80f9-4a9e026f3f55.png)

Having verified basic functionality of the processor, it was further tested using the complete instruction test set on simplecpudesign.com. It was found by inspecting the waveforms that the CPU gets stuck in the trap at 0x0E (this can be seen in the computer_tb.sv file). This means the CPU is not carrying out the jump if no zero instruction correctly which indicates one of three things: the ALU is returning a zero when it shouldn’t, the instruction decoder is not correctly interpreting the JUMP NZ instruction or the decoder SEL output bits are not configured correctly.

## Conclusion

The processor works correctly for basic arithmetic functions and can read and write to the memory on command. As even a simple 8 bit CPU is a complex electronic system, hierarchical design methodologies were used in this project to simplify the design and construction. Individually testing each module before full system integration allowed bugs to be caught and fixed early in the design process. Having a hierarchical design allowed easy assembly of the processor and memory system.
