; Project 2 main program
; 68000 to x86_64 conversion

global main
extern printf

section .data
    prompt db "Enter number: ", 0
    result db "The sum is: ", 0
    final_result db "Final sum is: ", 0

section .text

main:
    mov ebx, 0
    mov ecx, 3

game_loop:
    lea rdi, [prompt]
    mov eax, 0
    call printf

    mov eax, 0
    ret

section .note.GNU-stack noalloc noexec nowrite progbits
