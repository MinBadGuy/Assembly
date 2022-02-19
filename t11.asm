;王爽汇编语言(第4版)	实验11

assume cs:codesg,ds:datasg

datasg segment
	db "Beginner's All-purpose Symbolic Instruction Code.",0
datasg ends

codesg segment

begin:	mov ax,datasg
		mov ds,ax
		mov si,0
		call letterc
		
		mov ax,4c00h
		int 21h

;===========================================================
;名称：letterc
;功能：将以0结尾的字符串中的小写字母转变成大写字母
;参数：ds:si指向字符串首地址
letterc:	push cx
			push ds
			push si

s:			mov cl,ds:[si]
			jcxz letterc_ret
			cmp cl,'a'
			jb s0
			cmp cl,'z'
			ja s0
			and cl,11011111B	;转换成大写
			mov ds:[si],cl
s0:			inc si
			jmp s
			
letterc_ret:pop si
			pop ds
			pop cx
			ret

codesg ends

end begin