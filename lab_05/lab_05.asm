StackS SEGMENT PARA STACK 'STACK'
    DB 50h DUP(?)
StackS ENDS
DataS SEGMENT PARA PUBLIC 'DATA'
    maxind DB 0
    minind DB 0
    max DB 0
    min DB 0
    n DB 0
    m DB 0
    matrix DB 81 DUP (0)
    
DataS ENDS
CodeS SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CodeS,DS:DataS,SS:StackS
input proc near
    mov ax, DataS
    mov ds, ax
    
    mov ah, 1
    int 21h
    mov n, al
    sub n, '0'
    
    mov dl, ' '
    mov ah, 2
    int 21h
    
    mov ah, 1
    int 21h
    mov m, al
    sub m, '0'
    
    mov dl, 10
    mov ah, 2
    int 21h
    
    xor bx, bx
    xor cx, cx
    xor dx, dx
    mov cl, n
    matrix_input:
        mov dh, cl
        xor cx, cx
        mov cl, m
        row_input:
            mov ah, 1
            int 21h
            sub al, '0'
            
            mov matrix[bx], al
            inc bl
            
            mov dl, ' '
            mov ah, 2
            int 21h
        loop row_input
        mov dl, 10
        mov ah, 2
        int 21h
        xor cx, cx
        mov cl, dh
        
        ;xor bx, bx
        ;mov bl, cl
        ;dec bl
        ;neg bl
        ;add bl, n
        ;mov al, 9
        ;mul bl
        ;mov bl, al
        
    loop matrix_input
    ret
input endp
output proc near
    xor bx, bx
    xor cx, cx
    xor dx, dx
    mov cl, n
    matrix_output:
        mov dh, cl
        xor cx, cx
        mov cl, m
        row_output:
            mov dl, '0'
            add dl, matrix[bx]
            inc bx
            mov ah, 2
            int 21h
            
            mov dl, ' '
            mov ah, 2
            int 21h
        loop row_output
        mov dl, 10
        mov ah, 2
        int 21h
        xor cx, cx
        mov cl, dh
        
    loop matrix_output
    ret
output endp

replace_max proc near
    mov max, dl
    mov maxind, dh
    ret
replace_max endp

findsummax proc near
    mov dh, bl
    mov cl, n
    xor dl, dl
    col_max:
        add dl, matrix[bx]
        add bl, m
    loop col_max
    cmp max, dl
    jl replace_max
    ret
findsummax endp

findmax proc near
    mov ah, 0
    mov max, ah
    
    xor ax, ax
    xor cx, cx
    xor bx, bx
    xor dx, dx
    
    mov cl, m
    findmax_matrix:
        mov bl, cl
        neg bl
        add bl, m
        mov al, cl
        call findsummax
        mov cl, al
    loop findmax_matrix
    ret
findmax endp

replace_min proc near
    mov min, dl
    mov minind, dh
    ret
replace_min endp

findsummin proc near
    mov dh, bl
    mov cl, n
    xor dl, dl
    col_min:
        add dl, matrix[bx]
        add bl, m
    loop col_min
    cmp dl, min
    jl replace_min
    ret
findsummin endp

findmin proc near
    mov ah, 82
    mov min, ah
    
    xor ax, ax
    xor cx, cx
    xor bx, bx
    xor dx, dx
    
    mov cl, m
    findmin_matrix:
        mov bl, cl
        neg bl
        add bl, m
        mov al, cl
        call findsummin
        mov cl, al
    loop findmin_matrix
    ret
findmin endp
swap_cols proc near
    xor cx, cx
    xor bx, bx
    xor ax, ax
    mov cl, n
    swap_loop:
        mov bl, minind
        mov al, matrix[bx]
        mov bl, maxind
        mov ah, matrix[bx]
        xchg ah, al
        mov bl, minind
        mov matrix[bx], al
        mov bl, maxind
        mov matrix[bx], ah
        
        mov dl, minind
        add dl, m
        mov minind, dl
        
        mov dl, maxind
        add dl, m
        mov maxind, dl
        
    loop swap_loop
    ret
swap_cols endp
main:
    call input
    call findmax
    call findmin
    call swap_cols
    call output
    mov ax, 4c00h
    int 21h
CodeS ENDS
END main
