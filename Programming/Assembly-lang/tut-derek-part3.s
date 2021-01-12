XXV. The Stack (Slide)

	1. With a stack you are literally stacking data on top of other data. Think of a stack of paper. When you want to retrieve data you would take off the last page you put on top. This is called Last In First Out (LIFO).
	
	2. A stack is implemented by keeping track of 2 pointers. 
	
		a. Base Pointer : Place in memory where the stack begins
		
		b. Stack Pointer : Memory location of the top of the stack. 
		
	3. The addresses assigned to data either ascend or descend in value. If it ascends we have to increase the value of the Stack Pointer. If it descends we have to decrease. We will increase / decrease the stack pointer address as we move through the stack.
	
	4.
	.global _start
	_start:
	  	MOV R1, #1
	  	MOV R2, #2
	  	
	  	@ Store 1 in stack pointer, move 4 bytes
	  	@ The ! (Write-Back) updates the register so it can be used 
		@ for another push onto the stack for example
		STR R1, [sp, #-4]!
		STR R2, [sp, #-4]!
		
		@ Remove the value and ascend towards the beginning of the stack
		LDR R0, [sp], #+4
		LDR R0, [sp], #+4
		
	end:
		MOV R7, #1
		SWI 0	
	
	5. We can use STM (Store Multiple) to push data onto the stack and LDM (Load Multiple) to pull data off. 
	
	6. There are 4 types of stacks depending on if the address the Stack Pointer points to has a value or not (Full or Empty). And, whether addresses ascend or descend (Ascending / Descending).
	
	7. (Slide) STM and LDM is postfixed with 2 character codes depending on the type of stack. 
	
		a. LDMIA / STMIA : Increment After
		
		b. LDMIB / STMIB : Increment Before
		
		c. LDMDA / STMDA : Decrement After
		
		d. LDMDB / STMDB : Decrement Before	
		
		e. When used to push and then pull you want to use the opposite code for LDM and STM. Ex. If you use STMDB to push, then use LDMIA to pull.
	
	8. 
	.global _start
		_start:
			MOV R4, #1
			MOV R5, #2
			
			@ We can refer to the Stack Pointer as SP
			@ Decrease SP by 8 bytes and save R4 & R5 in those 8 bytes
			@ The ! (Write-Back) updates the register so it can be used 
			@ for another push onto the stack for example
			STMDB SP!, {R4, R5}
			MOV R4, #3
			MOV R5, #4
			ADD R0, R4, #0
			ADD R0, R0, R5
			
			@ Remove the 8 bytes of data and then increment SP by 8 bytes
			LDMIA SP!, {R4, R5}
			ADD R0, R0, R4
			ADD R0, R0, R5
			
		end:
			MOV R7, #1
			SWI 0
			
	9. The .equ directive allows you to assign a value to a name
	
		a. 
		.global _start
		_start:
			MOV R0, #two
			
		end:
			MOV R7, #1
			SWI 0
		
		.data
		.equ two, 2
	
XXVI. LIBC

	1. We can convert C into machine code and we can use functions in the libc library in are assembler code. This provides a ton of prebuilt functions for you to use. 
	
	2. You can pass parameters to them using R0, R1, R2, and R3. To pass more you will use the stack. Your function can modify any of these registers. You can modify other registers, but their values must be restored upon exiting the function. You can also modify the stack pointer (R13), but must restore its entry value upon exiting (Avoid if possible). The Link Register (R14) cannot be changed.
	
	3. @ Hello World example using printf
	.data
	.balign 4
	question: .asciz "What is your favorite number? "
	
	.balign 4
	message: .asciz "%d is a great number\n"
	
	.balign 4
	pattern: .asciz "%d"
	
	.balign 4
	number: .word 0
	
	.balign 4
	lr_bu: .word 0
	
	.text
	
	@ Used by the compiler to tell libc where main is located
	.global main
	.func main
	
	main:
		@ Store Link Register
		LDR R1, addr_lr_bu
		STR lr, [R1]
		
		@ Load and print question
		LDR R0, addr_question
		BL printf
		
		@ Define pattern for scanf and where to store name
		LDR R0, addr_pattern
		LDR R1, addr_number
		BL scanf
		
		@ Print the message with the imbedded name
		LDR R0, addr_message
		LDR R1, addr_number
		LDR R1, [R1]
		BL printf
		
		@ Restore link register
		LDR lr, addr_lr_bu
		LDR lr, [lr]
		BX lr @ Return from main
		
	@ Define addresses
	addr_question: .word question
	addr_message: .word message
	addr_pattern: .word pattern
	addr_number: .word number
	addr_lr_bu: .word lr_bu
	
	@ Define we want to use printf and scanf
	.global printf
	.global scanf
	
	4. To compile put the following in makefile
	
		a. gcc:
				gcc -o asmtut asmtut.s
				
	5. You can see the disassembled code with : objdump -d asmtut
		
XXVII. Functions
 
 	1. Functions allow you to structure and reuse code. 
	
	2. You can pass parameters to them using R0, R1, R2, and R3. To pass more you will use the stack. Your function can modify any of these registers. You can modify other registers, but their values must be restored upon exiting the function. You can also modify the stack pointer (R13), but must restore its entry value upon exiting (Avoid if possible). The Link Register (R14) cannot be changed.
	
	3. If you change values in R4 - R12 
	
		a. STMFD SP!, {R4-R12} Saves the values before the function is called
		
		b. LDMFD SP!, {R4-R12} Restores the values after the function exits
	
	4. If a function returns a value it always goes in R0
	
	5. @ Custom Function for summing inputs
	.data
	
	@ Define all the strings and data we will use
	.balign 4
	get_val_1: .asciz "Number 1 :\n"
	
	.balign 4
	get_val_2: .asciz "Number 2 :\n"
	
	@ printf and scanf use %d to represent we are using decimals
	.balign 4
	pattern: .asciz "%d"

	@ Where we will store values to sum
	.balign 4
	num_1: .word 0	
	
	.balign 4
	num_2: .word 0
	
	.balign 4
	sum: .word 0
	
	@ Output for printf
	.balign 4
	output: .asciz "%d + %d = %d\n"
	
	@ Used for backing up the link register
	.balign 4
	lr_bu: .word 0	
	
	.balign 4
	lr_bu_2: .word 0
	
	.text
	
	@ Create our custom function
	@ Can receive values R0 - R3
	sum_vals:
	
		@ Save Link Register
		LDR R2, addr_lr_bu_2
		STR lr, [R2]
		
		@ Sum values and return in R0
		ADD R0, R0, R1
		
		@ Restore link register
		LDR lr, addr_lr_bu_2
		LDR lr, [lr]
		BX lr
		
	@ Address to store link register in
	addr_lr_bu_2: .word lr_bu_2
	
	@ Tell libc where main is
	.global main
	
	main:
		
		@ Store link register
		LDR R1, addr_lr_bu
		STR lr, [R1]
		
		@ Print out message to get 1st value
		LDR R0, addr_get_val_1
		BL printf
		
		@ Save value entered
		LDR R0, addr_pattern
		LDR R1, addr_num_1
		BL scanf
		
		LDR R0, addr_get_val_2
		BL printf
		
		LDR R0, addr_pattern
		LDR R1, addr_num_2
		BL scanf
		
		@ Send values entered to our custom function
		LDR R0, addr_num_1
		LDR R0, [R0]
		LDR R1, addr_num_2
		LDR R1, [R1]
		BL sum_vals
		
		@ Store value returned from function in R3
		MOV R3, R0
		
		@ Assign values to sum for output
		LDR R0, addr_output
		LDR R1, addr_num_1
		LDR R1, [R1]
		LDR R2, addr_num_2
		LDR R2, [R2]
		BL printf
		
		@ Restore link register
		LDR lr, addr_lr_bu
		LDR lr, [lr]
		BX lr
	
	@ Define addresses
	addr_get_val_1: .word get_val_1
	addr_get_val_2: .word get_val_2
	addr_pattern: .word pattern
	addr_num_1: .word num_1
	addr_num_2: .word num_2
	addr_sum: .word sum
	addr_output: .word output
	addr_lr_bu: .word lr_bu
	
	@ Define we want to use printf and scanf
	.global printf
	.global scanf
	
Directives Review

	1. Directives help us write our programs. We have already used them and they are recognized easily because they begin with a period
	
	2. We can store strings with .ascii and .asciz. asciz differs in that it adds a zero byte at the end of the string so it is easy to find the end of the string in memory
	
		a. @ Hello World Example
		.global _start
		_start:
		MOV R7, #4 @ Syscall to output to screen
		MOV R0,  #1 @ Monitor output stream
		MOV R2, #12 @ String Length
		LDR R1, =message @ Load register with address of string
		SWI 0
		
		end:
		MOV R7, #1 @ Exit syscall
		SWI 0
		
		.data @ Signify that what follows is data
		message:
		.ascii "Hello World\n"
	
	3. .word, .byte and .hword are used to define the amount of space to set aside in memory for our data. We can separate values with commas like we did previously
	
		a. numbers:
			.word 1, 2, 3, 4
