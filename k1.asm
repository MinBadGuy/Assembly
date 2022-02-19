;王爽汇编语言(第4版)	课程设计1
;简单版
;注：这里对总收入数据做了修改，和书上的不一样，按书上的数据做除法时会产生溢出
;	 相应地，雇员人数也做了修改

assume cs:codesg,ds:data,es:table,ss:stack

data segment
	db	'1975','1976','1977','1978','1979','1980','1981','1982','1983'
	db	'1984','1985','1986','1987','1988','1989','1990','1991','1992'
	db	'1993','1994','1995'
	;以上是表示21年的21个字符串
	
	dd	16,22,382,1356,2390,8000,16000,24486,50065,9749,14047,19751
	dd	34598,59082,80353,11830,18430,27590,37530,46490,59370
	;以上是表示21年公司总收入的21个dword型数据
	
	dw	3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
	dw	1154,1443,1525,1780
	;以上是表示21年公司雇员人数的21个word型数据
data ends

table segment
				 ;0123456789ABCDEF
	db	21	dup	('year summ ne ?? ')
table ends

stack segment
	db	128	dup	(0)
stack ends

codesg segment
start:
	mov ax,stack
	mov ss,ax
	mov sp,128

	;设置table的值
	call input_table
	
	;清屏
	call clear_screen
	
	;显示table的值
	call output_table
	
	
	mov ax,4c00h
	int 21h

;==================================================================
;清屏操作
clear_screen:	mov ax,0B800H
				mov es,ax
				mov bx,0000H
				mov di,0
				
				mov cx,2000		;显示区共4000字节,每次清2个字节，所以循环2000次
clearScreen:	mov es:[di],bx
				add di,2
				loop clearScreen
				
				ret

;==================================================================
;显示table的值
output_table:	mov ax,table	;数据从哪来
				mov ds,ax
	
				mov ax,0B800H	;数据到哪去
				mov es,ax
				
				mov si,0
				mov di,160*3	;从第3行开始显示
				
				mov cx,21
outputTable:	call show_year
				call show_summ
				call show_emp
				call show_avg
				add si,16
				add di,160
				loop outputTable
	ret

;==================================================================
;显示人均收入
show_avg:	push ax
			push ds
			push si
			push dx
			push di
			push cx
			push es
			
			;实际被除数为2个字节，将dx设为0后，直接使用现成的16位除法doDiv
			mov ax,ds:[si+13]	;低16位数据
			mov dx,0			;高16位数据
			
			add di, 40*2
			
			call doDiv
			
			pop es
			pop cx
			pop	di
			pop dx
			pop si
			pop ds
			pop ax
			
			ret

;==================================================================
;显示雇员人数
show_emp:	push ax
			push ds
			push si
			push dx
			push di
			push cx
			push es
			
			;实际被除数为2个字节，将dx设为0后，直接使用现成的16位除法doDiv
			mov ax,ds:[si+10]	;低16位数据
			mov dx,0			;高16位数据
			
			add di, 30*2
			
			call doDiv
			
			pop es
			pop cx
			pop	di
			pop dx
			pop si
			pop ds
			pop ax
			
			ret
;==================================================================
;显示总收入
show_summ:	push ax
			push ds
			push si
			push dx
			push di
			push cx
			push es
			
			;被除数为4字节，所以做16为除法
			mov ax,ds:[si+5]	;低16位数据
			mov dx,ds:[si+7]	;高16位数据
			
			add di, 20*2
			
			call doDiv
			
			pop es
			pop cx
			pop	di
			pop dx
			pop si
			pop ds
			pop ax
			
			ret

;==================================================================
;16位除法，除10取余		
doDiv:	mov cx,10
		div cx				;16位除法，dx中是余数，ax中是商
		add dl,30H			;将数字转成字符(ASCII)
		mov dh,00000010B	;绿色
		mov es:[di],dx
		
		mov cx,ax			
		jcxz divRet			;商为0，说明每一位都单独取出来了
		mov dx,0
		sub di,2
		jmp doDiv

divRet:	ret


;==================================================================
;显示年份
show_year:	push cx
			push di
			push ax
			push ds
			push es
			push si
			
			add di,10*2	;从第20列开始显示，一定要是偶数
			
			mov cx,4
showYear:	mov al,ds:[si]
			mov ah,00000010B	;绿色
			mov es:[di],ax
			inc si
			add di,2
			loop showYear
			
			pop si
			pop es
			pop ds
			pop ax
			pop di
			pop cx
	ret
	

;==================================================================
;设置table的值
input_table:	mov ax,data
				mov ds,ax
				mov ax,table
				mov es,ax

				mov cx,21
				mov bx,0
				mov si,0
				mov bp,0
				
			s0:	push cx
				mov cx,2
				mov di,0
				
			s:	mov ax,ds:[0+si]
				mov es:[bx+0+di],ax	;年份
				mov ax,ds:[84+si]
				mov es:[bx+5+di],ax	;收入
				push ax				;将收入的低16位、高16位入栈
				add si,2
				add di,2
				loop s
				
				mov ax,ds:[168+bp]
				mov es:[bx+10],ax	;雇员数
				
				;求人均收入，16位除法
				pop dx				;被除数高16位
				pop ax				;被除数低16位
				div word ptr es:[bx+10]
				mov es:[bx+13],ax	;人均收入
				
				pop cx
				add bp,2
				add bx,16
				loop s0
	ret

;==================================================================	
codesg ends

end start