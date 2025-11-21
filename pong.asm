[org 0x0100]
jmp start
	scr1: dw 0
	scr2: dw 0
	winScore: dw 5
	
	msg1: db 'P1 Score: ',0
	msg2: db 'P2 Score: ',0
	msg3: db 'Player 1: W-Up S-Down', 0
	msg4: db 'Player 2: O-Up K-Down', 0  
	msg5: db 'Score 5 to Win', 0
	msg6: db 'Red Wins the Game',0
	msg7: db 'Green Wins the Game',0
	msg8: db 'Press - r - to Restart',0
	msg9: db 'Press Any Other Key to Exit',0
	msg10: db 'Game Exited!',0
	msg11: db '2 Player Pong Game',0
	
	leftPd: dw 1604
	rightPd: dw 2074
	oldLft: dw 1604
	oldRt: dw 2074
	X1: dw 6
	Y1: dw 12
	X2: dw 1
	Y2: dw 0
	oldPos: dw 0
	speed: dw 1
	oldisr: dd 0
start:
	call installTimer
	call clrScr
	call drawLine
	call drawBoundary
	
	mov ax,[Y1]
	mov bx,160
	mul bx
	mov bx,[X1]
	shl bx,1
	add ax,bx
	mov [oldPos],ax
	
	call drawSetup
    
	loop1:
		mov ax,[scr1]
		cmp ax,[winScore]
		jge win1
		mov ax,[scr2]
		cmp ax,[winScore]
		jge win2
		jmp loop1
    win1:
		call stopTimer
		call boxPrint
		mov di,1982
		mov si,msg6
		push di
		push si
		call printStr1
		
		mov di,2298
		mov si,msg8
		push di
		push si
		call printStr
		
		mov di,2614
		mov si,msg9
		push di
		push si
		call printStr
		mov ah,0
		int 0x16
		cmp al,'r'
		je restart
		jmp exit
	win2:
		call stopTimer
		call boxPrint
		mov di,1982
		mov si,msg7
		push di
		push si
		call printStr1
		
		mov di,2298
		mov si,msg8
		push di
		push si
		call printStr
		
		mov di,2614
		mov si,msg9
		push di
		push si
		call printStr
		
		mov ah,0
		int 0x16
		cmp al,'r'
		je restart
		jmp exit
restart:
    mov word [scr1], 0
    mov word [scr2], 0
    mov word [leftPd], 1604
    mov word [rightPd], 2074
    mov word [oldLft], 1604
    mov word [oldRt], 2074
    mov word [X1], 6
    mov word [Y1], 12
    mov word [X2], 1
    mov word [Y2], 0
    mov word [speed], 1
    
    mov ax, [Y1]
    mov bx, 160
    mul bx
	mov bx, [X1]
    shl bx, 1
    add ax, bx
    mov [oldPos], ax
    
	call installTimer
    call clrScr
    call drawLine
    call drawBoundary
    call drawSetup
    jmp loop1
exit:
	call stopTimer
	call clrScr
	call drawBoundary
	call boxPrint
	
	mov di,2308
	mov si,msg10
	push di
	push si
	call printStr1
	
	mov ax,0x4c00
	int 0x21
stopTimer:
	push ax
	mov ax, 0
    mov es, ax
    mov ax, [oldisr]
    mov [es:8*4], ax
    mov ax, [oldisr+2]
    mov [es:8*4+2], ax
	pop ax
	ret
installTimer:
	push ax
	mov ax, 0
    mov es, ax
    
    mov ax, [es:8*4]
    mov [oldisr], ax
    mov ax, [es:8*4+2]
    mov [oldisr+2], ax
    
    cli
    mov word [es:8*4], timer
    mov [es:8*4+2], cs
    sti
	pop ax
	ret
boxPrint:
	push ax
	push cx
	push si
	push di
	push es
	
	call clrScr
	call drawBoundary
	mov ax,0xb800
	mov es,ax
	
	mov di,1640
	mov si,2760
	mov ax,0x0FCD
	mov cx,40
	l2:
		mov [es:di],ax
		add di,2
		mov [es:si],ax
		add si,2
		loop l2
	
	mov si,di
	mov di,1640
	mov ax,0x0FBA
	mov cx,8
	l3:
		mov [es:di],ax
		add di,160
		mov [es:si],ax
		add si,160
		loop l3		
	pop es
	pop di
	pop si
	pop cx
	pop ax
	ret
timer:
	push ax
    push ds
    
    push cs
    pop ds
    
    dec word [speed]
	jnz skip
    
    mov word [speed], 1
    
    call PaddleMovement
	call MoveBall
    call drawSetup
	
	skip:
		mov al,0x20
		out 0x20,al
		pop ds
		pop ax
		iret
MoveBall:
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push es
	
	mov ax,0xb800
	mov es,ax
	
	mov di,[oldPos]
	mov word[es:di],0x0720
	
	mov ax, [X1]
    add ax, [X2]
    mov [X1], ax
    
    mov ax, [Y1]
    add ax, [Y2]
    mov [Y1], ax
	
	cmp word [Y1], 1
    jl bounceY
    cmp word [Y1], 23
    jg bounceY
	
	call checkCollision
		
	cmp word [X1], 1
    jl pl2Score
    cmp word [X1], 78
    jg pl1Score
    
    jmp updateBallPos
		
	bounceY:
		neg word[Y2]
		mov ax,[Y1]
		add ax,[Y2]
		mov [Y1],ax
		jmp updateBallPos
	
	pl1Score:
		inc word[scr1]
		call ResetBall
		jmp done1
		
	pl2Score:
		inc word[scr2]
		call ResetBall
		jmp done1

	updateBallPos:
		mov ax,[Y1]
		mov bx,160
		mul bx
		mov bx,[X1]
		shl bx,1
		add ax,bx
		mov [oldPos],ax
	done1: 
		pop es
		pop di
		pop si
		pop dx
		pop cx
		pop bx
		pop ax
		ret
checkCollision:
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push es
	
	mov ax,0xb800
	mov es,ax
	
	cmp word[X1],2
	jne checkRight
	
	mov ax, [leftPd]
    mov bx, 160
    xor dx, dx
    div bx             
    mov bx, ax    ; Top of Left Pd
	
	mov cx,bx  
	add cx,4      ; Bottom of Left Pd
	
	mov ax,[Y1]
	cmp ax,bx
	jl checkRight
	cmp ax,cx
	jg checkRight
	
	mov word [X2], 1
    jmp done2
	
	checkRight:
		cmp word[X1],76
		jne done2
		
		mov ax, [rightPd]
		mov bx, 160
		xor dx, dx
		div bx             
		mov bx, ax    ; Top of Right Pd
		
		mov cx,bx  
		add cx,4      ; Bottom of Right Pd
		
		mov ax,[Y1]
		cmp ax,bx
		jl done2
		cmp ax,cx
		jg done2
		
		sub ax,bx
		cmp ax, 1          
		jbe rightTopHit
		cmp ax, 3        
		je rightCenterHit
		jmp rightBottomHit
	rightTopHit:
		mov word[X2],-1
		mov word[Y2],-1
		jmp done2
	rightCenterHit:
		mov word[X2],-1
		mov word[Y2],0
		jmp done2
	rightBottomHit:
		mov word[X2],-1
		mov word[Y2],1
	
	done2:
		pop es
		pop di
		pop si
		pop dx
		pop cx
		pop bx
		pop ax
		ret
drawBoundary:
	push ax
	push cx
	push di
	push es
	
	mov ax,0xb800
	mov es,ax
	cld
	
	mov cx,80
	mov di,0
	mov ax,0x02DB
	rep stosw
	
	mov cx,80
	mov di,3840
	mov ax,0x02DB
	rep stosw
	
	mov di,0
	mov si,158
	mov cx,25
	mov ax,0x0EDB
	l1:
		mov [es:di],ax
		add di,160
		mov [es:si],ax
		add si,160
		loop l1

	pop es
	pop di
	pop cx
	pop ax
	ret
ResetBall:
	push ax
	push bx
	
	mov word [X1], 4
    mov word [Y1], 12
    mov word [X2], 1
    mov word [Y2], 0
	
	mov ax, [Y1]
    mov bx, 160
    mul bx
    mov bx, [X1]
    shl bx, 1
    add ax, bx
    mov [oldPos], ax
	
	pop bx
	pop ax
	ret
drawBall:
	push ax
	push di
	push es
	
	mov ax,0xb800
	mov es,ax
	mov di,[oldPos]
	mov word[es:di],0x02DB
	
	pop es
	pop di
	pop ax
	ret
PaddleMovement:
	push ax
	
	mov ah,0x01
	int 0x16
	jz noKey
	
	mov ah,0x00
	int 0x16
	cmp al,'w'
	je leftUp
	cmp al,'s'
	je leftDown
	cmp al,'o'
	je rightUp
	cmp al,'k'
	je rightDown
	jmp noKey
	leftUp:
		cmp word[leftPd],322
		jbe noKey
		sub word[leftPd],160
		jmp noKey

	leftDown:
		cmp word[leftPd],3036
		jae noKey
		add word[leftPd],160
		jmp noKey

	rightUp:
		cmp word[rightPd],322
		jbe noKey
		sub word[rightPd],160
		jmp noKey

	rightDown:
		cmp word[rightPd],3036
		jae noKey
		add word[rightPd],160
		jmp noKey

	noKey:
		pop ax
		ret
printStr1:
	push bp
	mov bp,sp
	push ax
	push bx
	push di
	push si
	push es
	mov ax,0xb800
	mov es,ax
	
	mov si,[bp+4]
	mov di,[bp+6]
	mov ah,0x0A
	prLoop2:
		mov al,[si]
		cmp al,0
		je clear1
		
		mov [es:di],ax
		add di,2
		inc si
		jmp prLoop2
	clear1:
		pop es
		pop si
		pop di
		pop bx
		pop ax
		pop bp
		ret 4
DisplayInfo:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push es
    
    mov ax, 0xb800
    mov es, ax
    
    mov di, 164            
    mov si, msg3
	push di
	push si
    call printStr
    
    mov di, 324         
    mov si, msg4
	push di
	push si
    call printStr
    
    mov di, 484      
    mov si, msg5
	push di
	push si
    call printStr
    
    mov di, 280           
    mov si, msg1
	push di
	push si
    call printStr
    
    mov ax, [scr1]
    add di, 18    
	push ax
	push di
    call printNum
    
    mov di, 440    
    mov si, msg2
	push di
	push si
    call printStr
 
    mov ax, [scr2]
    add di, 18
	push ax
	push di
    call printNum
    push msg11
	call printName
	
    pop es
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
printStr:
	push bp
	mov bp,sp
	push ax
	push bx
	push di
	push si
	push es
	mov ax,0xb800
	mov es,ax
	
	mov si,[bp+4]
	mov di,[bp+6]
	mov ah,0x0F
	prLoop:
		mov al,[si]
		cmp al,0
		je clear
		
		mov [es:di],ax
		add di,2
		inc si
		jmp prLoop
	clear:
		pop es
		pop si
		pop di
		pop bx
		pop ax
		pop bp
		ret 4
printNum:
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push es

	mov ax,0xb800
	mov es,ax
	
	mov ax,[bp+6]
	mov di,[bp+4]
	mov bx,10
	mov cx,0
	dig1:
		mov dx,0
		div bx
		add dl,0x30
		push dx
		inc cx
		cmp ax,0
		jne dig1
	prLoop1:
		pop dx
		mov dh,0x0F
		mov [es:di],dx
		add di,2
		dec cx
		jnz prLoop1
	pop es
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 4
drawSetup:
	push ax
	push cx
	push di
	push es
	
	mov ax,0xb800
	mov es,ax
	
	mov di,[oldLft]
    mov cx,5
    loop4:
        mov word[es:di], 0x0720
        add di,160
        loop loop4
    
    mov di,[oldRt]
    mov cx,5
    loop5:
        mov word[es:di], 0x0720
        add di,160
        loop loop5
	
	mov di,[leftPd]
	mov cx,5
	mov ax,0x04DB
	loop2:
		mov [es:di],ax
		add di,160
		loop loop2
	
	mov di,[rightPd]
	mov cx,5
	mov ax,0x01DB
	loop3:
		mov [es:di],ax
		add di,160
		loop loop3
		
	mov ax, [leftPd]
    mov [oldLft], ax
    mov ax, [rightPd]
    mov [oldRt], ax
	
	call drawBall
	call drawLine
	call DisplayInfo
	pop es
	pop di
	pop cx
	pop ax
	ret
drawLine:
	push ax
	push di
	push es
	
	mov ax,0xb800
	mov es,ax
	mov cx,22
	mov di,400
	mov ax,0x0E7C
	draw:
		mov [es:di],ax
		add di,160
		loop draw
	
	pop es
	pop di
	pop ax
	ret
printName:
	push bp
	mov bp,sp
	push ax
	push bx
	push di
	push si
	push es
	
	mov ax,0xb800
	mov es,ax
	
	mov si,[bp+4]
	mov di,222
	mov ah,0x0B
	prLoop3:
		mov al,[si]
		cmp al,0
		je drawL1
		
		mov [es:di],ax
		add di,2
		inc si
		jmp prLoop3
	drawL1:
		mov ax,0xb800
		mov es,ax
		mov di,382
		mov cx,18
		mov ax,0x0ECD
		cld 
		rep stosw
	
	pop es
	pop si
	pop di
	pop bx
	pop ax
	pop bp
	ret 2
clrScr:
	push ax
	push di
	push es
	
	mov ax,0xb800
	mov es,ax
	mov cx,2000
	mov di,0
	mov ax,0x0720
	cld
	rep stosw
	
	pop es
	pop di
	pop ax
	ret
