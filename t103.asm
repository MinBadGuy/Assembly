;王爽汇编语言(第4版)	实验10-3

assume cs:code,ds:data

data segment
	db 10 dup (0)
data ends

code segment
start:	mov ax,12666
		mov bx,data
		mov ds,bx
		mov si,10
		call dtoc
		
		mov dh,8
		mov dl,3
		mov cl,2
		mov bl,cl
		call show_str
		
		mov ax,4c00h
		int 21h

;==================================================================
;名称：dtoc
;功能：将word型数据转变为表示十进制数的字符串，字符串以0为结尾符
;参数：(ax)=word型数据
;	   ds:si指向字符串的首地址
;返回：无
dtoc:	mov cx,10
		mov dx,0			;做16位除法，所以要将dx设置成0
		div cx				;ax：商		dx：余数
		add dl,30h			;十进制字符对应的ASCII码
		dec si
		mov ds:[si],dl
		mov cx,ax
		jcxz s0
		jmp dtoc
		
s0:		ret


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
			
			mov ax,0B800h
			mov es,ax
			mov di,0
			call init_di
			
			
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
			
;==================================================================
;设置di
init_di:	mov al,160
			mul	dh
			add di,ax
			mov al,2
			mul dl
			add di,ax
			
			ret

code ends

end start