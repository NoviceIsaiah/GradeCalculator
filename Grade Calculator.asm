;CIS11
;Isaiah Lopez
;Final Project
;Grade Calculator
;Desc: The user inputs a set of 5 numerical values/integers (0-100) to
;be calculate the max. score, min. score, and average score along with
;letter-equivalent scores to be displayed.  
;
; Inputs: 
; Outputs: 
; Run:  Assemble the program
;	Open the Simulate Software
;	Load the Assembled program(.obj file)
;	Run program
;	Input 5 integer values (0-100)
;	Read display for results

;Program Execution====================================================================

.ORIG x3000

LEA R0, startPrompt	;Loads starting prompt to user
PUTS			;Displays prompt
LD R6, stackBase	;Load stackBase onto R6

;Gets value and validates it
GETVALUES
GETC			;Get next character
OUT			;Echo character on display
AND R1, R1, #0		;Clear R1
ADD R1, R0, #0		;Copy R0 to R1
ADD R1, R1, #-10	;Check if input was a newline
BRz FINISHED		;If newline then input is finished

;Input validation, checks if greater than 0-9 ASCII
AND R1, R1, #0		;Clear R1
ADD R1, R0, #0		;Copy R0 to R1
LD R2, NEG39
ADD R1, R1, R2		;Check if input is greater than 0-9
BRp INVALID		;If so, go to invalid subroutine else continue

;Input validation, checks if less than 0-9 ASCII
AND R1, R1, #0		;Clear R1
ADD R1, R0, #0		;Copy R0 to R1
LD R2, NEG30		;R2 = -30
ADD R1, R1, R2		;Check if input is less than 0-9 
BRn INVALID		;If so, go to invalid subroutine else continue

;Push the inputted number 0-9 on the stack
JSR PUSH		;Else push number onto stack
AND R1, R1, #0		;Clear R1
AND R2, R2, #0		;Clear R2
ADD R3, R3, #-1		;Adds one to counter
LD R2, MAXCOUNT		;Loads max number count (3) since values can't go past 100
ADD R2, R2, R3		;Subtract counter from maxcount		 
BRnz FINISHED		;Once 3 numbers 0-9 are inputted, grade value is inputed
BR GETVALUES

;Validate number is 0-100
FINISHED	
JSR FINDSIZE 		;Find stack size
JSR CHECKDIGITS 	;Use stack size to find how many digits are in inputted value

AND R2, R2, #0		;Clear registers used in last subroutine
AND R3, R3, #0		;Clear R3
AND R4, R4, #0		;Clear R4
AND R5, R5, #0		;Clear R5

JSR GETDEC		;Get the decimal equvialent and validate 0-100
LDI R2, decValue	;Load current decimal value on R2
LD  R3, NEG100		;Load -100 on R3
ADD R2, R2, R3		;R2 = R2-100 
BRp OUTOFRANGE		;Checks if greater than 100 if so then input again

AND R2, R2, #0
STI R2, oneDigit
STI R2, twoDigit
STI R2, thrDigit

LDI R2, inpCount
ADD R2, R2, #1
STI R2, inpCount

AND R3, R3, #0
ADD R3, R3, #5

LDI R2, inpCount
NOT R2, R2
ADD R2, R2, #1

ADD R3, R3, R2
BRp GETVALUES

HALT


;SUBROUTINES=================================================================
FINDSIZE
AND R1, R1, #0		;Clear R1
AND R2, R2, #0		;Clear R2
AND R3, R3, #0		;Clear R3
ADD R1, R6, #0		;Copy R6 (current pointer) to R1
LD R2, stackBase	;Load stack base into R2
NOT R2, R2		;
ADD R2, R2, #1		;Two's complement of R2
ADD R1, R1, R2		;Subrtract stackBase from pointer to get stack size
RET

;---------------------------------------------------------------------------

CHECKDIGITS
;Check for one digit first
ADD R3, R1, #0		;Copy R1 (stack size) to R3
AND R2, R2, #0		;Clear R2
ADD R2, R2, #-1		;Load -1 onto R2 for subtraction
ADD R3, R3, R2		;Subtract 1 from stack size
BRz ONEDIGIT 		;Check if number has one digit

;Check for two digits
AND R2, R2, #0		;Clear R2
AND R3, R3, #0		;Clear R3
ADD R3, R1, #0		;Copy R1 (stack size) to R3
ADD R2, R2, #-2		;Load -2 onto R2 for subtraction
ADD R3, R3, R2		;Subtract 2 from stack size
BRz TWODIGIT		;Check if number has two digits

;Check for three digits
AND R2, R2, #0		;Clear R2
AND R3, R3, #0		;Clear R3
ADD R3, R1, #0		;Copy R1 (stack size) to R3
ADD R2, R2, #-3		;Load -3 onto R2 for subtraction
ADD R3, R3, R2		;Subtract 3 from stack size
BRz THREEDIGIT		;Check if number has three digits

ONEDIGIT
LD R2, NEG30		;Load -30 in hex for subtraction
LDR R3, R6, #0		;Load value at pointer address
ADD R3, R3, R2		;Subtract 30 from said value to convert from ASCII
STI R3, oneDigit		;Store the value at oneDigit address
RET

TWODIGIT
LD R2, NEG30		;Load -30 in hex for subtraction
LDR R3, R6, #0		;Load value at pointer address
ADD R3, R3, R2		;Subtract 30 from said value to convert from ASCII
STI R3, oneDigit		;Store the value at oneDigit address
LDR R3, R6, #-1		;Load value at address before pointer
ADD R3, R3, R2		;Subtract 30 form said value to conver from ASCII
AND R4, R4, #0		;Clear R4
ADD R4, R4, #10		;R4 = 10

AND R0, R0, #0		;Clear R0
ADD R0, R0, #-1         ;Push stack to save R7
STR R7, R0, #0		;Store R7 return address 
JSR MULTIPLY		;Multiply subroutine
STI R5, twoDigit	;Store product in R5
LDR R7, R0, #0		;Load return address
ADD R0, R0, #1		;Pop stack for R7
RET			;Return

THREEDIGIT
LD R2, NEG30		;Load -30 in hex for subtraction
LDR R3, R6, #0		;Load value at pointer address
ADD R3, R3, R2		;Subtract 30 from said value to convert from ASCII
STI R3, oneDigit	;Store the value at oneDigit address

LDR R3, R6, #-1		;Load value at address before pointer
ADD R3, R3, R2		;Subtract 30 form said value to conver from ASCII
AND R4, R4, #0		;Clear R4
ADD R4, R4, #10		;R4 = 10

AND R0, R0, #0		;Clear R0
ADD R0, R0, #-1         ;Push stack to save R7
STR R7, R0, #0		;Store R7 return address 
JSR MULTIPLY		;Multiply subroutine
STI R5, twoDigit	;Store product in R5
AND R5, R5, #0
LDR R7, R0, #0		;Load return address
ADD R0, R0, #1		;Pop stack for R7

LDR R3, R6, #-2
ADD R3, R3, R2
LD  R4, HUNDRED 

AND R0, R0, #0		;Clear R0
ADD R0, R0, #-1         ;Push stack to save R7
STR R7, R0, #0		;Store R7 return address 
JSR MULTIPLY		;Multiply subroutine
STI R5, thrDigit	;Store product in R5
LDR R7, R0, #0		;Load return address
ADD R0, R0, #1		;Pop stack for R7
RET			;Return

;-----------------

GETDEC
LDI R1, oneDigit
ADD R2, R2, R1
LDI R1, twoDigit
ADD R2, R2, R1
LDI R1, thrDigit
ADD R2, R2, R1
STI R2, decValue
RET

;-----------------

PUSH
ADD R6, R6, #1
STR R0, R6, #0
RET

;-----------------

POP 
LDR R0, R6, #0
ADD R6, R6, #-1
RET

;-----------------

INVALID
AND R3, R3, #0
LD R0, NEWLINE
OUT
LEA R0, invalidPrompt
PUTS
BR GETVALUES

;-----------------

OUTOFRANGE
AND R1, R1, #0
AND R2, R2, #0
AND R3, R3, #0
STI R3, decValue
STI R3, oneDigit
STI R3, twoDigit
STI R3, thrDigit
LD R0, NEWLINE
OUT
LEA R0, rangePrompt
PUTS

ADD R1, R6, #0 		;Copy pointer (R6) to R1
LD  R2, stackBase	;Copy stack base onto R2
NOT R2, R2
ADD R2, R2, #1
ADD R1, R1, R2		;Get stack size
BRp CONT
BR GETVALUES

CONT
JSR POP
ADD R1, R1, #-1
BRp CONT
BR GETVALUES

;-----------------

MULTIPLY
ADD R4, R4, #0
BRz SETZERO
MULTLOOP
ADD R5, R5, R3
ADD R4, R4, #-1
BRp MULTLOOP
RET

SETZERO 
AND R3, R3, #0
RET

;Address locations==============================================================
stackBase	.FILL x3200
minValue	.FILL x3205 
maxValue	.FILL x3206
avgValue	.FILL x3207
oneDigit	.FILL x3208
twoDigit	.FILL x3209
thrDigit	.FILL x320A
decValue	.FILL x320B
inpCount	.FILL x320C

;Filled values==================================================================
HUNDRED		.FILL x0064	;100 hex
NEG100		.FILL xFF9C 	;Negative 100 hex
NEG39 		.FILL xFFC7	;Negative 39 hex for ASCII conversion (9 in ASCII)
NEG30		.FILL xFFD0	;Negative 30 hex for ASCII conversion (0 in ASCII)
NEWLINE		.FILL x000A	;10 hex for newline in ASCII(10 hex = Newline in ASCII)
MAXCOUNT 	.FILL x0003	;Max digits that the user may input (should't need more than the number 100)
MAXNUMBERS	.FILL x0005 	;Max values the user can input

;STRINGZ========================================================================
startPrompt	.STRINGZ "Enter 5 values 0-100: \n"
invalidPrompt	.STRINGZ "Input was invalid. Try entering a number 0-9 again.\n"
rangePrompt	.STRINGZ "Range was invalid. Try entering a number 0-100 again.\n"
valid  		.STRINGZ "Valid\n"

.END