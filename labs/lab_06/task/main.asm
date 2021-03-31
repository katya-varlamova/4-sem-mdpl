StackS SEGMENT PARA STACK 'STACK'
    DB 50h DUP(?)
StackS ENDS
DataS SEGMENT PARA PUBLIC 'DATA'
    number DW 0
    tmp DB 0
    ind DB 0
    flag DB 0
    invert DB 0 
    pointers DW 4 DUP (0)

DataS ENDS
CodeS SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CodeS,DS:DataS,SS:StackS
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
    ret
unsigned_output endp 
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
    ret
signed_output endp     
main:
	mov ax, DataS
	mov ds, ax
    call input 
    call signed_output
    mov ax, 4c00h
    int 21h
CodeS ENDS
END main
