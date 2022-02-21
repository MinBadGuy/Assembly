;王爽汇编语言(第4版)	检测点13.1 (2)

assume cs:code

data segment
	db	'conversation',0
data ends

stack segment
	db	128 dup(0)
stack ends

code segment
start:	
		mov ax,stack
		mov ss,ax
		mov sp,128
		
		call cpy_int7c
		call set_int7c
		
		mov ax,data
		mov ds,ax
		mov si,0
		mov ax,0b800h
		mov es,ax
		mov di,12*160

	s:	cmp byte ptr [si],0
		je ok				;如果是0跳出循环
		mov al,[si]
		mov ah,00000100B	;红色
		mov es:[di],ax
		inc si
		add di,2
		mov bx,offset s - offset ok
		int 7ch
		
	ok:	mov ax,4c00h
		int 21h

;==================================================
;设置中断向量
set_int7c:	mov ax,0
			mov es,ax
			mov word ptr es:[7ch*4],200h
			mov word ptr es:[7ch*4+2],0
			
			ret

;==================================================
;中断安装程序
cpy_int7c:	mov ax,cs
			mov ds,ax
			mov si,offset new_int7c	;设置ds:si指向源程序
			
			mov ax,0
			mov es,ax
			mov di,200h				;设置es:di指向目的地址
			
			mov cx, offset new_int7c_end - offset new_int7c	;设置cx为传输长度
			cld						;设置传输方向为正
			rep movsb
			
			ret

;==================================================
;7ch中断处理程序
new_int7c:		push bp
				mov bp,sp
				add ss:[bp+2],bx
				pop bp
				
				iret
new_int7c_end:	nop
	
code ends

end start