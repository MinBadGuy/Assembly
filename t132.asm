;王爽汇编语言(第4版)	实验13(2)

assume cs:code, ds:data, ss:stack

data segment
	db "welcome to masm!",0
data ends

stack segment
	db 128 dup(0)
stack ends

code segment
start:	mov ax,stack
		mov ss,ax
		mov sp,128		;设置栈空间

		call cpy_int7ch
		call set_int7ch

		mov ax,0b800h
		mov es,ax
		mov di,160*12
		mov bx,offset s - offset se		;设置从标号se到标号s的转移位移
		
		mov cx,80
		
	s:	mov byte ptr es:[di],'!'
		mov byte ptr es:[di+1],00000010B	;绿色
		add di,2
		int 7ch
	se:	nop
		
		mov ax,4c00h
		int 21h

;===============================================================
;设置中断向量表
set_int7ch:	mov ax,0
			mov es,ax
			mov word ptr es:[4*7ch],200h
			mov word ptr es:[4*7ch+2],0
			ret

;===============================================================
;安装程序，将中断处理程序拷贝至 0:200 处
cpy_int7ch:	mov ax,cs
			mov ds,ax
			mov si,offset new_int7ch
			
			mov ax,0
			mov es,ax
			mov di,200h
			
			mov cx,offset new_int7ch_end - offset new_int7ch
			cld
			rep movsb
			
			ret
			
;===============================================================
;int 7ch中断处理程序
new_int7ch:		mov bp,sp
				dec cx
				jcxz ok
				add ss:[bp],bx			
			ok:	iret
new_int7ch_end:	nop
			
code ends

end start