#==============================================================================
# FILE:         mergesort.s (PA #1)
#------------------------------------------------------------------------------
# Description:  Skeleton for assembly mergesort routine. 
# 		To complete this assignment, add the following functionality:
#
#		1. Call mergesort. (See mergesort.c)
#		   Pass 3 arguments:
#
#		   ARG 1: Pointer to the first element of the array
#		   (referred to as "a" in the C code)
#
#		   ARG 2 & 3: Left and right array indices that demarcate
#                  the portion of the array that is to be sorted.
#                  (referred to as "lt" and "rt" in the C code)
#
#                  Remember to use the correct CALLING CONVENTIONS !!!
#                  Pass all arguments in the conventional way!
#
# 		2. Mergesort routine.
#		   The routine is recursive by definition, so mergesort MUST 
#		   call itself.
#		   Again, make sure that you use the correct calling 
#                  conventions!
#
#		3. Print results.
#                  Print out the results in the prescribed format. We will be 
#                  using a script to test your programs ... so it is 
#                  essential that you follow this format: 
#                  List the sorted elements on a SINGLE line. 
#                  Place ONE space between each printed integer.
#		   Place a single return character at the end of the list.
#
#==============================================================================


		.data
HOW_MANY:	.asciiz "How many elements to be sorted?"
ENTER:		.asciiz "Enter next element:"
ANS:		.asciiz "The sorted list is:"
SPACE:		.asciiz " "			# Space
EOL:		.asciiz "\n"			# Return character


		.text
		.globl main


#==========================================================================
main:
#==========================================================================

		#----------------------------------------------------------
		# Register Definitions
		#----------------------------------------------------------
		# $s0 - pointer to the first element of the array
		# $s1 - number of elements in the array
		# $s2 - number of bytes in the array
		#----------------------------------------------------------

		#---- Store the old values into stack ---------------------
		addiu	$sp, $sp, -32		# Stack frame 32 bytes long
		sw	$ra, 16($sp)		# Store return address
		sw	$fp, 12($sp)		# Store frame pointer
		sw	$s0,  8($sp)
		sw	$s1,  4($sp)
		sw	$s2,  0($sp)
		addiu	$fp, $sp, 28		# Set up new frame pointer

		#---- Prompt user for array size --------------------------
		li	$v0, 4			# print_string
		la	$a0, HOW_MANY		# text to be displayed
		syscall			
		li	$v0, 4
		la	$a0, EOL
		syscall				# print "\n"
		li	$v0, 5			# read_int
		syscall	
		move	$s1, $v0		# save number of elements

		#---- Create dynamic array --------------------------------
		li	$v0, 9
		sll	$s2, $s1, 2		# number of bytes needed
		move	$a0, $s2		# set up the argument for sbrk
		syscall
		move	$s0, $v0		# the addr of allocated memory

		#---- Prompt user for array elements ----------------------
		addu	$t2, $s0, $s2		# addr of the last element
		move	$t0, $s0
		j	END1
LOOP1:		li	$v0, 4			# print_string
		la		$a0, ENTER		# text to be displayed
		syscall
		li		$v0, 4
		la		$a0, EOL
		syscall					# print "\n"
		li		$v0, 5			# read_int
		syscall
		sw		$v0, 0($t0)		
		addiu	$t0, $t0, 4
END1:		bne	$t2, $t0, LOOP1 

		#---- Call mergesort ---------------------------------------
		move	$a0, $s0	# 1st param is base of array
		move	$a1, $zero	# 2nd param is zero
		addiu	$a2, $s1, -1	# 3rd param is total elems - 1
		jal mergesort		# call mergesort

		#---- Print sorted array -----------------------------------
		li		$v0, 4		# print_string
		la		$a0, ANS	# text: "The sorted list is:"
		syscall
		li		$v0, 4		# print_string
		la		$a0, EOL	# text
		syscall

		#------------------------------------
		#---- Beginning of aigeanta code ----
		#------------------------------------

		move	$s2, $zero		# i = 0
PRINTLOOP:
		bge		$s2, $s1, PRINTEXIT		# while (i < array_size) {
		li		$v0, 1			# print_int
		sll 	$t1, $s2, 2		# i * sizeof(int)
		add 	$t1, $s0, $t1	# &nums[i]
		lw		$a0, 0($t1)		# nums[i]
		syscall
		li 		$v0, 4			# print_string
		la 		$a0, SPACE		# text
		syscall
		addiu	$s2, 1			# i++
		j PRINTLOOP
PRINTEXIT:
		li		$v0, 4			# print_string
		la		$a0, EOL		# text
		syscall

		#------------------------------
		#---- End of aigeanta code ----
		#------------------------------

		#---- Restore the old values from the stack ----------------
		lw	$s2,  0($sp)
		lw	$s1,  4($sp)
		lw	$s0,  8($sp)
		lw	$fp, 12($sp)
		lw	$ra, 16($sp)
		addiu	$sp, $sp, 32		# stack frame 32 bytes long

		#---- Exit -------------------------------------------------
		jr	$ra



#--------------------------------------------------------------------------
mergesort:
#--------------------------------------------------------------------------

       #---- Store the old values into stack ---------------------
        addiu   $sp, $sp, -32	# Stack frame 32 bytes long
        sw		$ra,  24($sp)	# Store return address
        sw		$fp,  20($sp)	# Store frame pointer
        sw		$s0,  16($sp)
        sw		$s1,  12($sp)
        sw		$s2,  8($sp)
        sw		$s3,  4($sp)
        sw		$s4,  0($sp)
        addiu   $fp, $sp, 28	# Set up new frame pointer

		# store params
		move	$s0, $a0		# $s0 = a
		move	$s1, $a1		# $s1 = lt
		move	$s2, $a2		# $s2 = rt

        #---- Create dynamic array --------------------------------
        li		$v0, 9			# sbrk
        addiu   $t0, $s2, 1		# rt + 1
        sll     $t0, $t0, 2		# (rt + 1) * sizeof(int)
        move    $a0, $t0        # set up the argument for sbrk
        syscall
        move    $s3, $v0        # $s3 = b

		ble		$s2, $s1, SORTEXIT		# if (rt <= lt) return
		add		$t0, $s1, $s2	# rt + lt
		sra		$s4, $t0, 1		# $s4 = mid = (rt + lt) / 2
		
		move	$a0, $s0		# set up params
		move	$a1, $s1
		move	$a2, $s4
		jal	mergesort			# mergesort(a, lt, mid)

        move    $a0, $s0		# set up params
		addiu	$a1, $s4, 1
		move	$a2, $s2
		jal mergesort			# mergesort(a, mid + 1, rt)

		move	$t0, $s1		# i = lt
SORTLOOP1:
		bgt		$t0, $s4, SORTLOOPEND1	# while (i <= mid) {
		sll		$t1, $t0, 2		# i * sizeof(int)
		add		$t2, $s0, $t1	# &a[i]
		add		$t3, $s3, $t1	# &b[i]
		lw		$t4, 0($t2)		# a[i]
		sw		$t4, 0($t3)		# b[i] = a[i]
		addiu	$t0, $t0, 1		# i++
		j SORTLOOP1				# }
SORTLOOPEND1:
		addiu	$t0, $s4, 1		# j = mid + 1
SORTLOOP2:
		bgt		$t0, $s2, SORTLOOPEND2	# while (j <= rt) {
		sll		$t1, $t0, 2		# j * sizeof(int)
		add		$t1, $t1, $s3	# &b[j]

		add		$t2, $s2, $s4	# rt + mid
		addiu	$t2, $t2, 1		# rt + mid + 1
		sub		$t2, $t2, $t0	# rt + mid + 1 - j
		sll		$t2, $t2, 2		# * sizeof(int)
		add		$t2, $t2, $s0	# &a[rt + mid + 1 - j]
		lw		$t3, 0($t2)		# a[rt + mid + 1 - j]
		sw		$t3, 0($t1)		# b[j] = a[rt + mid + 1 - j]
		addiu	$t0, $t0, 1		# j++
		j SORTLOOP2				# }
SORTLOOPEND2:

		sll		$t0, $s1, 2		# i = lt * sizeof(int)
		add		$t0, $t0, $s3	# &b[i]
		sll		$t1, $s2, 2		# j = rt * sizeof(int)
		add		$t1, $t1, $s3	# &b[j]
		move	$t2, $s1		# k = lt
SORTLOOP3:
		bgt		$t2, $s2, SORTLOOPEND3	# while (k <= rt) {
		lw		$t5, 0($t0)		# b[i]
		lw		$t6, 0($t1)		# b[j]
		bge		$t5, $t6, TESTLABEL1	# if (b[i] < b[j]) {
		move	$t3, $t5		# temp = b[i]
		addiu	$t0, $t0, 4		# &b[++i]
		j TESTLABEL2			# } else {
TESTLABEL1:
		move	$t3, $t6		# temp = b[j]
		addiu	$t1, $t1, -4	# &b[--j]
TESTLABEL2:						# }
		sll		$t4, $t2, 2		# k * sizeof(int)
		add		$t4, $t4, $s0	# &a[k]
		sw		$t3, 0($t4)		# a[k] = temp
		addiu	$t2, $t2, 1		# k++
		j SORTLOOP3				# }
SORTLOOPEND3:

SORTEXIT:

        #---- Restore the old values from the stack ----------------
		lw 		$s4, 0($sp)
		lw		$s3, 4($sp)
		lw		$s2, 8($sp)
        lw		$s1, 12($sp)
        lw		$s0, 16($sp)
        lw		$fp, 20($sp)
        lw 		$ra, 24($sp)
        addiu	$sp, $sp, 32        # stack frame 32 bytes long
        #---- Exit -------------------------------------------------
        jr		$ra

