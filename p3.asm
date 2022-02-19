;王爽汇编语言(第4版)	程序5.3

assume cs:code

code segment
	mov ax,0ffffh	;汇编源程序中，数据不能以字母开头，所有加0
	mov ds,ax
	mov bx,6

	mov al,[bx]
	mov ah,0

	mov dx,0
	mov cx,3
s:	add dx,ax
	loop s

	mov ax, 4c00H	
	int 21h

code ends

end

