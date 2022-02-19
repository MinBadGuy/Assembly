;王爽汇编语言(第4版)	实验7

assume cs:codesg,ds:data,es:table,ss:stack

data segment
	db	'1975','1976','1977','1978','1979','1980','1981','1982','1983'
	db	'1984','1985','1986','1987','1988','1989','1990','1991','1992'
	db	'1993','1994','1995'
	;以上是表示21年的21个字符串
	
	dd	16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
	dd	345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
	;以上是表示21年公司总收入的21个dword型数据
	
	dw	3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
	dw	11542,14430,15257,17800
	;以上是表示21年公司雇员人数的21个word型数据
data ends

table segment
	db	21	dup	('year summ ne ?? ')
table ends

stack segment
	db	128	dup	(0)
stack ends

codesg segment
start:
	mov ax,data
	mov ds,ax
	mov ax,table
	mov es,ax
	mov ax,stack
	mov ss,ax
	
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
	pop dx	;被除数高16位
	pop ax	;被除数低16位
	div word ptr es:[bx+10]
	mov es:[bx+13],ax	;人均收入
	
	pop cx
	add bp,2
	add bx,16
	loop s0
	
	mov ax,4c00h
	int 21h
codesg ends

end start