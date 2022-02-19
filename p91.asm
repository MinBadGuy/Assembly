;王爽汇编语言(第4版)	程序9.1

assume cs:codesg

codesg segment
start:
	mov ax,0
	jmp short s
	add ax,1
s:	inc ax
codesg ends

end start