# Encryption Module
This repository contains an encryption module written in the LC3 assembly language. The project specifications called for a variation of an ARX (Add - Rotate - XOR) block cipher. This program uses a combination of a Caesar cipher, bitwise shift, and XOR cipher.

# The LC3 Assembly Language
The LC-3 (Little Computer 3) is a software tool that simulates a 16 bit instruction set architecture. 

The LC-3 includes: 
* eight 16 bit registers 
* physical I/O via keyboard and monitor
* TRAPs to the operating system for handling service calls
* conditional branches on (N, Z, and P) condition codes
* a subroutine call/return mechanism
* a minimal set of operate instructions (ADD, AND, and NOT
* various addressing modes for loads and stores (direct, indirect, Base+offset)

I used the LC-3 tools simulator in conjunction with the textbook: Introduction to Computing Systems - from bits & gates to C/C++ & beyond by Yale N. Patt and Sanjay J. Patel textbook as part of the Computer Architecture course CS2461 at George Washington University (Fall 2021).

Downlaod the simulator here: [chiragsakhuja/lc3tools](https://github.com/chiragsakhuja/lc3tools)

//////////////////////////

## Challenges 
The main challenges arose from the simplicity of the LC3 language. Because there are only eight available registers to store operable data, code commenting is essential to keep track of the information stored in a given register at any given time. 
* Maintaining a logical control flow using JSR and BRnzp 
* creating our own implementation of each cipher 
* creating our own implementation to reverse each cipher 
* storing keys in memory 
* developing rigourous test cases

* manipulating registers 
* specifiying specific addresses and offsets of load and store operations 


## Problems I encountered:
-labels had to be within 256 lines of label call (LD, LEA etc) WHY IS THIS?
-the way branches work it’s hard to keep code neat 












