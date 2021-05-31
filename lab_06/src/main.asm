EXTRN input:near
EXTRN unsigned_output:near
EXTRN signed_output:near

StackS SEGMENT PARA STACK 'STACK'
    DB 50h DUP(?)
StackS ENDS

DataS SEGMENT PARA COMMON 'DATA'
    number DW 0
    tmp DB 0
    ind DB 0
    flag DB 0
    invert DB 0 
    pointers DW 3 DUP (0)
    menu DB 0Dh, 0Ah, 
    'choose action:', 0Dh, 0Ah, 
    '0 - input', 0Dh, 0Ah, 
    '1 - output in unsigned octal', 0Dh, 0Ah, 
    '2 - output in signed hex', 0Dh, 0Ah, 
    'any other to exit', 0Dh, 0Ah, 
    '$' 
DataS ENDS

CodeS SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CodeS,DS:DataS,SS:StackS
print_menu proc near
    mov dx, offset menu
    mov ah, 9
    int 21h
    ret
print_menu endp
input_sym proc near
    mov ah, 1
    int 21h
    xor ah, ah
    ret
input_sym endp
output_nexl proc near
    mov dl, 10
    mov ah, 2
    int 21h
    ret
output_nexl endp 
main:
	mov ax, DataS
	mov ds, ax
    mov bx, 0
    mov pointers[bx], input
    add bx, 2
    mov pointers[bx], unsigned_output
    add bx, 2
    mov pointers[bx], signed_output
main_loop:
    call print_menu
    xor ax, ax
    call input_sym
    cmp ax, '0'
    jl exit_lab
    cmp ax, '2'
    jg exit_lab

    sub ax, '0'
    mov bx, ax
    xor ax, ax
    mov al, 2
    mul bl
    mov bx, ax
    call output_nexl
    call pointers[bx]
    mov cx, 2
    loop main_loop
exit_lab:
    mov ax, 4c00h
    int 21h
CodeS ENDS
END main
