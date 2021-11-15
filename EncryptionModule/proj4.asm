; Encryption Module
; Author: Henry Becker 

;x4000 encrypted message char 1
;x4001 encrypted message char 2
;x4002 encrypted message char 3
;etc
;x400A = input (E, D, or X)
;x400B = bit shift
;x400C = viginere 
;x400D = Caesar1
;x400E = Caesar2
;x400F = Caesar3

;x5000 decrypted message char 1
;x5001 decrypted message char 2
;x5002 decrypted message char 3

; etc 




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
    GETC
    LD R1, msgAddy
    STR R0, R1, xB
    GETC
    LD R1, msgAddy
    STR R0, R1, xC
    GETC
    LD R1, msgAddy
    STR R0, R1, xD
    GETC
    LD R1, msgAddy
    STR R0, R1, xE
    GETC
    LD R1, msgAddy
    STR R0, R1, xF
    
    JSR CheckKey
    
    ; if key is invalid loop back to EorD
    
CheckKey
    ; xB must be single digit number less than 8 (ascii 48-55 inclusive)
        ; if xB is less than 0 its invalid 
        LD R1, msgAddy
        LDR R0, R1, xB
        LD R2, zero
        ADD R2, R0, R2
        BRn Inv
        
        ; if xB is greater than 7 its invalid 
        LD R2, seven
        ADD R2, R0, R2
        BRp Inv
        
        ; if xC is a number its invalid 
        JSR CheckIfNonNumeric

        ; xD, xE, xF must be 3 digit number betweeen 0 and 127
        
        LD R1, msgAddy
        LDR R0, R1, xD
        
        ; xD must be 0 or 1 (if less than zero branch)
        LD R2, zero
        ADD R2, R0, R2
        BRn Inv
        
        ; xD must be 0 or 1 (if greater than 1 branch)
        LD R2, zero
        ADD R2, R2, #-1
        ADD R2, R0, R2
        BRp Inv
        
        ; xE must be numeric 
        LD R1, msgAddy
        LDR R0, R1, xE

        LD R2, zero
        ADD R2, R0, R2
        BRn Inv
        
        LD R2, numericUpperBound
        ADD R2, R0, R2
        BRp Inv
        
        
        ; xF must be numeric 
        LD R1, msgAddy
        LDR R0, R1, xE

        LD R2, zero
        ADD R2, R0, R2
        BRn Inv
        
        LD R2, numericUpperBound
        ADD R2, R0, R2
        BRp Inv
        
        ; at this point:
        ; first digit is num from 0-7 
        ; second digit is non numeric
        ; third digit is either zero or one
        ; fourth and fifth digits are numbers 
        
        ; load the first number convert it to decimal and if its 0 clear R4 if its 1 LD 100 into R4 
        LD R1, msgAddy
        LDR R0, R1, xD ; R0 contains number input by user
        LD R2, zero ; R2 contains negative ascii for 0
        ADD R0, R2, R0 ; if this sum has a positive result it means the number is 1 not 0 so add 100
        BRp AddHundo
        AND R4, R4, #0 ; if number is zero clear R4
afterHundo
        LD R1, msgAddy
        LDR R0, R1, xE ; R0 contains number input by user
        LD R2, zero ; R2 contains negative ascii for 0
        ADD R0, R2, R0 ; this sum is the actual decimal of the number input by user
        ; multiply this number by 10 and add it to R4 
        LD R1, #10
        JSR multiply ; multiply number in R0 by number in R1?
        ADD R4, R4, R3 ; add tens place to result 
        ;load ones place and add it to R4
        LD R1, msgAddy
        LDR R0, R1, xF ; R0 contains number input by user
        ADD R4, R4, R0 ; This is the final number in decimal (in R4)
        AND R6, R6, #0 ; clear R6
        ADD R6, R6, R4 ; copy final number into R6
        ; we know the number is not less than zero so all we need to do is check if its greater than 127 
        ; number -127 will be positive if its greater than 127
        LD R0, keyUpperBound
        ADD R4, R4, R0
        BRp Inv
    ;
    ;
    ; AT THIS POINT THE KEY MUST BE VALID
    ; If the input was E BR to Encrypt 
    ; If the input was D BR to Decrypt
    
        JSR Encrypt
    ;
Encrypt
; prompt user for 10 character message 
; encrpyt the message 
; store in x4000-x4009 

    LEA R0, promptmsg    ; Load prompt message into R0
    PUTS
    
    ; last three of key stored as decimal in R6
    
    ; Read in and store 10 encrypted keyboard inputs
    GETC
    JSR Viginere
    JSR Caesar
    ;JSR Bitshift
    ; result of each cipher is now in R0, store this at memory address x4000
    LD R1, msgAddy ; load address x4000 into R1
    STR R0, R1, #0 ; store contents of R0 into x4000
    
   ; GETC
   ; JSR Viginere
   ; JSR Caesar
   ; ;JSR Bitshift
   ;; result of each cipher is now in R0, store this at memory address x4000
   ; LD R1, msgAddy ; load address x4000 into R1
   ; STR R0, R1, #1 ; store contents of R0 into x4001
    
    


    
Bitshift
    ;DOI NEED TO CONVERT THE KEY TO A DECIMAL NUMBER OR DO I LEAVE IT IN ASCII? I THINK CONVERT TO DECIMAL
    ; R0 contains msg char
    ; convert key value from ascii to decimal 
    ; multiply key value by by 
    ;multiply by adding R1 into R3 R0 times
    ; First: compute 2^Key value 
    ; Second: multiply that by msg char
    
       LD R1, msgAddy
       LDR R2, R1, xB ; first Key value now loaded into R2
       AND R3, R3, #0   ; clear R3 to store product
LOOP1   ADD R3, R3, #2     ; Repeatedly add Register 1 into Register 3 (product)
       ADD R2, R2, #-1    ; Decrement i
       BRp LOOP1    ; If last instruction is positive (i has not reached zero) branch to LOOP2
       ;at this point we've computed 2^key
       ; R3 times R0 should give us the bit shift we want 
       RET
       
Caesar ; N = 128 = R3
       ; k = 3 digit number from key = R6
       ; m = message char = R0
       ; result = (m + k) mod N
       LD R1, N
       ADD R0, R0, R6 ; Add (m + k) store in R2
       ; compute R0 modulo R1 
       JSR MODULO
       
MODULO
; take the value in R0 (result from viginere cipher)
; copy the value in R1 (128) to another register and 2's compliment it
    AND R3, R3, #0
    ADD R3, R1, #0
    NOT R3, R3
    ADD R3, R3, #1
    ; store the last result in R4 to save it
    ADD R4, R0, #0
; add R0 and R3 and store in R0 
    ADD R0, R0, R3
; if R0 is less than R3 then R2 will be negative and we return result in R2
    BRzp MODULO
    ADD R2, R4, #0
    AND R0, R0, #0 ; clear R0 
    ADD R0, R2, R0 ; copy result from R2 into R0
    RET ;return result in R0
       
    
Viginere ; this method performs input char XOR K where K is the char of the key 

    ; KEY VALUE NOT LOADED YET
    ; perform XOR on char stored in R0 and contents of memory address of 2nd key bit to char 
    ; R0 = input 0
    ; R1 = input 1
    ; R2 = result
    
    LD R3, msgAddy
    LDR R1, R3, xC
    AND R3, R3, #0 ; clear R3 to store result of XOR

    ; Bitwise XOR
    AND R2, R0, R1    ; and input 1&2 and put it in var3 
    NOT R2, R2; not it 
    NOT R0, R0, ; not array in with itself 
    NOT R1, R1     ; not temp in with itself 
    AND R1, R0, R1    ; and the temp in and array in 
    NOT R1, R1 ; not the temp in and array in 
    AND  R2, R1, R2 ; final and 
    AND R0, R0, #0
    ADD R0, R0, R2 ; copy result from R2 to R0
    RET; returns result in R0


Decrypt

    
    
    
checkIfNonNumeric
        ; if -58 + xC is negative (xC is less than 58) branch to check 
        LD R1, msgAddy
        LDR R0, R1, xC
        LD R2, numericUpperBound
        ADD R2, R0, R2
        BRn checkFurther
        RET
    checkFurther
    ; if xC is greater than 48 its invalid
        LD R2, zero
        ADD R2, R0, R2
        BRp Inv
        RET
        
AddHundo
    LD R4, hundred
    BRnzp afterHundo



Inv
    LEA R0, invalid    ; Load prompt message into R0
    PUTS
    BRnzp EorD
    
Multiply ; adds R1 into R3 R0 times
       AND R3, R3, #0   ; clear R3 to store product
       ADD R0, R0, R3
       BRz prodZero
       ADD R1, R1, R3
       BRz prodZero
LOOP  ADD R3, R1, R3     ; Repeatedly add Register 1 into Register 3 (product)
       ADD R0, R0, #-1    ; Decrement i
       BRp LOOP    ; If last instruction is positive (i has not reached zero) branch to LOOP2
       RET
       
prodZero
    RET ; go back to pc stored in R7
    
    
    
    
    
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
zero    .FILL #-48
seven   .FILL #-55
numericUpperBound .FILL #-58
hundred .FILL #100

keyLowerBound .FILL #-27
keyUpperBound .FILL #-127
N .FILL #128

msgAddy .FILL x4000


a    .FILL #5
b    .FILL #6


.END ; 
    
    
    
    