PUBLIC unsigned_output

DataS SEGMENT PARA COMMON 'DATA'
    number LABEL word
    ORG 2h
    tmp LABEL byte
    ORG 3h
    ind LABEL byte
    ORG 4h
    flag LABEL byte
    ORG 5h
    invert LABEL byte
DataS ENDS

CodeS SEGMENT PARA PUBLIC 'CODE'
ASSUME CS:CodeS,DS:DataS
output_octal proc near
    mov dl, tmp
    add dl, '0'
    mov ah, 2
    int 21h
    ret
output_octal endp
unsigned_output proc near
    xor cx, cx
    mov flag, cl

    mov bx, number
    mov dx, 1000000000000000b
    and bx, dx
    cmp bx, dx
    je eq_lab
    jmp next_lab
    eq_lab:
        mov tmp, 1
        mov flag, 1
        mov bx, dx
        call output_octal
        mov dx, bx
    next_lab:
    shr dx, 1
    mov cx, 5
    u_output_loop:
        mov ind, cl
        mov cx, 3
        and tmp, 0

        triad_loop:
            shl tmp, 1
            mov bx, number
            and bx, dx
            cmp bx, dx
            je one
            jmp both
            one:
                add tmp, 1
            both:
            shr dx, 1
        loop triad_loop
        mov cl, ind
         
        cmp flag, 1
        je nequal_lab
            cmp tmp, 0
            jne nequal_lab
            jmp equal_lab
            nequal_lab:
            mov flag, 1
            mov bx, dx
            call output_octal
            mov dx, bx
            equal_lab:
    loop u_output_loop
    mov dl, 10
    mov ah, 2
    int 21h
    ret
unsigned_output endp 
CodeS ENDS
END