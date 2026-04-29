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
    input_format db "%lld", 0
    input_error db "Invalid input. Please enter integers only.", 10, 0
    range_error db "Input out of 32-bit range. Exiting safely.", 10, 0
    overflow_error db "Arithmetic overflow detected. Exiting safely.", 10, 0

section .bss
    first_number resq 1
    second_number resq 1

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
    cmp eax, 1
    jne input_failed
    cmp qword [first_number], 2147483647
    jg input_out_of_range
    cmp qword [first_number], -2147483648
    jl input_out_of_range

    lea rdi, [prompt]
    mov eax, 0
    call printf

    lea rdi, [input_format]
    lea rsi, [second_number]
    mov eax, 0
    call scanf
    cmp eax, 1
    jne input_failed
    cmp qword [second_number], 2147483647
    jg input_out_of_range
    cmp qword [second_number], -2147483648
    jl input_out_of_range

    mov edi, dword [first_number]
    mov esi, dword [second_number]
    call register_adder
    jo arithmetic_overflow

    add ebx, eax
    jo arithmetic_overflow

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
    jmp finish

input_failed:
    lea rdi, [input_error]
    mov eax, 0
    call printf

    mov eax, 1
    jmp finish

input_out_of_range:
    lea rdi, [range_error]
    mov eax, 0
    call printf

    mov eax, 1
    jmp finish

arithmetic_overflow:
    lea rdi, [overflow_error]
    mov eax, 0
    call printf

    mov eax, 1

finish:
    pop r12
    pop rbx
    pop rbp
    ret

section .note.GNU-stack noalloc noexec nowrite progbits
