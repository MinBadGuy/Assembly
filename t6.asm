;王爽汇编语言(第4版)	实验6 (2)

assume cs:codesg,ss:stacksg,ds:datasg

stacksg segment
	dw 0,0,0,0,0,0,0,0
stacksg ends

datasg segment
	db '1. display      '
	db '2. brows        '
	db '3. replace      '
	db '4. modify       '
datasg ends

codesg segment
start:	mov ax,stacksg
		mov ss,ax
		mov sp,16		;设置ss:ip
		
		mov ax,datasg
		mov ds,ax		;设置ds
		
		mov bx,0		;外层循环偏移变量
		mov cx,4		;设置外层循环计算器cx
		
s0:		push cx			;将外层循环计数器入栈
		mov si,0		;内层循环偏移变量
		mov cx,4		;设置内层循环计算器cx

s:		mov al,[bx+3+si]
		and al,11011111B;转换成大写字母
		mov [bx+3+si],al;将大写字母放置原位
		inc si
		loop s
		
		pop cx			;将外层循环计数器出栈
		add bx,16
		loop s0
		
		mov ax,4c00h
		int 21h
codesg ends

end start