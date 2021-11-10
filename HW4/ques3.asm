; this program will implement the peek function in a stack and will also check for underflow 

.ORIG x3000 ; Start PC@ x3000

 LD R6, sourceAddy

PromptUser
    LEA R0, msg1    ; load prompt message into R0
    PUTS    ; calls system subroutine to print message stored in R0

    ; read the number from input
    IN
    
    ; check if 1
    ADD R1, R0, #0  ; copy R0 to R1
    LD R2, A
    ADD R1, R1, R2
    BRz Push    ; If last instruction is zero branch to ADDING
    
    ; check if 2
    ADD R1, R0, #0  ; copy R0 to R1
    LD R2, B
    ADD R1, R1, R2
    BRz Pop    ; If last instruction is zero branch to ADDING
    
    ; check if 3
    ADD R1, R0, #0  ; copy R0 to R1
    LD R2, C
    ADD R1, R1, R2
    BRz Peek    ; If last instruction is zero branch to ADDING
    
    ; check if X
    ADD R1, R0, #0  ; copy R0 to R1
    LD R2, X
    ADD R1, R1, R2
    BRz Halting    
    
    LEA R0, invalid    ; load prompt message into R0
    PUTS    ; calls system subroutine to print message stored in R0
    BRnzp PromptUser
    
    
    
Push
    ; read the number from input
    IN
    STR R0, R6, #0
    ADD R6, R6, #-1
    BRnzp PromptUser

Pop 
    LD R2, sourceAddy
    NOT R2, R2
    ADD R2, R2, #1
    ADD R2, R2, R6
    BRz Underflow 
    LDR R0, R6, #0
    ADD R6, R6, #1
    BRnzp PromptUser
    
Peek
    LD R2, sourceAddy
    NOT R2, R2
    ADD R2, R2, #1
    ADD R2, R2, R6
    
    BRz Underflow 
    LDR R0, R6, #0
    BRnzp PromptUser
       
Underflow
    LEA R0, msg2    ; load prompt message into R0
    PUTS    ; calls system subroutine to print message stored in R0
    BRnzp PromptUser
    
    
Halting 
    LEA R0, msgHalt    ; load prompt message into R0
    PUTS    ; calls system subroutine to print message stored in R0
    HALT
    

msg1    .STRINGZ "Enter 1 to Push, 2 to Pop, 3 to Peek, and X to halt  "
msg2    .STRINGZ "Underflow detected, cannot pop or peek  "

invalid    .STRINGZ "Invalid Operation – Re‐enter "
msgHalt   .STRINGZ "Exiting program "



A    .FILL #-49
B    .FILL #-50
C    .FILL #-51
X    .FILL #-88

sourceAddy .FILL x5000

.END ; 
    
    
    
    