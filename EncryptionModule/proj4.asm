; Encryption Module
; Author: Henry Becker 

.ORIG x3000 ; Start Program Counter @ x3000

    ; Print start message 
    LEA R0, startmsg    ; Load prompt message into R0
    PUTS    ; Calls system subroutine to print message stored in R0

    
    PromptUser ; This is the label the invalid input case will return to 
    LEA R0, query    ; Load prompt message into R0
    PUTS    ; Calls system subroutine to print message stored in R0


    ; load and save E D or X char in memory @ x400A
    GETC
    LD R1, msgAddy
    STR R0, R1, xA
    
    
    ;Check if E
    ADD R1, R0, #0  ; copy R0 to R1
    LD R2, E ; Load ASCII number for capital A into R2
    ADD R1, R1, R2  ; store the result of addition of input number and ascii A in R1
    BRz EorD    ; If last instruction is zero the input was in fact A so branch to Adding
    
    ; Check if D
    ADD R1, R0, #0  ; copy R0 to R1
    LD R2, D
    ADD R1, R1, R2
    BRz EorD    ; If last instruction is zero branch to Subtracting
    
    ; Check if X
    ADD R1, R0, #0  ; copy R0 to R1
    LD R2, X
    ADD R1, R1, R2
    BRz Erase   
    
    ; if you get to here input was not E, D, or X
    ; prompt user again
    
    LEA R0, invalid    ; load prompt message into R0
    PUTS    ; calls system subroutine to print message stored in R0
    BRnzp PromptUser
    

; If user selects "X" erase all data from memory and registers and halt program
Erase
    HALT;
    
; If user selects E or D the program will print out the "enter key" msg, read in 5 characters, store them at x400B-x400F, and check if the key is valid
EorD
    LEA R0, keymsg    ; Load prompt message into R0
    PUTS
    ; Read in and store 5 keyboard inputs
    
    ; must be single digit number less than 8 (ascii 48-55 inclusive)
    GETC
    LD R1, msgAddy
    STR R0, R1, xB
    
    ; must be non numeric character or zero ( ascii 33-126 excluding 49-57 inclusive)
    GETC
    LD R1, msgAddy
    STR R0, R1, xC
    
    ; 3 digit number betweeen 0 and 127
    ; must be 0 or 1
    GETC
    LD R1, msgAddy
    STR R0, R1, xD
    
    ; must be number ( ascii 48-57 inclusive)
    GETC
    LD R1, msgAddy
    STR R0, R1, xE
    
    ; must be number ( ascii 48-57 inclusive)
    GETC
    LD R1, msgAddy
    STR R0, R1, xF
    
    JSR CheckKey
    
    ; if key is invalid loop back to EorD
    
CheckKey
    LD R1, msgAddy
        LDR R0, R1, xB
    
    
    
    
    
; Messages 
startmsg    .STRINGZ "\nSTARTING PRIVACY MODULE\n"
query       .STRINGZ "\nENTER E OR D OR X\n"
keymsg      .STRINGZ "\nENTER KEY\n"
promptmsg   .STRINGZ "\nENTER MESSAGE\n"
invalid     .STRINGZ "\nINVALID INPUT\n"

; Predefined variables 
E    .FILL #-69
D    .FILL #-68
X    .FILL #-88

msgAddy .FILL x4000


.END ; 
    
    
    
    