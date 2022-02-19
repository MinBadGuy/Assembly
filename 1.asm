;王爽汇编语言(第4版)	程序4.1

assume cs:codeseg

codeseg segment

	mov ax, 0123H
	mov bx, 0456H
	add ax, bx
	add ax, ax

	mov ax, 4c00H
	int 21H

codeseg ends

end
