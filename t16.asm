;王爽汇编语言(第4版)	实验16

assume cs:code

code segment
		table	dw sub1,seg sub1,sub2,seg sub2,sub3,seg sub3,sub4,seg sub4
start:	call cpy_new_int7ch
		call set_new_int7ch
		
		mov ah,3
		mov al,1
		int 7ch
		
		mov ax,4c00h
		int 21h

;将中断例程拷贝值0:200处
cpy_new_int7ch:	mov ax,cs
				mov ds,ax
				mov si,offset new_int7ch
				mov ax,0
				mov es,ax
				mov di,200h
				mov cx,offset new_int7ch_end - offset new_int7ch
				cld
				rep movsb
				
				ret
				
;设置中断向量表
set_new_int7ch:	mov ax,0
				mov es,ax
				mov word ptr es:[7ch*4],200h
				mov word ptr es:[7ch*4+2],0
				
				ret
				
;新 int 7ch 中断例程
new_int7ch:	push bx
			
			cmp ah,3	;判断功能号是否大于3
			ja sret
			mov bl,ah
			mov bh,0
			add bx,bx
			add bx,bx	;根据ah中的功能号计算对应子程序在table表中的偏移
			
			call dword ptr ds:table[bx]		;调用对应的功能子程序
			;注意：这里因为进入了中断例程，cs=0，所以不能使用 call word ptr
			;要使用 call dword ptr，相应的子程序中要改成 retf
	sret:	pop bx
			iret

new_int7ch_end: nop
		

;清屏
sub1:	push bx
		push cx
		push es
		
		mov bx,0b800h
		mov es,bx
		mov bx,0
		mov cx,2000
sub1s:	mov byte ptr es:[bx],' '
		add bx,2
		loop sub1s
		
		pop es
		pop cx
		pop bx
		
		retf

;设置前景色
sub2:	push bx
		push cx
		push es
		
		mov bx,0b800h
		mov es,bx
		mov bx,1
		mov cx,2000
sub2s:	and byte ptr es:[bx],11111000b
		or es:[bx],al
		add bx,2
		loop sub2s
		
		pop es
		pop cx
		pop bx
		
		retf
		
;设置背景色
sub3:	push bx
		push cx
		push es
		
		mov cl,4
		shl al,cl
		mov bx,0b800h
		mov es,bx
		mov bx,1
		mov cx,2000
sub3s:	and byte ptr es:[bx],10001111b
		or es:[bx],al
		add bx,2
		loop sub3s
		
		pop es
		pop cx
		pop bx
		
		retf

;向上滚动一行
sub4:	push cx
		push si
		push di
		push es
		push ds
		
		mov si,0b800h
		mov es,si
		mov ds,si
		mov si,160		;ds:si指向第n+1行
		mov di,0		;ds:di指向第n行
		cld
		mov cx,24		;共复制24行
		
sub4s:	push cx
		mov cx,160
		rep movsb
		pop cx
		loop sub4s
		
		mov cx,80
		mov si,0
sub4s1:	mov byte ptr [160*24+si],' '	;最后一行清空
		add si,2
		loop sub4s1
		
		pop ds
		pop es
		pop di
		pop si
		pop cx
		
		retf

code ends
end start