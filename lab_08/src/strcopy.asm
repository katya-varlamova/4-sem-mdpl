section .text
global _strc

_strc:
    pushf
    mov rcx, rdx

    cld
    cmp rsi, rdi
    je exit
    cmp rsi, rdi
    jg copy

    mov rax, rsi
    sub rax, rdi
    cmp rax, rcx
    jge copy

    add rdi, rcx
    dec rdi
    add rsi, rcx
    dec rsi
    std
    jmp copy
    
copy:
    
    rep movsb
exit:
    popf
    ret
