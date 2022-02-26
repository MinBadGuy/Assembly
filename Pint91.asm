;王爽汇编语言(第4版)	15.4 编写int9中断例程

assume cs:code

stack segment
	db 128 dup (0)
stack ends

data segment
	dw 0,0
data ends

code segment
start:	mov ax,stack
		mov ss,ax
		mov sp,128
		
		mov ax,data
		mov ds,ax
		
		mov ax,0
		mov es,ax
		
		push es:[9*4]
		pop ds:[0]
		push es:[9*4+2]
		pop ds:[2]			;将原来的int 9中断例程的入口地址保存在ds:0, ds:2单元中
		
		mov word ptr es:[9*4], offset int9
		mov word ptr es:[9*4+2],cs		;在中断向量表中设置新的int 9中断例程的入口地址
		
		mov ax,0b800h
		mov es,ax
		
		mov ah,'a'
s:		mov es:[160*12+40*2],ah
		call delay
		inc ah
		cmp ah,'z'
		jna s
		
		mov ax,0
		mov es,ax
		
		push ds:[0]
		pop es:[9*4]
		push ds:[2]
		pop es:[9*4+2]		;将中断向量表中int 9中断例程的入口回复为原来的地址
		
		mov ax,4c00h
		int 21h
		
;============================================
;延时函数
delay:	push ax
		push dx
		mov dx,10h
		mov ax,0
s1:		sub ax,1
		sbb dx,0
		cmp ax,0
		jne s1
		cmp dx,0
		jne s1
		pop dx
		pop ax
		ret

;============================================
;新int 9中断例程
int9:	push ax
		push bx
		push es
		
		in al,60h		;从端口60h读取键盘扫描码
		
		pushf			;标志寄存器入栈
		
		pushf
		pop bx
		and bh,11111100B
		push bx
		popf			;TF、IF置0
		
		call dword ptr ds:[0]	;对int 9指令进行模拟，调用原来的int 9中断例程
		
		cmp al,1
		jne int9ret
		
		mov ax,0b800h
		mov es,ax
		inc byte ptr es:[160*12+40*2+1]		;将属性值加1，改变颜色

int9ret:	pop es
			pop bx
			pop ax
			
			iret
			
code ends
end start
