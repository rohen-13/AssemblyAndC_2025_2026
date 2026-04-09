global sub

section .data
section .text
sub:
    mov   eax, [esp+4]      ; argument 1
    sub   eax, [esp+8]      ; subtract argument 2
    ret