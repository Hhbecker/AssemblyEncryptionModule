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
query       .STRINGZ "\nENTER E OR D OR X\n"
startmsg    .STRINGZ "\nSTARTING PRIVACY MODULE\n"
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
    ; write zero in all memory address x400 -x400F and x5000-x50009
    
    AND R2, R2 #0 ;initialize counter to i 
    
    Eloop1
    AND R0, R0, #0 ; initialize input as zero
    LD R1, msgAddy ; load x4000 into R1
    ADD R1, R1, R2 ; add offset to x4000
    STR R0, R1, #0 ; store zero at that address
    ADD R2, R2, #1 ; increment counter 
    ADD R3, R2, x-F
    BRn Eloop1
    
    AND R2, R2 #0 ;initialize counter to i 
    num2
    AND R0, R0, #0 ; initialize input as zero
    LD R1, decAddy ; load x4000 into R1
    ADD R1, R1, R2 ; add offset to x4000
    STR R0, R1, #0 ; store zero at that address
    ADD R2, R2, #1 ; increment counter 
    ADD R3, R2, x-F
    BRn num2
    
    
    
    
    HALT;
    
; If user selects E or D the program will print out the "enter key" msg, read in 5 characters, store them at x400B-x400F, and check if the key is valid
EorD
    LEA R0, keymsg    ; Load prompt message into R0
    PUTS
    
    JSR GetKey
    JSR CheckKey

    ; if key is valid branch to either E or D 
    ; if D decyrpt message already in memory and store it at x5000
    ; if E enter message and encrpyt it
    LD R1, msgAddy
    LDR R0, R1, xA ; R0 contains E or D 
    LD R1 E
    ADD R1, R1, R0
    BRn Decrypt
 
; prompt user for 10 character message 
; encrpyt the message 
; store in x4000-x4009 

    LEA R0, promptmsg    ; Load prompt message into R0
    PUTS
    ; last three of key stored as decimal in R6
    ; Read in and store 10 encrypted keyboard inputs
    ;store i variable of 10 in memory 
    
    AND R0, R0, #0
    LD R1, msgAddy
    STR R0, R1, #17
    
    MSGLoop
    GETC
    JSR Viginere
    JSR Caesar
    ;JSR Bitshift
    ; result of each cipher is now in R0, store this at memory address x4000
    LD R1, msgAddy ; load address x4000 into R1
    LDR R2, R1, #17 ; load loop counter (and offset) into R2
    ADD R1, R1, R2 ; add offset to address
    STR R0, R1, #0 ; store contents of R0 into x4000
    
    ADD R2, R2, #1 ; add one to counter and offset 
    ADD R3 R2, #-10 ; 
    BRz PromptUser ; if counter/offset - 9 = 0 then ten characters have been inputted so return to prompt user
    LD R1, msgAddy ; load address x4000 into R1
    STR R2, R1, #17
    BRnzp MSGLoop
    
    HALT;
; NORMAL FLOW ABOVE THIS LINE - FUNCTIONS BELOW
    
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
        AND R5, R5, #0 ; save R7 into R5
        ADD R5, R5, R7
        JSR CheckIfNonNumeric
        AND R7, R7, #0 ; load original R7 (return address) back into R7
        ADD R7, R5, R7

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
        
        ; at this point: first digit is num from 0-7, second digit is non numeric, third digit is either zero or one, fourth and fifth digits are numbers 
        
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
        LD R1, ten
        AND R5, R5, #0 ; save R7 into R5
        ADD R5, R5, R7
        JSR multiply ; multiply number in R0 by number in R1
        AND R7, R7, #0 ; load original R7 (return address) back into R7
        ADD R7, R5, R7
        ADD R4, R4, R3 ; add tens place to result 
        ;load ones place and add it to R4
        LD R1, msgAddy
        LDR R0, R1, xF ; R0 contains number input by user
        LD R1, zero ; load -48 into R1
        ADD R0, R0, R1 ; convert ascii ones place digit to decimal by subtracting 48
        ADD R4, R4, R0 ; This is the final number in decimal (in R4)
        AND R6, R6, #0 ; clear R6
        ADD R6, R6, R4 ; copy final number into R6
        ; we know the number is not less than zero so all we need to do is check if its greater than 127 
        ; number -127 will be positive if its greater than 127
        LD R0, keyUpperBound
        ADD R4, R4, R0
        BRp Inv
        
        RET ; 
        

    
Caesar ; N = 128 = R3, k = 3 digit number from key = R6, m = message char = R0, result = (m + k) mod N
       LD R1, N
       ADD R0, R0, R6 ; Add (m + k) store in R2
       ; compute R0 modulo R1 
       AND R5, R5, #0 ; save R7 into R5
       ADD R5, R5, R7
       JSR MODULO
       AND R7, R7, #0 ; load original R7 (return address) back into R7
       ADD R7, R5, R7
       
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
    ; perform XOR on char stored in R0 and contents of memory address of 2nd key bit to char 
    ; R0 = input 0
    ; R1 = input 1
    ; R2 = result
    
    LD R3, msgAddy
    LDR R1, R3, xC
    LD R5, zero
    ADD R5, R5, R1
    BRz NoVig ; if key value is zero we need to bypass the viginere function 
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
    NoVig
    RET; returns result in R0

Decrypt
    ; confirm it is looping the way you want
    ;confirm it is decrpyting the way you want 
    ; first we undo Casear by doing result - K mod 128
    ;store 0 in offset 17 as loop counter
    AND R0, R0, #0
    LD R1, msgAddy
    STR R0, R1, #17
    
    DecLoop
    ; result of each decryption is now in R0, store this at memory address x5000
    LD R1, msgAddy ; load address x4000 into R1
    LDR R2, R1, #17 ; load loop counter (and offset) into R2
    ADD R1, R1, R2 ; add offset to address
    LDR R0, R1, #0 ; load contents of address into R0
    AND R3, R3, #0 
    ADD R3, R6, R3 ; copy k into R3 
    NOT R3, R3 ; 2's comp it
    ADD R3, R3, #1
    ADD R0, R0, R3 ; subtract message char - k 
    LD R1, N
    JSR MODULO ; returns result of viginere in R0 
    JSR viginere ; returns input of viginere in R0
    LD R1, msgAddy ; load address x4000 into R1
    LDR R2, R1, #17 ; load loop counter (and offset) into R2
    LD R1, decAddy ; load 5000 address into R1
    ADD R1, R1, R2 ; Add offset to address
    STR R0, R1, #0 ; store decrypted message in adddress
    ADD R3, R2, #-10
    BRz PromptUser
    ADD R2, R2, #1 ; increment counter
    LD R1, msgAddy ; load address x4000 into R1
    STR R2, R1, #17
    BRnzp DecLoop
    
    
GetKey
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
    RET

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
       ADD R0, R0, R3   ; if the sum of this addition is zero it means R0 is zero meaning we're about to multiply by zero
       BRz prodZero
       ADD R1, R1, R3
       BRz prodZero
LOOP  ADD R3, R1, R3     ; Repeatedly add Register 1 into Register 3 (product)
       ADD R0, R0, #-1    ; Decrement i
       BRp LOOP    ; If last instruction is positive (i has not reached zero) branch to LOOP2
       RET
       
prodZero
    RET ; go back to pc stored in R7
    
halt;
msgAddy .FILL x4000
decAddy .FILL x5000
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
ten .FILL #10
a    .FILL #5
b    .FILL #6
invalid     .STRINGZ "\nINVALID INPUT\n"
keymsg      .STRINGZ "\nENTER KEY\n"
promptmsg   .STRINGZ "\nENTER MESSAGE\n"





.END ; 



    
    
    
    