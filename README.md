# **RISCV_and_HWAcc**

This repository has RTL code for a dual-core RISCV processor (Only implemented the required instructions) and custom HWAcc which we used for Encryption/Decryption. 
The name of our project is SASI (Simple Acceleratet Security for IOTs). 
RISCV processors are used to perform Encryption/Decryption as a Network processor. The configuration of the processor is as follows:
 -- Dual Core. 
 -- 4-way Simultaneous Multithreaded.
 -- Basic Instruction Support (Branch, Jump, R-type, I-type)

Hardware Accelerator is alongside the Processor and performs the Encryption/Decryption on the fly (at the line rate of 1000Mbps).
You can switch between the HW accelerator and Processor by modifying particular Registers.
The device has been tested on NetFPGA setup.

**Directory Structure:**
sim -- this directory is for simulation. All the memories are available in Verilog only format in this directory.

src -- this contains RTL files. Do not add simulation-only files (like testbench and simulation memories) to src folder.

synth -- this directory has .xco files which we will use in our synthesis.
