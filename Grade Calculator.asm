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

;Program Execution----------------------------------

.ORIG x3000

LEA R0, startPrompt	;Loads starting prompt to user
PUTS			;Displays prompt
LD R6, stackBase	;Load stackBase onto R6

GETVALUES
GETC			;Get next character
OUT			;Echo character on display
AND R1, R1, #0		;Clear R1
ADD R1, R0, #0		;Copy R0 to R1
ADD R1, R1, #-10	;Check if input was a newline
BRz FINISHED		;If newline then input is finished

;Input validation, checks if 0-9
AND R1, R1, #0		;Clear R1
ADD R1, R0, #0		;Copy R0 to R1
LD R2, NEG39
ADD R1, R1, R2		;Check if input is greater than 0-9
BRp INVALID		;If so, go to invalid subroutine else continue

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

FINISHED
HALT

HALT


;SUBROUTINES----------------------------------------
PUSH
ADD R6, R6, #1
STR R0, R6, #0
RET

POP 
LDR R0, R6, #0
ADD R6, R6, #-1
RET

INVALID
LD R0, NEWLINE
OUT
LEA R0, invalidPrompt
PUTS
BR GETVALUES

;STRINGZ-----------------------------------------------
startPrompt	.STRINGZ "Enter 5 values 0-100: \n"
invalidPrompt	.STRINGZ "Input was invalid. Try entering a number 0-9 again.\n"

;Address locations-------------------------------------
stackBase	.FILL x3200
charStore	.FILL x3050

;Filled values
NEG39 		.FILL xFFC7
NEG30		.FILL xFFD0
NEWLINE		.FILL x000A
MAXCOUNT 	.FILL x0003
ASCtoHex 	.FILL #-30
.END