XII. Logical Operators

	1. Logical operators follow this format where Operand 1 must be a register and Operand 2 can be a register or a number
	Instruction <Destination>, <Operand 1>, <Operand 2>
	
	2. :%d Selects and deletes all in Vim
	
	3. AND returns 0 except when both bits are 1
	
		a. @ AND Example
		.global _start
		_start:
			MOV R1, #5 @ 0101 
			MOV R2, #9 @ 1001
			AND R0, R1, R2 @ Result is 0001 or 1
			
		end:
			MOV R7, #1 
			SWI 0
	
	4. ORR returns 1 except when both bits are 0
	
		a. @ ORR Example
		.global _start
		_start:
			MOV R1, #5 @ 0101 
			MOV R2, #9 @ 1001
			ORR R0, R1, R2 @ Result is 1101 or 13
			
		end:
			MOV R7, #1 
			SWI 0
	
	5. EOR returns 0 except when bits are opposite (1 1 and 1 0)
		
		a. @ EOR Example
		.global _start
		_start:
			MOV R1, #5 @ 0101 
			MOV R2, #9 @ 1001
			EOR R0, R1, R2 @ Result is 1100 or 12
			
		end:
			MOV R7, #1 
			SWI 0
		
	6. BIC returns 0 except when the top bit is 1 and the bottom 0
		
		a. @ BIC Example
		.global _start
		_start:
			MOV R1, #5 @ 0101 
			MOV R2, #9 @ 1001
			BIC R0, R1, R2 @ Result is 0100 or 4
			
		end:
			MOV R7, #1 
			SWI 0
			
		b. @ Convert to uppercase with BIC
		.global _start
		_start:
			MOV R7, #3 @ Syscall read from keyboard
			MOV R0,  #0 @ Input stream keyboard
			MOV R2, #1 @ Read 1 character
			LDR R1, =character @ Put character in character
			SWI 0
			
		_uppercase:
			LDR R1, =character @ Get address to character
			LDR R0, [R1] @ Load character into R0
			
			@ Zero out 6th bit
			@ a : 0110 0001
			@   : 0010 0000
			@ A : 0100 0001
			BIC R0, R0, #32 
			
			STR R0, [R1] @ Store character with address stored in R1 in R0
		
		_write:
			MOV R7, #4 @ Syscall to output to screen
			MOV R0, #1 @ Output to monitor
			MOV R2, #1	@ # of characters to write
			LDR R1, =character @ Print character in character
			SWI 0
		
		end:
			MOV R7, #1
			SWI 0
		
		.data
		character:
			.ascii " "
		
	7. TST (TeSt biTs) proforms an AND on bits and updates the Zero Flag CPSR
	
		a. .global _start
		_start:
			MOV R1, #9 @ 1001
			MOV R2, #8 @ 1000
			TST R1, R2 @ Compare values setting flags
			BEQ _bit_set @ If set jump to bit_set (Zero Flag Set)
			MOV R0, #1 @ Set output to false
			B end @ Jump to end
			
		_bit_set:
			MOV R0, #0 @ Set output to true
			
		end:
			MOV R7, #1 
			SWI 0
			
	8. TEQ (Test EQuivalence) proforms an EOR on bits and updates the Zero Flag CPSR
	
XIII. Looping

	1. Normally looping would look like this
	
		a. Loop to 10
		r0 = 0
		r1 = 1
		while(r0 <= 10):
			r0 = r0 + r1
		   
	2. @ Assembly looping to increment to 10		
	.global _start
	_start:
		MOV R0, #0
		MOV R1, #1
		B _continue_loop
		
	_loop:
		ADD R0, R0, R1
		
	_continue_loop:
		CMP R0, #9
		BLE _loop
		
	end:
		MOV R7, #1 
		SWI 0

XIX. Conditional Codes

	1. You can define is an instruction is executed based on conditions. You do this by ending an instruction with 1 of many 2 character codes.
	
	2. We already saw these codes in action when branching.
		
	3. Here are the codes
	EQ : Z Set
	NE : Z Not Set
	CS : Carry Set
	CC : Carry Not Set
	MI : Negative Set
	PL : Negative Not Set
	VS : Overflow Set
	VC : Overflow Not Set
	HI : Carry & !Zero
	LS : !Carry & Zero
	GE : Negative == Overflow
	LT : Negative != Overflow
	GT : !Zero && Negative = Overflow
	LE : Zero || Negative != V
	
	4. Increment r0 until == to r1
	
		a. Python
		r0 = 50
		r1 = 2
		while(r0 > r1):
    		r0 -= 2
    		
    	b. @ Assembly
    	.global _start
		_start:
    		MOV R0, 50
    		MOV R1, 2
    		B _loop
    		
    	_decrement:
    		SUBGT R0, R0, R1 @ If R0 is Greater Then R1 subtract 2
    		
    	_loop:
    		CMP R0, R1 @ Compare R0 to R1
    		BNE _decrement @ If Not Equal jump to decrement
    		
    	end:
		MOV R7, #1 
		SWI 0
		
XX. Barrel Shifter

	1. We can move bits left and right which makes for quick ways to multiply and divide.
	
	2. LSL : Logical Shift Left shifts all bits left and moves the highest bit into the Carry Flag (Multiplies Original Value by 2)
	
		a. .global _start
		_start:
    		MOV R1, #15 @ 1111
    		MOV R0, R1, LSL #1 @ Shift value in R1 1 bit left and save to R0
    		
    	end:
		MOV R7, #1 
		SWI 0
		
	3. LSR : Logical Shift Right shifts all bits right and moves the lowest bit into the Carry Flag (Divides Original Value by 2)
	
		a. .global _start
		_start:
    		MOV R1, #15 @ 1111
    		MOV R0, R1, LSR #1 @ Shift value in R1 1 bit right and save to R0
    		
    	end:
		MOV R7, #1 
		SWI 0
		
XXI. Memory Storage

	1. We have been storing data in registers for the most part, but now we will store it in memory. We store data by referring to that datas address in memory.
	
	2. We can store an address in a register and then use that register to load or store data. The labels we have used are addresses that refer to code, but we can also use them to refer to data.
	
	3. @ Create 2 4 byte variables and give them values of 15 and 30
	.data 		
	.balign 4 @ Request 4 bytes in the address
	fifteen: @ Define storage for fifteen
		.word 15 @ Assign value to fifteen
		
	.balign 4 @ Request 4 bytes in the address
	thirty: @ Define storage for thirty
		.word 30 @ Assign value to thirty
	
	.text
	.global _start
	_start:
    	LDR R1, addr_fifteen @ Load address
    	LDR R1, [R1] @ Load data using address
    	LDR R2, addr_thirty @ Load address
    	LDR R2, [R2] @ Load data using address
    	ADD R0, R1, R2
    	
	end:
		MOV R7, #1 
		SWI 0
    	
	@ Labels for addresses in the data section
	addr_fifteen : .word fifteen
	addr_thirty : .word thirty
	
	4. @ Load values by referring to the addresses using STR
	.data 		
	.balign 4 @ Request 4 bytes in the address
	fifteen: @ Define storage for fifteen
		.word 0 @ Assign value to fifteen
		
	.balign 4 @ Request 4 bytes in the address
	thirty: @ Define storage for thirty
		.word 0 @ Assign value to thirty
	
	.text
	.global _start
	_start:
    	LDR R1, addr_fifteen @ Load address
    	MOV R3, #15 @ Put 15 in R3
    	STR R3, [R1] @ Put value in R3 at the address in R1
    	LDR R2, addr_thirty @ Load address
    	MOV R3, #30 @ Put 30 in R3
    	STR R3, [R2] @ Put value in R3 at the address in R2
    	
    	@ Redo last program
    	LDR R1, addr_fifteen @ Load address
    	LDR R1, [R1] @ Load data using address
    	LDR R2, addr_thirty @ Load address
    	LDR R2, [R2] @ Load data using address
    	ADD R0, R1, R2
    	
	end:
		MOV R7, #1 
		SWI 0
    	
	@ Labels for addresses in the data section
	addr_fifteen : .word fifteen
	addr_thirty : .word thirty
	
XXII. Debugging

	1. The debugging tool GDB will be extremely useful with Assembler. If a program crashes it will be helpful to know where the problem occurs if the standard error messages aren't helping. 
	
	2. @ Use this code in this example
	.global _start
	_start:
		MOV R0, #0
		MOV R1, #1
		B _continue_loop
		
	_loop:
		ADD R0, R0, R1
		
	_continue_loop:
		CMP R0, #9
		BLE _loop
		
	end:
		MOV R7, #1 
		SWI 0
	
	3. When compiling your program if you want to debug add the -g option like this : 
	
		a. as -g -o asmtut.o asmtut.s
		
		b. ld -o asmtut asmtut.o
		
		c. You then start GDB with : gdb asmtut
		
	4. list displays the 1st 10 lines of your code with line numbers
	
	5. You can disassemble your code. To disassemble the code attacjed to the label _start type : disassemble _start
	
		a. The 1st number is the location in memory for the instruction. The 2nd is the number of bytes from the beginning of the label or function.
	
	6. By using breakpoints you can step through your code one line at a time and see how register and flag values change. 
	
		a. b 13 : Sets a breakpoint at line 13
		
		b. delete 13 : Deletes the breakpoint
	
		c. run : Run the program up to line 13
		
		d. info r : Return the current register values
		
			1. SP (Stack Pointer): Points to the stack in memory
			
			2. PC (Program Counter): Stores the next instruction to execute
		
		e. continue : Runs the code again till the next breakpoint
		
			1. Type continue many times to watch the register values increment
			
			2. Notice that the CPSR is set to 80000010, which means the Negative flag is set because of CMP R0, #9. The top flags are 1000 or 8 
			
		f. Type quit to exit the gdb
			
	7. Change make file for easy debugging by adding
	debug:
		as -g -o asmtut.o asmtut.s
		ld -o asmtut asmtut.o
		gdb asmtut
		
XXIII. Memory Storage

	1. Registers need to be clear so we can perform operations so we will store data in memory. To do so we must keep track of where we store data in memory.
	
	2. We can use the directive ADR to load a 32 bit address by passing it a label.
	
		a. 
		.global _start
		_start:
			ADR R0, info @ Load the address for the data in R0
			
		end:
			MOV R7, #1
			SWI 0
			
		@ Data ADR accesses must be in the .text area
		info:
			.word 10
			
		b. make debug
		
		c. b 6
		info r
		
		d. You'll see that R0 points at the address for the label
		
		e. Type x/4w _start to examine 4 Words of data starting at the address for _start and you'll see your 10
			
	3. We read data using LDR and write it using STR. You hold the address in a register.
	
		a. LDR R3, =info @ Store the address for info in R3
	
		b. LDR R2, [R3] @ Load data from the address stored in R3
		
		c. STR R4, [R3] @ Store data in R4 in the address stored in R3
		
	4. .global _start
		_start:
			LDR R3, =info @ Load the address for the data in R3
			LDR R0, [R3] @ Get the value assigned to the address
			
		end:
			MOV R7, #1
			SWI 0
			
		@ Data ADR accesses must be in the .text area
		info:
			.word 10
			
	5. We have to request enough space to allow for changes in values or you'll get a segmentation fault
	.data
	.balign 4 @ Request 4 bytes in the address
	info: @ Define storage for thirty
		.word 10 @ Assign value to thirty 
		
	.text
	.global _start
		_start:
			LDR R3, =info @ Load the address for the data in R3
			MOV R4, 100 @ Store 100 in R4
			STR R4, [R3] @ Move 100 into the addressed space in memory
			LDR R0, [R3]
			
		end:
			MOV R7, #1
			SWI 0
			
	6. We can retrieve the next piece of data in a list by adding or subtracting a value from the target address.
	
	7. With Pre-Indexed Addressing you provide the base address and the offset to the next value. 
	
		a. LDR R2, [R3, #4] puts the 4 byte value that follows the address assigned to R3 is stored in R2. 
		
		b. You can also subtract like this LDR R2, [R3, #-4].
		
		c. LDR R2, [R3, R4, LSR#4] : Shifts the value in R3 right by 2 bits and then is added to R3. 4 is used to jump you 4 bytes in to the data. 

	8. Demonstrate getting different items in the list
	.data
	primes:
	  .word 2
	  .word 3
	  .word 5
	  .word 7
	  
	.text 
	.global _start
		_start:
			LDR R3, =primes @ Load the address for the data in R3
			@ LDR R0, [R3] @ Get the value assigned to the address
			@ LDR R0, [R3, #4] @ Get the next item in the list
			LDR R0, [R3, #8] @ And the next item
			
		end:
			MOV R7, #1
			SWI 0
			
	9. Read and write bytes with LDRB
	.global _start
    _start:
    	LDR R3, =numbers @ get address
    	@ LDRB R0, [R3] @ Load the first byte or number
    	@ LDRB R0, [R3, #1] @ Get next byte
    	LDRB R0, [R3, #2] @ Get next byte
    		
    end:
		MOV R7, #1
		SWI 0
		
	.data
	numbers:
		.byte 1, 2, 3, 4, 5
		
		a. You can also use half words with .hword and ldrh
		
	10. You can load multiple words in registers with a block transfer
	
	11.
	.global _start
	_start:
		ADR R3, numbers @ Get the address
		LDMIA R3, {R5-R8} @ Store 4 values starting at the address
		MOV R0, R6
		
	end:
		MOV R7, #1
		SWI 0
	.align 2 @ Enforce 2 byte alignment (Must be multiples of 2)
	numbers:
		.word 1, 2, 3, 4
