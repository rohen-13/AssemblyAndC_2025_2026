; Project 2 main program
; 68000 to x86_64 conversion

global main
extern printf
extern scanf
extern register_adder

section .data
    prompt db "Enter number: ", 0
    result db "The sum is: %d", 10, 0
    final_result db "Final sum is: %d", 10, 0
    input_format db "%d", 0

section .bss
    first_number resd 1
    second_number resd 1

section .text

main:
    push rbp
    mov rbp, rsp
    push rbx
    push r12

    mov ebx, 0
    mov r12d, 3

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

    mov edi, [first_number]
    mov esi, [second_number]
    call register_adder

    add ebx, eax

    lea rdi, [result]
    mov esi, eax
    mov eax, 0
    call printf

    sub r12d, 1
    jne game_loop

    lea rdi, [final_result]
    mov esi, ebx
    mov eax, 0
    call printf

    mov eax, 0
    pop r12
    pop rbx
    pop rbp
    ret

section .note.GNU-stack noalloc noexec nowrite progbits
