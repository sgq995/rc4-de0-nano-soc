# RC4 Cryptoprocessor: FPGA

## Directories
* hps: Contains the Quartus 16.1 project files, include the verilog implementation of RC4 algorithm and QSys design for the HPS. The mapped memory of RC4 is inside 0x00040000, the base memory address for FPGA components is 0xFF200000, so for access to RC4 module you need to manage 0xFF240000 address on the ARM Cortex A9 processor.
* verilog: Contains the verilog design of RC4 and old implementation that I made. When I made the avalon interface of the old RC4 design, I had a syncrhonization error with the processor, also had reset throuble because the system doesn't restart itself when debug another program in Altera Monitor.
