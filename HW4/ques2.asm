;this script performs the modulo operation on two numbers N and K stored in registers R0 and R1. The result is stored in R2.
; Dividend = N = R0
; Divisior = k = R1

; The output (N Modulo K) is placed in register R2. 
; For example, if the inputs are Dividend = x000F (decimal 15) and Divisor= x0004 ( decimal 4) 
; The result in R2 is x0003 (since 15 Modulo 4 = 3).

; The “main” in your program will simply read the numbers N (Dividend) and K (the Divisor) from memory locations x3100 and x3101 respectively 
; and will then call the MODULO subroutine. It then stores the Result (N Modulo K) in memory location x3102.

.ORIG x3000 ; Start PC@ x3000

    ; load numbers into x3100 and 3101
    LD R2, sourceAddy
    LD R3,N
    STR R3, R2, #0
    LD R3, K
    STR R3, R2, #1
 
Main
    ;Read numbers from x3100 and 3101
    LD R2, sourceAddy
    LDR R0, R2, #0
    LDR R1, R2, #1
    
    ; Save the numbers at two predefined memory addresses saveR0 and saveR1

    ; Save R0
    LD R2, saveR0
    STR R0, R2, #0
    
    ; Save R1
    LD R2, saveR1
    STR R1, R2, #0
    
    JSR MODULO
    
    ; After calling Modulo replace the values of R0 and R1 with the saveR0 and saveR1 values stored in memory
    LD R0, result
    STR R2, R0, #0
    
    LD R2, saveR0
    LDR R0, R2, #0
    LD R2, saveR1
    LDR R1, R2, #0
    
    HALT ;
    

    
MODULO
; take the value in R0 
; copy the value in R1 to another register and 2's compliment it
    ADD R3, R1, #0
    NOT R3, R3
    ADD R3, R3, #1
    ; store the last result in R4 to save it
    ADD R4, R0, #0
; add R0 and R3 and store in R0 
    ADD R0, R0, R3
; if R0 is less than R3 then R2 will be negative and we return
    BRzp MODULO
    ADD R2, R4, #0
    RET



msg1    .STRINGZ "Starting Program "


N    .FILL #16
K    .FILL #4
result .FILL x3102

sourceAddy .FILL x3100
saveR0  .FILL x3103
saveR1  .FILL x3104

.END ; 
