;王爽汇编语言(第4版)	实验13(1)

assume cs:code, ds:data, ss:stack

data segment
	db "welcome to masm!",0
data ends

stack segment
	db 128 dup(0)
stack ends

code segment
start:	
	mov ax,stack
	mov ss,ax
	mov sp,128		;设置栈空间

	call cpy_int7ch
	call set_int7ch

	mov dh,10
	mov dl,10
	mov cl,2
	mov ax,data
	mov ds,ax
	mov si,0
	
	call init_di
	
	int 7ch
	
	mov ax,4c00h
	int 21h

;===============================================================
;初始化di
init_di:	
			
			mov ax,0b800h
			mov es,ax
			mov al,160
			mul dh
			mov di,ax
			mov al,2
			mul dl
			add di,ax		;根据行号、列号设置di
							;es:di指向显存
			
			ret

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
new_int7ch:		
	showStr:	mov al,ds:[si]
				cmp al,0
				je ok
				mov ah,cl
				mov es:[di],ax
				inc si
				add di,2
				jmp showStr
		ok:		iret
new_int7ch_end:	nop
			
code ends

end start