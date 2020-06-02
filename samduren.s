.include "defs.h"

.section .bss
argc: .quad 0
argv: .quad 0

.section .text
.global _start

space:
.byte ' '

newline:
.byte '\n'

_start:
/*
 * Layout of arguments on stack:
 *
 *   0(%rsp)  - argc
 *   8(%rsp)  - argv[0] - name of executable
 *   ...      - argc-1 arguments
 *   NULL
 *   ...      - envp[0] - environment
 *  ...
 */
        movq (%rsp), %rbx             /* rbx = *rsp */
        movq %rbx, argc               /* argc = %rsp */
        leaq 8(%rsp), %rcx            /* rcx = rsp + 8 */
        movq %rcx, argv               /* argv = %rcx */

loop:
        movq argv, %rcx               /* rcx = argv */
        movq (%rcx), %rsi             /* rsi = *argv */
        movq %rsi, %rdi               /* rdi = rsi */
        movq $0, %rdx                 /* rdx = 0 */
strlen:
        cmpb $0, (%rdi)               /* while (*rsi != '\0') */
        je cont                       /*  {  */
        incq %rdi                     /* rdi++ */
        incq %rdx                     /* rdx++ */
        jmp strlen                    /*  }*/

cont:
        /* len is in rdx after strlen */
        /* *argv is in rsi after strlen */
        movq $SYS_WRITE, %rax
        movq $STDOUT, %rdi
        syscall

        addq $8, argv   /* argv++ (8 = pointer size) */
        decq argc       /* argc-- */

        cmpq $0, argc                 /* if argc == 0 ... */
        je end                        /*   ... goto end */

        /* write space */
        movq $SYS_WRITE, %rax
        movq $STDOUT, %rdi
        movq $space, %rsi
        movq $1, %rdx
        syscall

        jmp loop

end:
        /* write newline */
        movq $SYS_WRITE, %rax
        movq $STDOUT, %rdi
        movq $newline, %rsi
        movq $1, %rdx
        syscall

        movq $SYS_EXIT, %rax
        movq $0, %rdi
        syscall
