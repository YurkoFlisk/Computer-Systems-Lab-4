.include "defs.h"

.section .text
.global _start

newline:
.byte '\n'

_start:
    // argc зберігається в rbx
    movq (%rsp), %rbx             /* rbx = *rsp */
    // після обрахунку адреси envp, з якої починаються змінні оточення, argc вже
    // не буде потрібен, тому можемо перевикористати rbx для її збереження
    leaq 16(%rsp, %rbx, 8), %rbx  /* rbx = %rsp + 8 * (%rbx + 2) = %rsp + %rbx * 8 + 16 */

loop:
    // Зберігатимемо p_start = *env_p в rsi
    movq (%rbx), %rsi              /* rsi = *rbx */
    // Зберігатимемо len в rdx
    xorq %rdx, %rdx                /* rdx = 0 */
    // Зберігатимемо p = p_start в r13
    movq %rsi, %r13                /* r13 = r12 */

    cmpq $0, %rsi                  /* while (rsi != NULL) */
    je end

strlen:
    cmpb $0, (%r13)                /* while (*r13 != '\0') */
    je out

    incq %r13                      /* r13++ */
    incq %rdx                      /* rdx++ */
    jmp strlen

out:
    // вивести поточну змінну оточення з *env_p
    // rsi уже містить *env_p
    // rdx уже містить len
    movq $SYS_WRITE, %rax
    movq $STDOUT, %rdi
    syscall

    // вивести новий рядок
    movq $SYS_WRITE, %rax
    movq $STDOUT, %rdi
    movq $newline, %rsi
    movq $1, %rdx
    syscall

    addq $8, %rbx
    jmp loop

end:
    movq $SYS_EXIT, %rax           /* rax = SYS_EXIT */
    xorq %rdi, %rdi                /* rdi = 0 */
    syscall
