STK SEGMENT WORD 'STACK'
	db 4h
STK ENDS

Code1 SEGMENT WORD 'CODE' 
	assume CS:Code1
output:
	mov ah, 2
	mov dl, al
	int 21h
	ret
Code1 ENDS

Code2 SEGMENT WORD 'CODE' 
	assume CS:Code2
main:
	mov ah, 8
	int 21h
	call Code1:output
	mov ax, 4c00h
	int 21h
Code2 ENDS

END main
