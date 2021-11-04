.ORIG x3000 ; Start PC@ x3000

 ; print "Starting Program" string 
 
    LEA R0, msg1    ; load prompt message into R0
    PUTS    ; calls system subroutine to print message stored in R0
    ; Starting Program
    
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
    
    
    HALT ; 

    
Adding
    LEA R0, msgAdd    ; load prompt message into R0
    PUTS    ; calls system subroutine to print message stored in R0
    JSR PromptUser


Subtracting
    LEA R0, msgSubtract    ; load prompt message into R0
    PUTS    ; calls system subroutine to print message stored in R0
    RET
    
Multiplying
    LEA R0, msgMultiply    ; load prompt message into R0
    PUTS    ; calls system subroutine to print message stored in R0
    RET

    
    
    

msg1    .STRINGZ "Starting Program "
msg2    .STRINGZ "Enter operation A, S, M or X"
msgAdd    .STRINGZ "Adding"
msgSubtract    .STRINGZ "Subtracting"
msgMultiply .STRINGZ "Multiplying"

A    .FILL #-65
S    .FILL #-83
M    .FILL #-77

.END ; 
    
    
    
    
    

