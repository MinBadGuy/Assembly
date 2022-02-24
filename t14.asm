;王爽汇编语言(第4版)	实验14

assume cs:code

code segment
		s:	db 9,8,7,4,2,0,'$'
	style:	db 'YY/MM/DD HH:MM:SS',0
start:	
		call init_reg
		call show_time_style
		call show_time
		

		mov ax,4c00h
		int 21h
;====================================================
init_reg:
	mov bx,0B800h
	mov es,bx
	mov di,160*12+40*2
	ret

;====================================================
show_time_style:
			push di
		
			mov si,offset style
showStyle:	mov al,cs:[si]
			cmp al,0
			je ok
			mov es:[di],al
			inc si
			add di,2
			jmp showStyle
		
	ok:		pop di
			ret

;====================================================	
show_time:
			mov si,offset s
showTime:	mov al,cs:[si]
			cmp al,'$'
			je showTimeEnd
			out 70h,al
			in al,71h		;读出当前BCD码
			
			mov ah,al
			mov cl,4
			shr ah,cl		;ah,十位数值码
			and al,00001111B;al,个位数值码
			
			add ah,30h	;转成对应的ASCII码字符
			add al,30h
			
			mov es:[di],ah		;显示十位数
			mov es:[di+2],al	;显示个位数
			
			inc si
			add di,6
			
			jmp showTime
		
showTimeEnd:	ret


code ends

end start