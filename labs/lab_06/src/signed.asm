PUBLIC signed_output

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
output_hex proc near
    cmp tmp, 9
    jg out_sym
        mov dl, tmp
        add dl, '0'
        jmp both_hex
    out_sym:
        mov dl, tmp
        sub dl, 10
        add dl, 'A'
    both_hex:
    mov ah, 2
    int 21h
    ret
output_hex endp
signed_output proc near
    xor cx, cx
    mov flag, cl

    mov bx, number
    mov dx, 1000000000000000b
    and bx, dx
    cmp bx, dx
    je eq_lab_hex
    jmp next_lab_hex
    eq_lab_hex:
        neg number
        mov bx, dx
        mov dl, '-'
        mov ah, 2
        int 21h
        mov dx, bx
    next_lab_hex:
    mov cx, 4
    s_output_loop:
        mov ind, cl
        mov cx, 4
        and tmp, 0

        tetrad_loop:
            shl tmp, 1
            mov bx, number
            and bx, dx
            cmp bx, dx
            je one_hex
            jmp next_hex
            one_hex:
                add tmp, 1
            next_hex:
            shr dx, 1
        loop tetrad_loop
        mov cl, ind

        cmp flag, 1
        je nequal_lab_hex
            cmp tmp, 0
            jne nequal_lab_hex
            jmp equal_lab_hex
            nequal_lab_hex:
            mov flag, 1
            mov bx, dx
            call output_hex
            mov dx, bx
        equal_lab_hex:
    loop s_output_loop
    mov dl, 10
    mov ah, 2
    int 21h
    ret
signed_output endp     
CodeS ENDS
END