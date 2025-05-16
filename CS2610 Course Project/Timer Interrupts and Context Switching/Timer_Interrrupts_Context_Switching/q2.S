.section .text
.global main

main:

		# Enable interrupts

		# configure timer interrupt 
		# set the value of mtimecmp register

    li t0, 0x10000
    li t1, 0x2004000
    sd t0, 0(t1)


    li t0, 0x80
    csrw mie, t0

    la t1, Task_A
    csrw mepc, t1

    la t1, initial_switch_to_B
    csrw mtvec, t1

    li t2, 0            #t2 is 0 initially

    la t1, current
    sd t2, 0(t1)         #store 0 in current means Task_A

    mret

.align 8
context_switch:

		# save the context of the interrupted task by looking at the task id (jump to relavent label)

        la t4, current
        ld t3, 0(t4)

        beqz t3, save_context_A
        j save_context_B

.align 8
save_context_A:
		# save all the registers and PC value in stack_a
		# mepc stores the value of PC at the time of interrupt

        la t3, stack_a

        csrr t4, mepc
        sd t4, 0(t3)

        sd t2, 8(t3)  #store t2 value from Task_A

        la t1, current
        li t4, 1
        sd t4, 0(t1)

        j switch_to_B

.align 8
save_context_B:
		# save all the registers and PC value in stack_b

        la t3, stack_b

        csrr t4, mepc
        sd t4, 0(t3)

        sd t2, 8(t3)  #store t2 value from Task_B

        la t1, current
        li t4, 0
        sd t4, 0(t1)
        
        j switch_to_A

.align 8
switch_to_A:
		# restore the values of registers and PC from stack_a

        la t4, stack_a
        ld t3, 0(t4)

        csrw mepc, t3

        ld t2, 8(t4)

        j switch

.align 8
switch_to_B:
		# restore the values of registers and PC from stack_b

        la t4, stack_b
        ld t3, 0(t4)

        csrw mepc, t3

        ld t2, 8(t4)

        j switch

.align 8
initial_switch_to_B:

		# switching to Task B for the first time

        la t3, stack_a

        csrr t4, mepc
        sd t4, 0(t3)

        sd t2, 8(t3)  #store t2 value from Task_A

        la t1, current
        li t4, 1
        sd t4, 0(t1)

    
        #inc mtimecmp by 10000
        li t1, 0x2004000
        ld t0, 0(t1)
        li t3, 0x10000
        add t0, t0, t3
        sd t0, 0(t1)


        la t1, Task_B
        csrw mepc, t1       #switch to Task_B

        la t1, context_switch
        csrw mtvec, t1

        li t2, 0x03fffff
        
        mret

.align 8
switch:
		# set the value of mtimecmp and switch to your preferred task

         #inc mtimecmp by 10000
        li t1, 0x2004000
        ld t0, 0(t1)
        li t3, 0x10000
        add t0, t0, t3
        sd t0, 0(t1)

        mret


.align 8
Task_A:
		# increment your reg value
        
        li a0, 0x0ffffff

        addi t2, t2, 1
        bne t2, a0, Task_A

.align 8
finish_a:
    j finish_a

.align 8
Task_B:
		# decrement the reg value

        addi t2, t2, -1
        bnez t2, Task_B
    
.align 8
finish_b:
    j finish_b

.data
.align
stack_a:  .space 64  # initialize stack for task A (You can choose a random address) 
stack_b:  .space 64  # initialize stack for task B
current:  .dword  # variable to identify the task 