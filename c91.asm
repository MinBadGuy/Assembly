;王爽汇编语言(第4版)	检测点9.1 (1)

assume cs:code

data segment
	db	0
	;dw	0
	dw	offset start
data ends

code segment
start:	mov ax,data
		mov ds,ax
		mov bx,0
		
		jmp word ptr [bx+1]
code ends

end start