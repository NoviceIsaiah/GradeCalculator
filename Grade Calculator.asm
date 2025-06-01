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
VALIDATE
ADD R1, R0, #0		;Copy character into R1	
STI R1, charStore

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



;DATA-----------------------------------------------
startPrompt	.STRINGZ "Enter 5 values 0-100: "
stackBase	.FILL x3200
charStore	.FILL x3050

ASCtoHex 	.FILL #-30
.END