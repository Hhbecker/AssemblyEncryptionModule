; This program performs either addition, subtraction, or multiplication of two numbers based on user input
; Author: Henry Becker 

.ORIG x3000 ; Start PC@ x3000

 ; Print "Starting Program" string 
    LEA R0, msg1    ; Load prompt message into R0
    PUTS    ; Calls system subroutine to print message stored in R0
    ; Starting Program
    
    ; Load n1 and n2 into x4000 and x4001
    LD R0, sourceAddy ; Load 4000 into R0
    LD R1, n1 ; Load the desired first number into R1
    STR R1, R0, #0 ;Store the desired first number at address specified by R0 with offset 0
    LD R1, n2 
    STR R1, R0, #1
    
    PromptUser ; This is the label each subroutine will return to 
    LEA R0, msg2    ; Load prompt message into R0
    PUTS    ; Calls system subroutine to print message stored in R0
    
    ; Read the number from input
    IN
    
    ; check if A
    ADD R1, R0, #0  ; copy R0 to R1
    LD R2, A ; Load ASCII number for capital A into R2
    ADD R1, R1, R2  ; store the result of addition of input number and ascii A in R1
    BRz Adding    ; If last instruction is zero the input was in fact A so branch to Adding
    
    ; check if S
    ADD R1, R0, #0  ; copy R0 to R1
    LD R2, S
    ADD R1, R1, R2
    BRz Subtracting    ; If last instruction is zero branch to Subtracting
    
    ; check if M
    ADD R1, R0, #0  ; copy R0 to R1
    LD R2, M
    ADD R1, R1, R2
    BRz Multiplying    ; If last instruction is zero branch to Multiplying
    
    ; check if X
    ADD R1, R0, #0  ; copy R0 to R1
    LD R2, X
    ADD R1, R1, R2
    BRz Halting    
    
    ; if you get to here input was not A,S,M, or X
    
    LEA R0, invalid    ; load prompt message into R0
    PUTS    ; calls system subroutine to print message stored in R0
    BRnzp PromptUser
    
    
    
Adding
    LD R2, sourceAddy
    LDR R3, R2, #0 ; number stored in x4000 loaded into R3
    LDR R4, R2, #1 ; number stored in x4001 loaded into R4
    ADD R3, R3, R4
    STR R3, R2, #2
    BRnzp PromptUser

Subtracting ; 4000 + - 40001
    LD R2, sourceAddy
    LDR R3, R2, #0 ; number stored in x4000 loaded into R3
    LDR R4, R2, #1 ; number stored in x4001 loaded into R3
    NOT R4, R4
    ADD R4, R4, #1
    ADD R3, R3, R4
    STR R3, R2, #2
    BRnzp PromptUser
    
Multiplying
       LD R2, sourceAddy ; Load address x4000 into R2
       LDR R3, R2, #0 ; number stored in x4000 loaded into R3
       LDR R4, R2, #1 ; number stored in x4001 loaded into R4
       AND R1, R1, #0   ; clear R1
LOOP2  ADD R1, R1, R4     ; Repeatedly add Register 4 into Register 1 (product)
       ADD R3, R3, #-1    ; Decrement i
       BRp LOOP2    ; If last instruction is positive (i has not reached zero) branch to LOOP2
       STR R1, R2, #2 ; If last instruction was no positive then i is zero, the multiplication is complete, and the result can be stored in address R2 + offset 2
       BRnzp PromptUser
    
Halting 
    LEA R0, msgHalt    ; load prompt message into R0
    PUTS    ; calls system subroutine to print message stored in R0
    HALT
    
    

msg1    .STRINGZ "Starting Program "
msg2    .STRINGZ "Enter operation A, S, M or X "
invalid    .STRINGZ "Invalid Operation – Re‐enter "
msgHalt   .STRINGZ "Exiting program "



A    .FILL #-65
S    .FILL #-83
M    .FILL #-77
X    .FILL #-88

sourceAddy .FILL x4000

n1   .FILL #6
n2   .FILL #5

.END ; 
    
    
    
    