;王爽汇编语言(第4版)	实验12

assume cs:code

code segment
start:	
		;将do0程序拷贝至 0000:0200 处
		mov ax,cs
		mov ds,ax
		mov si,offset do0					;设置ds:si指向源地址
		
		mov ax,0
		mov es,ax
		mov di,200h							;设置es:di指向目的地址
		
		mov cx,offset do0end - offset do0	;设置cx为传输长度
		cld									;设置传输方向为正
		rep movsb
		
		;设置中断向量表
		mov ax,0
		mov es,ax
		mov word ptr es:[0*4],200h			;偏移地址
		mov word ptr es:[0*4+2],0			;段地址
		
		;测试中断0处理程序
		mov ax,1000h
		mov bh,1
		div bh
		
		mov ax,4c00h
		int 21h
		
;==================================================================================
;中断0处理程序

do0:	jmp short do0start					;这条指令占2个字节
		db "divide error!"
		
do0start:	mov ax,cs
			mov ds,ax
			mov si,202h						;设置ds:si指向字符串
			
			mov ax,0B800h
			mov es,ax
			mov di,12*160+36*2				;设置es:di指向显存空间的某一位置	偶数
			
			mov cx, 13						;设置cx为字符串长度
s:			mov al,ds:[si]
			mov ah,00000100B				;红色
			mov es:[di],ax
			inc si
			add di,2
			loop s
			
			mov ax,4c00h
			int 21h
			
do0end:		nop

code ends

end start