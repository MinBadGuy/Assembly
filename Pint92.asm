;王爽汇编语言(第4版)	15.5 安装新的int9中断例程

assume cs:code

stack segment
	db 128 dup (0)
stack ends

code segment
start:	mov ax,stack
		mov ss,ax
		mov sp,128
		
		push cs
		pop ds
		
		mov ax,0
		mov es,ax
		
		mov si,offset int9					;设置ds:si指向源地址
		mov di,204h							;设置ds:di指向目的地址
		mov cx,offset int9end - offset int9	;设置cx为传输长度
		cld									;设置传输方向为正
		rep movsb
		
		;保存原中断例程入口地址至 0:200h 处
		push es:[9*4]
		pop es:[200h]
		push es:[9*4+2]
		pop es:[202h]
		
		cli							;设置IF=0，屏蔽外中断
		mov word ptr es:[9*4],204h	;设置中断向量表，int 9中断例程的新地址为 0:204h
		mov	word ptr es:[9*4+2],0
		sti							;设置IF=1，开启外中断
		
show:	nop
		jmp	show
		
		mov ax,4c00h
		int 21h
		
;======================================================================================
int9:	push ax
		push bx
		push cx
		push es
		
		in al,60h		;读取键盘输入
		
		pushf
		call dword ptr cs:[200h]	;当此中断例程执行时(cs)=0
		
		cmp al,3bh		;F1的扫描码为3bh
		jne int9ret
		
		;更改颜色
		mov ax,0b800h
		mov es,ax
		mov bx,1
		mov cx,2000
s:		inc byte ptr es:[bx]
		add bx,2
		loop s
		
int9ret:pop es
		pop cx
		pop bx
		pop ax
		
		iret

int9end:nop
		
code ends

end start