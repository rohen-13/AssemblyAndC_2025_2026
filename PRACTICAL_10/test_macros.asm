; Assembly macro tests for Project 2
; Inspired by small NASM xUnit-style tests.

global main
extern printf
extern register_adder

%macro assert_equals 2
    cmp %1, %2
    je %%passed
    lea rdi, [failed_message]
    mov eax, 0
    call printf
    mov eax, 1
    jmp finish
%%passed:
%endmacro

section .data
    passed_message db "All assembly macro tests passed.", 10, 0
    failed_message db "Assembly macro test failed.", 10, 0

section .text

main:
    push rbp
    mov rbp, rsp

    mov edi, 7
    mov esi, 5
    call register_adder
    assert_equals eax, 12

    mov edi, -3
    mov esi, 10
    call register_adder
    assert_equals eax, 7

    mov edi, -5
    mov esi, 9
    call register_adder
    assert_equals eax, 4

    lea rdi, [passed_message]
    mov eax, 0
    call printf

    mov eax, 0

finish:
    pop rbp
    ret

section .note.GNU-stack noalloc noexec nowrite progbits
