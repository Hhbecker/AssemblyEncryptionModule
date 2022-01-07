# LC3AssemblyProgramming
This repository contains my programming work in the LC3 Assembly language. The LC-3 (Little Computer 3) is a software tool that simulates a 16 bit instruction set architecture. 

Downlaod the simulator here: [chiragsakhuja/lc3tools](https://github.com/chiragsakhuja/lc3tools)

The LC-3 includes: 
* physical I/O via keyboard and monitor
* TRAPs to the operating system for handling service calls
* conditional branches on (N, Z, and P) condition codes
* a subroutine call/return mechanism
* a minimal set of operate instructions (ADD, AND, and NOT
* various addressing modes for loads and stores (direct, indirect, Base+offset)

I used the LC-3 tools simulator in conjunction with the textbook: Introduction to Computing Systems - from bits & gates to C/C++ & beyond by Yale N. Patt and Sanjay J. Patel textbook as part of the Computer Architecture course CS2461 at George Washington University (Fall 2021).

 

//////////////////////////
Encryption module


To Do:
* seperate LC3 HW and encryption module repos 




Started with a long document of specifications and we had to create the cipher and we had to come up with our own ways of implementing each component of the cipher in assembly. 
-managing register space because there are only seven available registers
-how to store keys in memory 
-keyboard inputs are stored in ascii and we had to check key validity based on specs
-had to develop our own ways to perform the three ciphers 
-had to develop our own ways to reverse the ciphers 

Talk about each encryption at the bit level

Problems I encountered:
-labels had to be within 256 lines of label call (LD, LEA etc)
-the way branches work it’s hard to keep code neat 

On resume: created an encryption module that performs a caser cipher and viginere cipher encryption as well as decryption in assembly. 

Find a test case that works and take pictures of it and don’t ever open it again. 

Talk about OTP encryption as impossible to break
https://www.google.com/search?q=one+time+pad+(OTP)+encryption&oq=one+time+pad+(OTP)+encryption&aqs=chrome..69i57j0i22i30j0i390.294j0j7&sourceid=chrome&ie=UTF-8

Encryption module -iCloud Keychain is protected by 256-bit AES encryption to store and transmit passwords and credit card information, and also uses elliptic curve asymmetric cryptography and key wrapping – a method of security that ensures all data synced between devices is kept safe.