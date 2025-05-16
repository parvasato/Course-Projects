.section .text
.global main

main:

    li t0, 0x10000
    li t1, 0x2004000
    sd t0, 0(t1)


    li t0, 0x80
    csrw mie, t0

    la t1, user
    csrw mepc, t1

    la t1, mtrap
    csrw mtvec, t1


    mret

.align 8
mtrap:

    li t1, 0x2004000
    ld t0, 0(t1)

    li t2, 0x10000

    add t0, t0, t2
    sd t0, 0(t1)

    mret

.align 8
user:

    j user


    