; Project 2 main program
; 68000 to x86_64 conversion

global main
extern printf
extern scanf

section .data
    prompt db "Enter number: ", 0
    result db "The sum is: ", 0
    final_result db "Final sum is: ", 0
    input_format db "%d", 0

section .bss
    first_number resd 1
    second_number resd 1

section .text

main:
    push rbp
    mov rbp, rsp

    mov ebx, 0
    mov ecx, 3

game_loop:
    lea rdi, [prompt]
    mov eax, 0
    call printf

    lea rdi, [input_format]
    lea rsi, [first_number]
    mov eax, 0
    call scanf

    lea rdi, [prompt]
    mov eax, 0
    call printf

    lea rdi, [input_format]
    lea rsi, [second_number]
    mov eax, 0
    call scanf

    mov eax, 0
    pop rbp
    ret

section .note.GNU-stack noalloc noexec nowrite progbits
