;王爽汇编语言(第4版)	检测点9.1 (2)

assume cs:code

data segment
	dd	12345678H
data ends

code segment
start:	mov ax,data
		mov ds,ax
		mov bx,0
		mov word ptr [bx],0
		mov [bx+2],cs
		
		jmp dword ptr ds:[0]
code ends

end start
