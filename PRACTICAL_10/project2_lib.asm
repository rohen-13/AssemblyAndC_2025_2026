; Project 2 helper routines
; Register and stack parameter passing will go here

global register_adder

section .text

register_adder:
    mov eax, edi
    add eax, esi
    ret

section .note.GNU-stack noalloc noexec nowrite progbits