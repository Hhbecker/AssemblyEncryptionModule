.ORIG x3000 ; Start PC@ x3000

 ; print "Starting Program" string 
    LEA R0, msg1    ; load prompt message into R0
    PUTS    ; calls system subroutine to print message stored in R0
    ; Starting Program
    
    ; load n1 and n2 into x4000 and x4001
    LD R0, sourceAddy
    LD R1, n1
    STR R1, R0, #0
    LD R1, n2
    STR R1, R0, #1
    
    PromptUser
    ; how to create a new line in output? 
    LEA R0, msg2    ; load prompt message into R0
    PUTS    ; calls system subroutine to print message stored in R0
    
    ; read the number from input
    IN
    
    ; check if A
    ADD R1, R0, #0  ; copy R0 to R1
    LD R2, A
    ADD R1, R1, R2
    BRz Adding    ; If last instruction is zero branch to ADDING
    
    ; check if S
    ADD R1, R0, #0  ; copy R0 to R1
    LD R2, S
    ADD R1, R1, R2
    BRz Subtracting    ; If last instruction is zero branch to ADDING
    
    ; check if M
    ADD R1, R0, #0  ; copy R0 to R1
    LD R2, M
    ADD R1, R1, R2
    BRz Multiplying    ; If last instruction is zero branch to ADDING
    
    ; check if X
    ADD R1, R0, #0  ; copy R0 to R1
    LD R2, X
    ADD R1, R1, R2
    BRz Halting    
    
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
       LD R2, sourceAddy
       LDR R3, R2, #0 ; number stored in x4000 loaded into R3
       LDR R4, R2, #1 ; number stored in x4001 loaded into R3
       AND R1, R1, #0   ; clear R1
LOOP2  ADD R1, R1, R4     ; Place the sum of Register 2 (num at 4001) and Register 4 into Register 4 (product)
       ADD R3, R3, #-1    ; Place the sum of Register 2 (i) and -1 in Register 2 (i) (decrement i)
       BRp LOOP2    ; If last instruction is positive branch to LOO
       STR R1, R2, #2
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
    
    
    
    