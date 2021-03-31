PUBLIC input

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
input proc near
    xor cx, cx
    xor bx, bx
    xor ax, ax
    mov number, ax
    mov invert, al
    mov cx, 16
    input_loop:
        mov ah, 1
        int 21h

        cmp al, 13
        je end_input_loop

        cmp al, '-'
        je equal
        jmp next
        equal:
            mov dl, 1
            mov invert, dl
            jmp continue
        next:    

        sub al, '0'
        shl number, 1
        xor ah, ah
        add number, ax
    continue:
    loop input_loop
end_input_loop:
    cmp invert, 1
    je inv
    jmp end_input
    inv:
        mov dx, number
        neg dx
        mov number, dx

    end_input:
    ret
input endp
CodeS ENDS
END