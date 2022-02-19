;王爽汇编语言(第4版)	实验10-1

assume cs:code

data segment
	db 'Welcome to masm!',0
data ends

code segment
start:	mov dh,8
		mov dl,3
		mov cl,2
		mov bl,cl	;颜色
		
		mov ax,data
		mov ds,ax
		mov si,0
		
		mov ax,0B800h
		mov es,ax
		mov di,0
		;根据dh、dl求di，即把数据放到哪去
		call init_di
		;显示字符串
		call show_str
		
		mov ax,4c00h
		int 21h


;==================================================================
;设置di
init_di:	mov al,160
			mul	dh
			add di,ax
			mov al,2
			mul dl
			add di,ax
			
			ret

;==================================================================
;名称：show_str
;功能：在指定的位置，用指定的颜色，显示一个用0结束的字符串
;参数：(dh)=行号(取值范围0~24)，(dl)=列号(取值范围0~79)
;	   (cl)=颜色，ds:si指向字符串的首地址
;返回：无
show_str:	push cx
			push ds
			push si
			push es
			push di
			push bx
			
showStr:	mov cl,ds:[si]		;用cl接收读取的字符，
			jcxz ok				;用jcxz判断读取的是否为0
			mov es:[di+0],cl	;低字节数据
			mov es:[di+1],bl	;高字节颜色
			add di,2
			inc si
			jmp showStr
			
ok:			pop bx
			pop di
			pop es
			pop si
			pop	ds
			pop cx

			ret

code ends

end start
