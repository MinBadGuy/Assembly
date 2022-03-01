;王爽汇编语言(第4版)	16.3 直接定址法
;编程：计算sin(x)

assume cs:code

code segment
start:	
		mov al,30
		call showsin
		
		mov ax,4c00h
		int 21h
		
showsin:	jmp short show
			
			table	dw	ag0,ag30,ag60,ag90,ag120,ag150,ag180		;字符串偏移地址表
			ag0		db	'0',0		;sin(0)对应的字符串'0'
			ag30	db	'0.5',0
			ag60	db	'0.866',0
			ag90	db	'1',0
			ag120	db	'0.866',0
			ag150	db	'0.5',0
			ag180	db	'0',0
		
	show:	push bx
			push es
			push si
			
			mov bx,0b800h
			mov es,bx
			
			mov ah,0
			mov bl,30
			div bl			;用角度值/30作为相对于table的偏移，取得对应的字符串的偏移地址，放在bx中
			mov bl,al
			mov bh,0
			add bx,bx		;这里是因为table中存放的是字型数据
			mov bx,table[bx]
			
			mov si,160*12+40*2
	shows:	mov ah,cs:[bx]
			cmp ah,0
			je showret
			mov es:[si],ah
			inc bx
			add si,2
			jmp short shows
			
	showret:pop si
			pop es
			pop bx
			
			ret
				
code ends
end start