XXVIII. Floating Point Numbers

	1. The use of floating point numbers is provided by the Vector Floating Point (VFP) coprocessor. The VFP provides single precision (32 bit) and double precision (64 bit) for floating point numbers. 
	
	2. Floats start with a positive (0) or negative (1) bit that represents the sign.
	
	3. Bits 30 through 23 represent the exponent 
	
	4. (SLIDE) Bits 22 through 0 represent the fraction. This is referred to as the Mantissa. Just like we can have 0.40625 we can calculate the IEEE format binary
	
		a. .40625 * 2 = 0.8125 (0)
		b. .8125 * 2 = 1.625 (1)
		c. .625 * 2 = 1.25 (1)
		d. .25 * 2 = 0.5 (0)
		e. .5 * 2 = 1 (1)
		f. So .40625 == .01101
		g. Normalize 0.01101 = 1.101 (-2)
		h. Exponent is 127 - 2 = 125 (01111101)
		i. It is positive so the first bit it 0
		j. .40625 = 0 01111101 10100000000000000000000 B
	
	5. (SLIDE) We can't store floats in R0 - R15 so the VFP provides registers S0 - S31 for single precision and D0 - D15 for double precision. Each Dn is mapped to 2 Sn registers
	
	6. @ Print Pi
	@ Used by the compiler to tell libc where main is located
	.global main
	.func main
	
	main:
		LDR R1, addr_pi @ Get the address associated with Pi
		
		@ There are 32 Sx registers for storing floats
		@ Store the value of R1 in a word
		VLDR S0, [R1] @ Move Pi value into S0
		
		@ VCVT is used to convert between floats and integers
		@ This converts to B64 because printf requires a 
		@ double precision value
		@ F64 - Convert to Binary 64
		@ F32 - From Binary 32
		@ D5 - Store in double precision register
		@ S14 - From the current single precision register
		VCVT.F64.F32 D1, S0
		
		LDR R0, =output @ Point to the string
		
		@ Insert the floating point value in R2 and R3 to hold
		@ the double precision value
		VMOV R2, R3, D1
		
		@ When printf is called for a float it looks for the value
		@ in registers R2 and R3
		BL printf @ Print the string
		
	end:
		MOV R7, #1
		SWI 0
		
	addr_pi:
		.word pi
		
	.data
	pi: .float 3.141592
	output: .asciz "The value of Pi is %f\n"
	
	@ Define we want to use printf
	.global printf
	
	7. When performing arithmetic 2 modes are used.
	
		a. Scalar : Used when the destination is in S0 - S7 or D0 - D3. 
		
		b. Vector : The operation operates with registers wrapping from the first to others in the bank
		
	8. Adding floats
	.global main
	.func main
	
	main:
		@ Store float in S0
		LDR R1, addr_num_1
		VLDR S0, [R1]
		
		@ Store float in S1
		LDR R2, addr_num_2
		VLDR S1, [R2]
		
		@ Add floats use f32 for single and f64 for double precision
		@ Also VSUB, VMUL, VDIV, VABS, VSQRT
		VADD.f32 S2, S0, S1
		
		@ Convert for double precision for printf
		VCVT.F64.F32 D1, S2
		
		@ Set the output
		LDR R0, =output
		
		@ Move into proper registers for printf
		VMOV R2, R3, D1
		
		BL printf

	end:
		MOV R7, #1
		SWI 0
		
	addr_num_1: .word num_1
	addr_num_2: .word num_2
		
	.data
		num_1: .float 1.2345
		num_2: .float 1.1111
		output: .asciz "1.2345 + 1.1111 = %f\n"
	
	.global printf
		
	9. The VFP has its own version of CPSR, called the FPSCR, that provides the flags N, Z, C and V. We can use them for conditional execution.
	
	10. Demonstrate comparing floats
	.global main
	.func main
	main:
		LDR R1, addr_num_1
		VLDR S0, [R1]
		
		LDR R2, addr_num_2
		VLDR S1, [R2]
		
		@ Compare values and set flags
		VCMP.F32 S0, S1
		
		@ Copy flags to the ARM status register 
		VMRS APSR_nzcv, FPSCR
		
		@ Conditionally assign a value
		@ Also you can check LT, GT, LE, GE
		MOVEQ R1, #1
		MOVNE R1, #0
		
		@ Set the output
		LDR R0, =output
		
		BL printf
		
	end:
		MOV R7, #1
		SWI 0
		
		addr_num_1: .word num_1
		addr_num_2: .word num_2
		
	.data
	num_1: float 1.234
	num_2: float 5.678
	output: .asciz "Are numbers equal : %d\n"
	
	.global printf
	
XXIX. Switch

	1. Implement a switch statement in assembler
	.global main
	.func main
	main:
		MOV R2, #1
		
		CMP R2, #0
		BEQ case_0
		
		CMP R2, #1
		BEQ case_1
		
		B case_def
		
	case_0:
		LDR R0, =output_0
		B end
		
	case_1:
		LDR R0, =output_1
		b end
		
	case_def:
		LDR R0, =output_def
	
	end:
		BL puts
		MOV R7, #1
		SWI 0
		
	.data
	output_0: .asciz "It's 0"
	output_1: .asciz "It's 1"
	output_def: .asciz "I don't know what it is"
		
	.global puts
