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

;Program Execution====================================================================

.ORIG x3000

;Starting prompt displayed
LEA R0, startPrompt	;Loads starting prompt to user
PUTS			;Displays prompt
LD R6, stackBase	;Load stackBase onto R6
;-------------------------------------------------------------------------------------

;Gets value and validates it. Input newline if finished
GETVALUES
GETC			;Get next character
OUT			;Echo character on display
AND R1, R1, #0		;Clear R1
ADD R1, R0, #0		;Copy R0 to R1
ADD R1, R1, #-10	;Check if input was a newline
BRz FINISHED		;If newline then input is finished

;-------------------------------------------------------------------------------------

;Input validation, checks if greater than 0-9 ASCII
AND R1, R1, #0		;Clear R1
ADD R1, R0, #0		;Copy R0 to R1
LD R2, NEG39		;R2 = -39 for range validation
ADD R1, R1, R2		;Check if input is greater than 0-9
BRp INVALID		;If so, go to invalid subroutine else continue

;-------------------------------------------------------------------------------------

;Input validation, checks if less than 0-9 ASCII
AND R1, R1, #0		;Clear R1
ADD R1, R0, #0		;Copy R0 to R1
LD R2, NEG30		;R2 = -30
ADD R1, R1, R2		;Check if input is less than 0-9 
BRn INVALID		;If so, go to invalid subroutine else continue

;-------------------------------------------------------------------------------------

;Push the inputted number 0-9 on the stack
JSR PUSH		;Else push number onto stack
AND R1, R1, #0		;Clear R1
AND R2, R2, #0		;Clear R2
ADD R3, R3, #-1		;Adds one to counter
LD R2, MAXCOUNT		;Loads max number count (3) since values can't go past 100
ADD R2, R2, R3		;Subtract counter from maxcount		 
BRnz FINISHED		;Once 3 numbers 0-9 are inputted, grade value is inputed
BR GETVALUES

;-------------------------------------------------------------------------------------

;Validate number is 0-100
FINISHED	
JSR FINDSIZE 		;Find stack size
JSR CHECKDIGITS 	;Use stack size to find how many digits are in inputted value

AND R2, R2, #0		;Clear registers used in last subroutine
AND R3, R3, #0		;Clear R3
AND R4, R4, #0		;Clear R4
AND R5, R5, #0		;Clear R5

STI R5, decValue
JSR GETDEC		;Get the decimal equvialent and validate 0-100
LDI R2, decValue	;Load current decimal value on R2
LD  R3, NEG100		;Load -100 on R3
ADD R2, R2, R3		;R2 = R2-100 
BRp OUTOFRANGE		;Checks if greater than 100 if so then input again

;-------------------------------------------------------------------------------------

;Find decimal value of input if in range
AND R2, R2, #0		;Clear R2 (R2 = 0)
STI R2, oneDigit	;Clear oneDigit location
STI R2, twoDigit	;Clear twoDigit location
STI R2, thrDigit	;Clear thrDigit location

;-------------------------------------------------------------------------------------

;After finding decimal value add one to counter since user needs to input 5 numbers
LDI R2, inpCount	;Load current input count
ADD R2, R2, #1		;Add one to input counter
STI R2, inpCount	;Store input count

AND R3, R3, #0		;Clear R3
ADD R3, R3, #5		;R3 = 5

;-------------------------------------------------------------------------------------

;Check how many numbers user inputed, if less than 5 then get another value
LDI R2, inpCount	;Load input cound
NOT R2, R2
ADD R2, R2, #1		;Two's complement of input count (-R2)

ADD R3, R3, R2		;R3 = R3-R2
BRp GETVALUES		;Checks if input count is below 5, if so get another input

;-------------------------------------------------------------------------------------	

HALT 			;End Program

;SUBROUTINES==========================================================================
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

;-------------------------------------------------------------------------------------

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
STI R3, oneDigit	;Store the value at oneDigit address
RET

TWODIGIT
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
LDR R7, R0, #0		;Load return address
ADD R0, R0, #1		;Pop stack for R7
RET			;Return

THREEDIGIT
LD R2, NEG30		;Load -30 in hex for subtraction
LDR R3, R6, #0		;Load value at pointer address
ADD R3, R3, R2		;Subtract 30 from said value to convert from ASCII
STI R3, oneDigit	;Store the value at oneDigit address

LDR R3, R6, #-1		;Load value at address before pointer
ADD R3, R3, R2		;Subtract 30 form said value to convert from ASCII
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

LDR R3, R6, #-2		;Load bottom of stack value onto R3
ADD R3, R3, R2		;Subtract 30 from value to convert from ASCII
LD  R4, HUNDRED 	;Load 100 onto R4 to use for multiplier

;Save return address so that we can use MULTIPLY subroutine in subroutine
AND R0, R0, #0		;Clear R0
ADD R0, R0, #-1         ;Push stack to save R7
STR R7, R0, #0		;Store R7 return address 
JSR MULTIPLY		;Multiply subroutine
STI R5, thrDigit	;Store product in R5
LDR R7, R0, #0		;Load return address
ADD R0, R0, #1		;Pop stack for R7
RET			;Return

;-------------------------------------------------------------------------------------

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
LDR R0, R6, #0		;Load top of stack value
ADD R6, R6, #-1		;Subtract one from pointer
RET

;-------------------------------------------------------------------------------------

;Invalid subrotuine for if value is greater than 100
INVALID
AND R3, R3, #0		;Clear counter for character count
LD R0, NEWLINE		;Load newline
OUT			;Display it
LEA R0, invalidPrompt	;Load invalidPrompt
PUTS			;Display prompt
BR GETVALUES		;Get another value

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

;Multiply subroutine
MULTIPLY
ADD R4, R4, #0		;Checks if multiplier is 0  	
BRz SETZERO		;If so set product to 0
MULTLOOP		;Multiply loop start
ADD R5, R5, R3		;Add 
ADD R4, R4, #-1		;Subtract from counter
BRp MULTLOOP		;If counter is still postive, go back to loop
RET			;Else return

SETZERO 
AND R3, R3, #0		;Set product to zero
RET			;Return

;-------------------------------------------------------------------------------------

GETGRADE
AND R0, R0, #0 		;Clear R0

LD R3, NEG90 		; Calculate if the Test Score is an A
ADD R4, R2, R3
BRn NOTA
LD R0, CHARA
RET

NOTA
LD R3, NEG80
ADD R4, R2, R3
BRn NOTB
LD R0, CHARB
RET

NOTB
LD R3, NEG70
ADD R4, R2, R3
BRn NOTC
LD R0, CHARC
RET

NOTC
LD R3, NEG70
ADD R4, R2, R3
BRn NOTD
LD R0, CHARD
RET

NOTD
LD R0, CHARF
RET

;-------------------------------------------------------------------------------------

FINDMIN
  LD R0, score1 ;Load test score 1 to R0
  LD R1, score2 ;Load test score 2 to R1
  NOT R2, R1
  ADD R2, R2, #1 ;2s Compliment test score 2
  ADD R2, R0, R2 ; R2=R0-R1, Test Score 1- Test Score 2
  BRn CHECK2 ;If R1>R0, then use R0
  LD R0, score2 ;else, set R0=R1
CHECK2
  LD R1, score3 ;Load test score 3 to R1
  NOT R2, R1
  ADD R2, R2, #1 ;2s Compliment test score 3
  ADD R2, R0, R2 ;R2=R0-R2, Test Score Min-Test Score 3
  BRn CHECK3
  LD R0, score3
CHECK3
  LD R1, score4
  NOT R2, R1
  ADD R2, R2, #1
  ADD R2, R0, R2
  BRn CHECK4
  LD R0, score4
CHECK4
  LD R1, score5
  NOT R2, R1
  ADD R2, R2, #1
  ADD R2, R0, R2
  BRn MINFIN
  LD R0, score5
MINFIN
  RET

;-------------------------------------------------------------------------------------

FINDMAX
  LD R0, score1
  LD R1, score2
  NOT R2, R0
  ADD R2, R2, #1
  ADD R2, R1, R2
  BRn CHECKMAX2
  LD R0, score2
CHECKMAX2
  LD R1, score3
  NOT R2, R0
  ADD R2, R2, #1
  ADD R2, R1, R2
  BRn CHECKMAX3
  LD R0, score3
CHECKMAX3
  LD R1, score4
  NOT R2, R0
  ADD R2, R2, #1
  ADD R2, R1, R2
  BRn CHECKMAX4
  LD R0, score4
CHECKMAX4
  LD R1, score5
  NOT R2, R0
  ADD R2, R2, #1
  ADD R2, R1, R2
  BRn MAXFIN
  LD R0, score5
MAXFIN
  RET

;-------------------------------------------------------------------------------------

FINDAVG
  LD R0, score1 ;Load Test Scores and Sum them up
  LD R1, score2
  ADD R0, R0, R1
  LD R1, score3
  ADD R0, R0, R1
  LD R1, score4
  ADD R0, R0, R1
  LD R1, score5
  ADD R0, R0, R1
  
  RET

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

;Filled values=========================================================================
HUNDRED		.FILL x0064	;100 hex
NEG100		.FILL xFF9C 	;Negative 100 hex
NEG39 		.FILL xFFC7	;Negative 39 hex for ASCII conversion (9 in ASCII)
NEG30		.FILL xFFD0	;Negative 30 hex for ASCII conversion (0 in ASCII)
NEWLINE		.FILL x000A	;10 hex for newline in ASCII(10 hex = Newline in ASCII)
MAXCOUNT 	.FILL x0003	;Max digits that the user may input (should't need more than the number 100)
MAXNUMBERS	.FILL x0005 	;Max values the user can input
CHARA  		.FILL x0041 	;'A'
CHARB  		.FILL x0042 	;'B'
CHARC  		.FILL x0043 	;'C'
CHARD  		.FILL x0044 	;'D'
CHARF  		.FILL x0045 	;'F'
NEG90  		.FILL xFFA6 	;Negative 90 hex
NEG80  		.FILL xFFB0 	;Negative 80 hex
NEG70  		.FILL xFFBA 	;Negative 70 hex
NEG60  		.FILL xFFC4 	;Negative 60 hex



;Strings===============================================================================
startPrompt	.STRINGZ "Enter 5 values 0-100: \n"
invalidPrompt	.STRINGZ "Input was invalid. Try entering a number 0-9 again.\n"
rangePrompt	.STRINGZ "Range was invalid. Try entering a number 0-100 again.\n"

.END