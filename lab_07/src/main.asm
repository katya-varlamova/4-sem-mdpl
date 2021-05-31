org 100h
StackS SEGMENT PARA STACK 'STACK'
    DB 50h DUP(?)
StackS ENDS

DataS SEGMENT PARA PUBLIC 'DATA'
    built_in dd 0
    count db 0
    speed db 0
DataS ENDS

CodeS SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CodeS,DS:DataS,SS:StackS

keyboard_int proc 
    pushf
    push ax
    push cx

    ;call built_in - если программа с несколькими сегментами, то такой вызов не работает (так и не поняли почему)

    mov cl, count
	inc cl
	cmp cl, 18
	jne exit
	
	xor cl, cl

    mov al, 0F3h
    out 60h, al

    xor ax, ax
    mov al, speed
    inc al
    and al, 1Fh

	out 60h, al
	mov speed, al

exit:
    mov count, cl
    mov al, 20h
    out 20h, al

    pop cx
    pop ax
    popf
    
    iret
keyboard_int endp

install proc
    mov dx, ds,
    mov ax, DataS
    mov ds, ax

    mov ax, 3508h 
    int 21h ; es:bx - адрес старого обработчика (получение)

    mov di, offset ds:built_in 
    mov [di], bx
    mov [di + 2], es

    mov ax, CodeS
    mov ds, ax
    mov dx, offset keyboard_int
    mov ax, 2508h
    
    int 21h ; ds:dx - адрес нового обработчика (установка)
    mov ax, 0
    mov ds, ax



    mov cl, 4
    mov ax, offset install
    shr ax, cl
    add ax, 7

    mov dx, ax

    int 31h

    ret
install endp
;uninstall proc

;    mov ax, DataS
;    mov es, ax
;    mov es:flag, 0

;    mov dx, word ptr es:built_in
;    mov ds, word ptr es:built_in + 2
;    mov ax, 2508h
;    int 21h

;    mov ax, 4C00h
;    int 21h
;uninstall endp
main:
    jmp install

CodeS ENDS
END main
