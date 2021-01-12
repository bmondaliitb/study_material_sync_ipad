I. Introduction

	1. Assembly language is 1 step above the binary that runs your hardware.
	The assembler converts your code into binary. We will be programming
	the ARM microprocessor in this tutorial. This code will only work
	with an ARM based chip, but by learning assembly on a low cost computer
	you'll be able to easily learn how to use assembly in general. The only
	difference is the mnemonics used. Also ARM chips are not only used 
	with Raspberry PI, but also by most mobile devices.
	
	2. Microprocessors manipulate data and this means you'll use the
	ADD and SUB codes for adding and subtracting. Like these most codes 
	are 3 letters long. MOV is another code. 
	
	3. Another reason why learning assembler on an ARM chip is a good idea
	is because the R in ARM stands for Reduced Instruction Set Computing. That
	means that there is a limited number of instructions or codes like ADD to
	remember. 

II. Setup

	1. Install Vim : sudo apt-get install vim
	
	2. Create a working directory : mkdir ASM\ Projects
	
	3. If you get the error No Space on Device message : sudo raspi-config
	expand_rootfs and then reboot
	
	4. Create the source file asmtut1.s : vim asmtut1.s
	
	5. Vim Commands 
	
		a. i : insert mode 
		
		b. <ESC> : enter command mode
			i. w : Save / Don't Exit
			ii. wq : Save / Quit
			iii. Q! : Quit / Discard Changes
			iv. w : Move to front of next word
			v. b : Move backwards to front of word
			vi. 0 : Move to start of line
			vii. $ : Move to end of line
			
		c. Move around with arrows
		
		d. :set number : Displays line numbers
		
		e. More commands will be covered as needed
		
	6. First program
	@ I'm a comment
	/* I'm a multiline comment */
	@ Define where your instructions start, but this isn't needed
	.text 
	
	@ Defines _start as a global available to the whole program
	.global _start
	
	@ Define starting point and that it is a label with :
	_start:
	
	@ Move the value 65 into register 0
	MOV R0, #65
	
	@ Move the value 1 into register 7
	MOV R7, #1
	
	@ End the program and return to the terminal
	SWI 0
	
		a. SWI stands for SoftWare Interrupt. If R7 has a value of 1 in it SWI knows to exit to the terminal. The value stored in R7 is the Syscall number. Depending on how different registers are set we can call for other Raspbian routines or libraries to be called. 
		
	7. Compile Code
		a. as -o asmtut.o asmtut.s
			1. Create an object file
			
		b. ld -o asmtut asmtut.o
			1. Make an executable file by linking files together
		
		c. Execute with ./asmtut ; echo $?
		
	8. If you type echo $? in the terminal the value stored in R0 is returned
	
	9. Second Program
	@ asmtut2.s
	.global _start
	_start:
	MOV R0, #65
	
	@ Branch to _part2 in the next part of the program
	BAL _part2
	
	@ asmtut3.s
	.global _part2
	_part2:
	MOV R7, #1
	SWI 0
	
		a. Compile program
		
			1. as -o asmtut2.o asmtut2.s
			
			2. as -o asmtut3.o asmtut3.s
			
			3. ld -o asmtut4.o asmtut2.o asmtut3.o
			
			4. ./asmtut4 ; echo $?
			
	10. We'll create a makefile to make it easier to compile. A makefile contains the following rules
	
		a. target: prerequisite
		   <TAB>   recipe
		   
		b. Target is the name of the file to generate
		
		c. The prerequisite is a file needed to create target. If the prerequisite doesn't exist we look for its creation in the targets that follow
		
		d. The recipe is an action that make executes
		
		e. Add the following to execute clean up with (make clean)
		clean:
			rm *.o asmtut
		
		f. asmtut: asmtut.o
				ld -o asmtut asmtut.o
		   asmtut.o asmtut.s
		   		as -o asmtut.o asmtut.s
		   clean:
				rm *.o asmtut
			
III. Registers, Bits, Bytes and Words (Slide)

	1. A bit is either a 1 or a 0

	2. The ARM CPU is a 32 bit CPU. A byte has 8 bits. 4 bytes or 32 bits are called words with this ARM CPU because 32 bits is the unit of data used by the Raspberry PI.
	
	3. Data is stored in memory in words, but you also have access to the bytes. 
	
	4. The CPU has 16 registers that can hold a word of data each. Registers 0 - 12 are always available. 
	
	5. Register 13 is a pointer to the active stack. You put your data on the stack and the stack pointer tells you how high that stack of data is. (More on this later)
	
	6. Register 14 is the Link Register. When an instruction calls a subroutine the LR is set to the subroutine return address. (More on this later)

	7. Register 15 is the program counter. It stores the address of the next instruction to execute. It keeps track of where your program is in its execution of your code. (More on this later)
	
	8. There is also the Current Program Status Register. It stores info on your program and results of instructions it has executed. (More on this later)
			
IV. Binary Numbers (Slide)

	1. Binary numbers contain only 1s and 0s which combine to make
	base 10 numbers we use. 
	
	2. In Base 10 123 = 1 : 100, 2 : 10s, 3 : 1s
	
	3. In Binary 111 = 1 : 4, 1 : 2, 1 : 1 = 7 in Base 10
	
	4. From right to left the digits double 64, 32, 16, 8, 4, 2, 1
	
	5. Decimal to Binary : If subtraction is possible add a 1 and if not don't
	
		a. 126 - 64 = 62 : 1
		b. 62 - 32 = 30 : 1
		c. 30 - 16 = 14 : 1
		d. 14 - 8 = 6 : 1
		e. 6 - 4 = 2 : 1
		f. 2 - 2 = 0 : 1
		g. 0 - 1 = NA : 0
		h. 126 to binary is 1111110
		
V. Hexadecimal Numbers (Base 16) (Slide)

	1. It is easier to represent binary numbers as hex numbers.
	
	2. Hex numbers contain the numbers 0 - 9 and A, B, C, D, E, F for numbers
	10 - 15
	
	3. 	We can represent 4 bits of a binary number with 1 hex
	
		D	H		B
		0   0		0000
		1	1		0001
		2	2		0010
		3	3		0011
		4	4		0100
		5	5		0101
		6	6		0110
		7	7		0111
		8	8		1000
		9	9		1001
		10	A		1010
		11	B		1011
		12	C		1100
		13	D		1101
		14	E		1110
		15	F		1111
		
	4. Convert Binary to Hex
	
		a. Convert a byte in 2 into 2 nibbles
		
		b. 10101010 becomes 1010 1010 or AA
		
	5. Convert Hex to Decimal
	
		a. 0x2A7 = 
		b. 2 * 16^2 = 512
		c. 10 * 16 = 160
		d. 7 * 1 = 7
		e. 512 + 160 + 7 = 679
		
	6. Convert Decimal to Hex
	
		a. 679 / 256 (16^2) = 2.65 (Throw away the remainder)
		b. (679 - 512) 167 / 16 = 10.43 or A (Throw away the remainder)
		c. 7 is left and so 679 = 2A7
		
VI. Adding and Subtracting Binaries
		
	1. Adding Binaries
	
		a. 0 + 0 = 0
		b. 1 + 0 = 1
		c. 0 + 1 = 1
		d. 1 + 1 = 0 (Carry the 1)
		
		e. 0101	: 5
		 + 0011 : 3
		   1000 : 8
		   
	2. Subtracting Binaries
	
		a. When subtracting you borrow 1 from the left to make
		a 0 into a 10 (In Binary) or 2 and then subtract 1 from
		
		b. You can't borrow from a 0 so when that happens you
		keep moving left until you get a 1 to borrow from. 
	
	
	3. Twos Complement Numbers
	
		a. To convert a number to its negative form flip each bit
		and then add 1 to it.
		
		b. 7 = 00111 and -7 = 11001
		
		c. You can now add versus subtract binaries which some people find easier
		
			1. 11000 : 24
			 - 00111 :  7
			 
			   11000 : 24
			 + 11001 : -7
			   10001 : 17
			   
			2. Through out the last carry bit to get the correct answer
			
VII. Input and Output

	1. To output to the screen we need to set the parameters as such
	
		a. R0 : Output Stream (1 : Monitor)
		
		b. R1 : Address of characters to write
		
		c. R2 : Number of characters to write
		
		d. R7 : Syscall (4 to write to screen)
		
	2. @ Hello World
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
		
	3. To output we need to set parameters as well
	
		a. R0 : Input Stream (0 : Keyboard)
		
		b. R1 : Address of buffer to save string to
		
		c. R2 : # of characters to read
		
		d. R7 : Syscall (3 to read from keyboard)
		
	4. @ Read data
	.global _start
	_start:
		MOV R7, #3 @ Syscall read from keyboard
		MOV R0,  #0 @ Input stream keyboard
		MOV R2, #10 @ Read 10 characters
		LDR R1, =message @ Put string in message
		SWI 0
		
	_write:
		MOV R7, #4 @ Syscall to output to screen
		MOV R0, #1 @ Output to monitor
		MOV R2, #5	@ # of characters to write
		LDR R1, =message @ Print string in message
		SWI 0
		
	end:
		MOV R7, #1
		SWI 0
		
	.data
	message:
		.ascii " "
	
VIII. ADD
	
	1. Most instructions follow this order 
	<Instruction> <Dest>, <Operand>, <Operand>
		
		a. Instruction Name - 3 or 4 character mnemonic
		
		b. Destination Register
		
		c. Register to manipulate
		
		d. A Register or Value to manipulate
		
	2. ADD value in register 1 plus register 2 and store in register 0
	ADD R0, R1, R2
	
	3. ADD value in register 1 plus number 1 and store in register 0
	ADD R0, R1, #1
	
	4. Add 2 values and output the result
	.global _start
	_start:
	MOV R1, #0xA @ Put 10 in R1
	ADD R0, R1, #0x14 @ Add 10 + 20, store in R0
	MOV R7, #1 @ Exit with a system call
	SWI 0 @ End program and return to terminal
	
	5. make
	./asmtut4 ; echo $?
	   
	6. The SWI instruction interacts with the operating system. Linux provides
	many services and we select the one we want by putting a value in R7. If the program returns a value that value is returned in R0. 
	
IX. SUB
	
	1. We can subtract values
	.global _start
	_start:
	MOV R1, #0x14 @ Put 20 in R1
	SUB R0, R1, #0xA @ Subtract 20 - 10, store in R0
	MOV R7, #1 @ Exit with a system call
	SWI 0 @ End program and return to terminal
	
		a. Gives a result of 10
		
X. MUL & MLA

	1. Multiply values (Must store values in Registers)
	.global _start
	_start:
	MOV R1, #0x14 @ Put 20 in R1
	MOV R2, #0xA @ Put 10 in R2
	MUL R0, R1, #0xA @ Multiply 20 * 10, store in R0
	MOV R7, #1 @ Exit with a system call
	SWI 0 @ End program and return to terminal
	
	2. MLA (Multiply with Accumulate) Multiplies the first 2 register values and then adds that to the last register value
	.global _start
	_start:
	MOV R1, #0x14 @ Put 20 in R1
	MOV R2, #0xA @ Put 10 in R2
	MOV R3, #0x5 @ Put 5 in R3
	MLA R0, R1, R2, R3 @ (R1 * R2) + R3, store in R0
	MOV R7, #1 @ Exit with a system call
	SWI 0 @ End program and return to terminal
	
	3. VIM Copy / Cut and Paste Line
	
		a. Put the cursor on the line to copy
		
		b. Press V to select line
		
		c. Press d to cut or y to copy
		
		d. Move to place to paste
		
		e. P to paste before cursor, or p to paste after
		
		f. u undoes previous actions
		
		g. Ctrl - R Redoes undone action
		
XI. Branching & CPSR & CMP

	1. Branch instructions allow us to execute different instructions depending upon conditions. 
	
	2. Register 15 is the program counter and it stores the address of the next instruction to execute. After an instruction executes the PC is incremented by 4 bytes because each instruction is allocated 4 bytes. We can however change how much the PC increments by and execute instructions out of order. This is known as branching. 
	
	3. Branch to a label
	.global _start
	_start:
		MOV R0, #0x14 @ Put 20 in R0
		b other @ Jump to the other label
		MOV R0, #0xB @ Put 11 in R0
	other:
		MOV R7, #1 @ Exit with a system call
		SWI 0 @ End program and return to terminal
		
	4. I mentioned the Current Program Status Register before. It stores info about your program, such as operation results. A bit is set with a 1 if conditions have occurred such as : 
	
		a. Negative Flag : Is the number negative
		
			1. BPL negclear @ Move to label negclear if result is 0
			2. BMI negset @ Move to label negset if result is set
		
		b. Zero Flag : Set if the result is 0
		
			1. BEQ zeroset @ Move if 0 set
			2. BNE zeroclear @ Move if zero flag is 0
		
		c. Carry Flag : Set if there is a carry bit
		
			1. BCS carryset @ Move if carry set
			2. BCC carryclear @ Move if carry is 0
		
		d. Overflow Flag : Set if the result overflowed into the 31st bit, which is used to signify the sign of the value
		
			1. BVS overflowset @ Move if overflow set
			2. BVC overflowclear @ Move if overflow 0
		
	5. We can compare values using CMP like this : CMP R1, R2
	
		a. Values are compared by subtracting R1 - R2. When executed we can check the CPSR flags and can conditionally execute using branching like this :
		
			1. If R2 > R1 then the Negative Flag would be enabled because the result is negative
			
			2. If R2 < R1 then the Negative Flag wouldn't be set
			
			3. If R2 == R1 then the Zero Flag would be enabled
			
		b.  
		.global _start
		_start:
			MOV R1, #5
			MOV R2, #10
			CMP R1, R2 @ Compare values setting flags
			BEQ vals_equal @ If equal jump to vals_equal (Zero Flag Set)
			BGT r1_gt @ If R1 is greater jump to r1_gt (Negative Flag Set)
			
		@ Come here next by default
		r1_lt:
			MOV R0, #2
			B end
			
		r1_gt:
			MOV R0, #3
			B end
			
		vals_equal:
			MOV R0, #1
			
		end:
			MOV R7, #1 
			SWI 0
			
			1. You can also check for
			
				a. BNE : !=
				
				b. BGE : >=
				
				c. BLE : <=
