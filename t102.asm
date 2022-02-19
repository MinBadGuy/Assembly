;王爽汇编语言(第4版)	实验10-2

assume cs:code

code segment
start:	mov ax,4240h	;被除数低16位	L
		mov dx,000Fh	;被除数高16位	H
		mov cx,10		;除数	N
		
		push ax
		mov bp,sp		;ss:[bp+0] 
		
		call divdw
		
		mov ax,4c00h
		int 21h
		
;==================================================================
;X/N=int(H/N)*65536+[rem(H/N)*65536+L]/N
;X：被除数	32位
;N：除数	16位
;H：X的高16位
;L：X的低16位

;名称：divdw
;功能：进行不会产生溢出的除法运算，被除数为dword型，除数为word型，结果为dword型
;参数：(ax)=dword型数据的低16位
;	   (dx)=dword型数据的高16位
;	   (cx)=除数
;返回：(dx)=结果的高16位，(ax)=结果的低16位
;	   (cx)=除数
divdw:	
		;先对高16位数据做16位除法
		mov ax,dx
		mov dx,0			;16位除法的被除数是32位，高16位存在dx中，低16位存在ax中
							;所以这里需要将dx设成0
		div cx				;ax: int(H/N)
							;dx: rem(H/N)
		
		push ax				;结果的高16位，留待放置dx中
		
		;再对低16位数据做16位除法
		mov ax,ss:[bp+0]	;L
		div cx				;此时dx中刚好是上一步除法的余数
							;ax: [rem(H/N)*65536+L]/N 的 商		;结果的低16位
							;dx: [rem(H/N)*65536+L]/N 的 余数
		
		mov cx,dx			;余数放到cx中
		pop dx				;结果的高16位
			
		ret

code ends

end start