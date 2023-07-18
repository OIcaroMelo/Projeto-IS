_questao1:
    setText 2, 0, enunciado1, 7
    call endl
    mov di, valor
    getInput
    mov si, valor
    call stoi

    mov bx, 0
    mov cx, 0

    jmp .loop3
    .loop3:
        cmp ax, 0
        je .endloop3
        cmp bx, 0
        je .aux
        cmp cx, 0
        je .aux2
        add bx, cx
        pop cx
        push bx
        dec ax
        jmp .loop3
        .aux:
            inc bx
            dec ax
            push bx
            jmp .loop3
        .aux2:
            inc cx
            dec ax
            push cx
            jmp .loop3
    .endloop3:
        pop ax

    mov bx, 11
    div bx
    mov ax, dx
    cmp ax, 10
    je .print10
    add ax, 48
    setOutput
    jmp .done5
    .print10:
        setText 7, 0, printf10, lightGrey
        jmp .done5
    .done5:
        setText 8, 0, vazio, lightGrey
    ret

_questao2:
    setText 2, 0, enunciado2, lightGrey
    call endl

    mov di, maior
    getInput
    mov di, menor
    getInput

    mov si, menor
    lodsb
    mov dl, al

    mov si, maior
    call comp
    ret

_questao3:
    setText 2, 0, enunciado3, lightGrey
    call endl

	mov di, string
    getInput
    mov si, string
    call stoi
    push ax

    mov di, string
    getInput
    mov si, string
    call stoi
    pop bx
    push ax
    mul bx
    push ax
    push bx

    mov di, string
    getInput
    mov si, string
    call stoi
    push ax
    pop bx
    pop ax
    pop cx
    push bx
    div bx
    sub cx, ax
    pop ax
    pop bx
    push cx
    push bx
    push ax

    mov di, string
    getInput
    mov si, string
    call stoi
    pop bx
    pop cx
    push ax
    mul bx
    push ax
    pop bx
    pop ax
    div cx
    add ax, bx
    pop cx
    add ax, cx
    push ax
    mov bx, 2
    div bx
    push dx

    setText 10, 0, string4, lightGrey
    pop dx
    pop ax
	push dx
	add ax, 48
    setOutput

    pop dx
    cmp dx, 1
    je .diff
    .equal:
        setText 10, 13, string2, lightGrey
        ret
    .diff:
		setText 10, 13, string3, lightGrey
        ret

_questao4:
    _start:
    setText 2, 0, enunciado4, lightGrey
    call endl
    
    mov di,stringImpressa
    getInput
        
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx
    mov es,ax
    mov ds,ax
    
    mov si,stringImpressa
    push bx
    _loopNovo:
        cmp cx,2
            je _enter
        cmp cx,5
            je _enter
        cmp cx,10
            je _enter
        
        mov bl,byte[si]
        sub bl,48
        add al,bl

        inc si
        inc cx
    jmp _loopNovo

       
_enter:
    cmp al,10
        jae _div
    
    pop bx
    add ax,bx    
    push ax

    xor ax, ax

    inc si
    inc cx

    cmp cx,11
        jne _loopNovo
    jmp _end
 
_div:
    mov dl,10
    div dl
    add al,ah   
    xor ah,ah

    cmp cx,11
        jne _enter
    jmp _here
    
_end:
    pop ax
    _here:
        cmp ax,10
            jae _div
        add al,48
        setOutput 
        ret
_questao5:
    
    setText 2, 0, enunciado5, lightGrey
    call endl
    
    mov di, numeroLido
    getInput
    mov si, numeroLido
    call stoi  

    setText 6, 0, stringImpressa, ax

    ret
