;王爽汇编语言(第4版)	实验9

assume cs:code,ds:data

data segment
		;0123456789ABCDEF
	db	'welcome to masm!'	;字符串
	db	00000010B			;绿色
	db	00100100B			;绿底红色
	db	01110001B			;白底蓝色
data ends

code segment
start:	mov ax,data
		mov ds,ax
		mov si,0
		
		mov ax,0B800H
		mov es,ax
		mov di,160*10+30*2	;设置显示区域位置	偶数
		
		mov cx,16
		
s:		mov al,ds:[si]		;低字节存放字符
		mov ah,ds:[16]		;高字节存放颜色属性	绿色
		mov es:[di],ax
		
		mov ah,ds:[17]
		mov es:[di+160],ax	;在下一行显示绿底红字
		
		mov ah,ds:[18]
		mov es:[di+160*2],ax	;再再下一行显示白底蓝字
		
		add di,2
		inc si
		loop s

		mov ax,4c00h
		int 21h

code ends

end start