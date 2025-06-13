;CIS11
;Isaiah Lopez, Nicholas Aborita
;Final Project
;Grade Calculator
;Desc: The user inputs a set of 5 numerical values/integers (0-100) to
;be calculate the max. score, min. score, and average score along with
;letter-equivalent scores to be displayed.  
;
; Inputs: User inputs five numbers 0-100. No characters other than 0-9 allowed. Numbers 
; above 100 not allowed.
; Outputs: Prompts user for inputs (0-100). Displays scores inputted along with grade
; equivalent next to scores. Dispaly max, min, and average score below. 
; Run:  Assemble the program
;	Open the Simulate Software
;	Load the Assembled program(.obj file)
;	Run program
;	Input 5 integer values (0-100)
;	Read display for results
;
;Program Execution====================================================================

.ORIG x3000

;Starting prompt displayed
maxPrompt 	.STRINGZ "Max: "
minPrompt	.STRINGZ "Min: "
avgPrompt	.STRINGZ "Avg: "
rangePrompt	.STRINGZ "Range was invalid. Try entering a number 0-100 again.\n"
startPrompt	.STRINGZ "Enter 5 values 0-100: \n"
LEA R0, startPrompt	;Loads starting prompt to user
PUTS			;Displays prompt
LD R6, stackBase	;Load stackBase onto R6

;Set minValue to 100, if there is a smaller number then
LD R0, HUNDRED
STI R0, minValue 	;If value is smaller that will be the new minimum value


;Gets value and validates it. Input newline if finished
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
LD R2, NEG39		;R2 = -39 for range validation
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
JSR FINDSIZE 		;Find stack size (in R1)
JSR CHECKDIGITS 	;Use stack size to find how many digits are in inputted value

AND R2, R2, #0		;Clear registers used in last subroutine
AND R3, R3, #0		;Clear R3
AND R4, R4, #0		;Clear R4


STI R5, decValue	;Clear decValue
JSR GETDEC		;Get the decimal equvialent and validate 0-100
LDI R2, decValue	;Load current decimal value on R2
LD  R3, NEG100		;Load -100 on R3
ADD R2, R2, R3		;R2 = R2-100 
BRp OUTOFRANGE		;Checks if greater than 100 if so then input again

;IF IN RANGE CONTINUE WITH PROCESS
;If stack size if 3 (3 digits) add newline
LDI R2, curSize		;Gets current size of the stack
AND R3, R3, #0		
ADD R2, R2, #-3		;Checks to see if the stack was a size of 3 to add a newline
BRn SKIP		;If not then don't add newline
LD  R0, NEWLINE		;Else add newline
OUT

SKIP
;If in range then add to average
LDI R2, decValue	;Load current decimal value
LDI R3, avgValue	;Load current avgerage valueg
ADD R3, R3, R2		;Add decimal value to average value for later
STI R3, avgValue	;Store said value

JSR FINDMIN
JSR FINDMAX
LDI R1, decValue
JSR FINDGRADE

LDI R0, curLetter
OUT
LD R0, NEWLINE
OUT
LD R0, NEWLINE
OUT

AND R3, R3, #0		
STI R3, decValue	
STI R3, oneDigit
STI R3, twoDigit
STI R3, thrDigit

;After finding decimal value add one to counter since user needs to input 5 numbers
LDI R2, inpCount	;Load current input count
ADD R2, R2, #1		;Add one to input counter
STI R2, inpCount	;Store input count

;Check how many numbers user inputed, if less than 5 then get another value
AND R1, R1, #0		;Clear R1
ADD R1, R1, #5		;R1 = 5
LDI R2, inpCount	;Load input count
NOT R2, R2
ADD R2, R2, #1		;Two's complement of input count (-R2)
ADD R1, R1, R2		;R1 = R1-R2
BRp GETVALUES		;Checks if input count is below 5, if so get another input

;Display Max
LEA R0, maxPrompt
PUTS
LDI R1, maxValue
JSR FINDGRADE
LDI R0, curLetter
OUT
LD R0, NEWLINE
OUT

;Display Min
LEA R0, minPrompt
PUTS
LDI R1, minValue
JSR FINDGRADE
LDI R0, curLetter
OUT
LD R0, NEWLINE
OUT

;Find Average
LDI R0, avgValue
JSR DIVIDEBY5
STI R2, avgValue

;Display Average
LEA R0, avgPrompt
PUTS
LDI R1, avgValue
JSR FINDGRADE
LDI R0, curLetter
OUT
LD R0, NEWLINE
OUT

HALT 			;End Program

;Address locations=====================================================================
stackBase	.FILL x3200
minValue	.FILL x3205 
maxValue	.FILL x3206
avgValue	.FILL x3207
oneDigit	.FILL x3208
twoDigit	.FILL x3209
thrDigit	.FILL x320A
decValue	.FILL x320B
inpCount	.FILL x320C
curSize		.FILL x320D
minSize		.FILL x3210
minOne		.FILL x3211
minTwo		.FILL x3212
minThr		.FILL x3213
maxSize		.FILL x3215
maxOne		.FILL x3216
maxTwo		.FILL x3217
maxThr		.FILL x3218

;Filled values=========================================================================
NEWLINE		.FILL x000A	;10 hex for newline in ASCII(10 hex = Newline in ASCII)
NEG30		.FILL xFFD0	;Negative 30 hex for ASCII conversion (0 in ASCII)
NEG39 		.FILL xFFC7	;Negative 39 hex for ASCII conversion (9 in ASCII)
NEG100		.FILL xFF9C 	;Negative 100 hex
NEG90  		.FILL xFFA6 	;Negative 90 hex
NEG80  		.FILL xFFB0 	;Negative 80 hex
NEG70  		.FILL xFFBA 	;Negative 70 hex
NEG60  		.FILL xFFC4 	;Negative 60 hex
MAXCOUNT 	.FILL x0003	;Max digits that the user may input (should't need more than the number 100)
MAXNUMBERS	.FILL x0005 	;Max values the user can input
curLetter	.FILL x320E

;SUBROUTINES==========================================================================
FINDSIZE
AND R1, R1, #0		;Clear R1
AND R2, R2, #0
AND R3, R3, #0
STI R1, curSize		;Clear current stack size to find new stack size
ADD R1, R6, #0		;Copy R6 (current pointer) to R1
LD R2, stackBase	;Load stack base into R2
NOT R2, R2		;
ADD R2, R2, #1		;Two's complement of R2
ADD R1, R1, R2		;Subrtract stackBase from pointer to get stack size
STI R1, curSize		;Store current size into R1
RET

;-------------------------------------------------------------------------------------

;Checks if value inputted is out of range (greater than 100)
OUTOFRANGE
AND R1, R1, #0		;Clear R1-R3
AND R2, R2, #0
AND R3, R3, #0
STI R3, decValue	;Clear all digit locations
STI R3, oneDigit
STI R3, twoDigit
STI R3, thrDigit
LD R0, NEWLINE		;Load and display newline
OUT
LEA R0, rangePrompt	;Load rangePrompt
PUTS			;Display rangePrompt

;Pop stack completely to restart
ADD R1, R6, #0 		;Copy pointer (R6) to R1
LD  R2, stackBase	;Copy stack base onto R2
NOT R2, R2
ADD R2, R2, #1		;Two's complement of stack
ADD R1, R1, R2		;Get stack size by subtracting stackbase from pointer
BRp CONT		;If there is a stack size, then continue to pop stack
BR GETVALUES		;Else go back to getting another value

CONT	
JSR POP			;Pop last value
ADD R1, R1, #-1		;Subtrack from stacksize counter
BRp CONT		;If positive continue to pop stack
BR GETVALUES		;Else get another value

;-------------------------------------------------------------------------------------

;Invalid subrotuine for if value is greater than 100
INVALID
AND R3, R3, #0		;Clear counter for character count
LD R0, NEWLINE		;Load newline
OUT			;Display it
LEA R0, invalidPrompt	;Load invalidPrompt
PUTS			;Display prompt
LDI R1, curSize		;Get current size of stack
BRp POPSTACK		;If there is a stack pop it
BR GETVALUES		;Get another value

POPSTACK		;Pop entire stack then get another value
JSR POP
ADD R1, R1, #-1
BRp POPSTACK
BR  GETVALUES

;-------------------------------------------------------------------------------------

CHECKDIGITS
;Check for one digit first
LDI R3, curSize		;Load current size onto R3
AND R2, R2, #0		;Clear R2
ADD R2, R2, #-1		;Load -1 onto R2 for subtraction
ADD R3, R3, R2		;Subtract 1 from stack size
BRz ONEDIGIT 		;Check if number has one digit

;Check for two digits
AND R2, R2, #0		;Clear R2
LDI R3, curSize		;Load current size onto R3
ADD R2, R2, #-2		;Load -2 onto R2 for subtraction
ADD R3, R3, R2		;Subtract 2 from stack size
BRz TWODIGIT		;Check if number has two digits

;Check for three digits
AND R2, R2, #0		;Clear R2
LDI R3, curSize		;Load current size onto R3
ADD R2, R2, #-3		;Load -3 onto R2 for subtraction
ADD R3, R3, R2		;Subtract 3 from stack size
BRz THREEDIGIT		;Check if number has three digits

ONEDIGIT
LD R2, NEG30		;Load -30 in hex for subtraction
AND R1, R1, #0		;Clear R1
ADD R1, R1, #-1         ;Push stack to save R7
STR R7, R1, #0		;Store R7 return address 
JSR POP			;Pop for value at top of stack
LDR R7, R1, #0		;Load return address
ADD R0, R0, R2		;Subtract 30 from said value to convert from ASCII
STI R0, oneDigit	;Store the value at oneDigit address
RET

TWODIGIT
;Ones digit
LD R2, NEG30		;Load -30 in hex for subtraction
AND R1, R1, #0		;Clear R1
ADD R1, R1, #-1         ;Push stack to save R7
STR R7, R1, #0		;Store R7 return address 
JSR POP			;Pop for value at top of stack
LDR R7, R1, #0		;Load return address
ADD R0, R0, R2		;Subtract 30 from said value to convert from ASCII
STI R0, oneDigit	;Store the value at oneDigit address

;Tens digit
AND R1, R1, #0		;Clear R1
ADD R1, R1, #-1         ;Push stack to save R7
STR R7, R1, #0		;Store R7 return address 
JSR POP			;Pop for value at top of stack
LDR R7, R1, #0		;Load return address
ADD R0, R0, R2		;Subtract 30 form said value to conver from ASCII
AND R3, R3, #0		;Clear R3
ADD R3, R3, #10		;R3 = 10
AND R1, R1, #1		;Clear R0
ADD R1, R1, #-1         ;Push stack to save R7
STR R7, R1, #0		;Store R7 return address 
JSR MULTIPLY		;Multiply subroutine
LDR R7, R1, #0		;Load return address
STI R4, twoDigit	;Store product in R4
RET			;Return

THREEDIGIT
;Ones digit
LD R2, NEG30		;Load -30 in hex for subtraction
AND R1, R1, #0		;Clear R1
ADD R1, R1, #-1         ;Push stack to save R7
STR R7, R1, #0		;Store R7 return address 
JSR POP			;Pop for value at top of stack
LDR R7, R1, #0		;Load return address
ADD R0, R0, R2		;Subtract 30 from said value to convert from ASCII
STI R0, oneDigit	;Store the value at oneDigit address

;Tens digit
AND R1, R1, #0		;Clear R1
ADD R1, R1, #-1         ;Push stack to save R7
STR R7, R1, #0		;Store R7 return address 
JSR POP			;Pop for value at top of stack
LDR R7, R1, #0		;Load return address
ADD R0, R0, R2		;Subtract 30 form said value to conver from ASCII
AND R3, R3, #0		;Clear R3
ADD R3, R3, #10		;R3 = 10
AND R1, R1, #1		;Clear R0
ADD R1, R1, #-1         ;Push stack to save R7
STR R7, R1, #0		;Store R7 return address 
JSR MULTIPLY		;Multiply subroutine
LDR R7, R1, #0		;Load return address
STI R4, twoDigit	;Store product in R5

;Hundreds digit
HUNDRED	.FILL x0064	;100 hex
AND R1, R1, #0		;Clear R1
ADD R1, R1, #-1         ;Push stack to save R7
STR R7, R1, #0		;Store R7 return address 
JSR POP			;Pop for value at top of stack
LDR R7, R1, #0		;Load return address
ADD R0, R0, R2		;Subtract 30 form said value to conver from ASCII
LD R3, HUNDRED		;R3=100 for multiplier
AND R1, R1, #1		;Clear R1
ADD R1, R1, #-1         ;Push stack to save R7
STR R7, R1, #0		;Store R7 return address 
JSR MULTIPLY		;Multiply subroutine
LDR R7, R1, #0		;Load return address
STI R4, thrDigit	;Store product in R5
RET		


;Get decimal value from ASCII characters inputted
GETDEC			
LDI R1, oneDigit	;Load ones value
ADD R2, R2, R1		;Add to R2
LDI R1, twoDigit	;Load tens value
ADD R2, R2, R1		;Add to R2
LDI R1, thrDigit	;Load hundreds value
ADD R2, R2, R1		;Add to R2
STI R2, decValue	;Store decimal value at decVal location
RET

;-------------------------------------------------------------------------------------

;Push value at R0 on top of stack
PUSH
ADD R6, R6, #1		;Add one to pointer
STR R0, R6, #0		;Store value at pointer address
RET

;-------------------------------------------------------------------------------------

;Pop value off of stack
POP
LDR R0, R6, #0		;Load top of stack value to R0
AND R4, R4, #0
STR R4, R6, #0
ADD R6, R6, #-1		;Subtract one from pointer
RET

;-------------------------------------------------------------------------------------

FINDMIN
LDI R1, decValue
NOT R1, R1
ADD R1, R1, #1
LDI R2, minValue
ADD R2, R2, R1
BRnz SKIPMIN
LDI R1, decValue
STI R1, minValue
LDI R1, curSize
STI R1, minSize
LDI R1, oneDigit
STI R1, minOne
LDI R1, twoDigit
STI R1, minTwo
LDI R1, thrDigit
STI R1, minThr
RET

SKIPMIN
RET

;-------------------------------------------------------------------------------------

FINDMAX
LDI R1, decValue
LDI R2, maxValue
NOT R2, R2
ADD R2, R2, #1
ADD R1, R1, R2
BRnz SKIPMAX
LDI R1, decValue
STI R1, maxValue
LDI R1, curSize
STI R1, maxSize
LDI R1, oneDigit
STI R1, maxOne
LDI R1, twoDigit
STI R1, maxTwo
LDI R1, thrDigit
STI R1, maxThr
RET

SKIPMAX
RET

;-------------------------------------------------------------------------------------

;Multiply subroutine
MULTIPLY
AND R4, R4, #0
ADD R3, R3, #0		;Checks if multiplier is 0  	
BRz SETZERO		;If so set product to 0
MULTLOOP		;Multiply loop start
ADD R4, R4, R0		;Add R0 to R4 for product
ADD R3, R3, #-1		;Subtract from counter
BRp MULTLOOP		;If counter is still postive, go back to loop
RET			;Else return

SETZERO 
AND R4, R4, #0		;Set product to zero
RET			;Return

;-------------------------------------------------------------------------------------

;Divide subroutine (R0 is dividend, R1 is divisor, R2 is quotient, R0 will act as remainder)
DIVIDEBY5
AND R1, R1, #0
AND R2, R2, #0
ADD R1, R1, #-5
DIVLOOP
ADD R2, R2, #1
ADD R0, R0, R1
BRp DIVLOOP
ADD R0, R0, #0
BRz CLEANDIV
ADD R2, R2, #-1
RET

CLEANDIV
RET

;-------------------------------------------------------------------------------------

FINDGRADE
LD  R2, NEG90
ADD R3, R1, R2
BRzp AGRADE

AND R3, R3, #0
LD  R2, NEG80
ADD R3, R1, R2
BRzp BGRADE

AND R3, R3, #0
LD  R2, NEG70
ADD R3, R1, R2
BRzp CGRADE

AND R3, R3, #0
LD  R2, NEG60
ADD R3, R1, R2
BRzp DGRADE

LD  R1, CHARF
STI R1, curLetter
RET

;-----------------
AGRADE 
LD  R1, CHARA
STI R1, curLetter
RET

BGRADE
LD  R1, CHARB
STI R1, curLetter
RET

CGRADE
LD  R1, CHARC
STI R1, curLetter
RET

DGRADE
LD  R1, CHARD
STI R1, curLetter
RET

;Filled values=========================================================================
ZERO		.FILL x0000	;0 hex
CHARA  		.FILL x0041 	;'A'
CHARB  		.FILL x0042 	;'B'
CHARC  		.FILL x0043 	;'C'
CHARD  		.FILL x0044 	;'D'
CHARF  		.FILL x0046 	;'F'

;Strings===============================================================================
invalidPrompt	.STRINGZ "Input was invalid. Try entering a number 0-9 again.\n"
.END