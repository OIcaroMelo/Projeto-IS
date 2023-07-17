_questao2:
    setText 2, 0, enunciado2, 7
    call endl

    mov di, maior
    call get_input
    mov di, menor
    call get_input

    mov si, menor
    lodsb
    mov dl, al

    mov si, maior
    call comp
    ret

_questao3:
    setText 2, 0, enunciado3, 7
    call endl

	mov di, string
    call get_input
    mov si, string
    call stoi
    push ax

    mov di, string
    call get_input
    mov si, string
    call stoi
    pop bx
    push ax
    mul bx
    push ax
    push bx

    mov di, string
    call get_input
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
    call get_input
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

    setText 10, 0, string4, yellowColor
    pop dx
    pop ax
	push dx
	add ax, 48
    call putchar

    pop dx
    cmp dx, 1
    je .diff
    .equal:
        setText 10, 13, string2, 7
        ret
    .diff:
		setText 10, 13, string3, 7
        ret

_questao5:
    xor ax,ax
    xor bx,bx 

    mov ah,00h
    mov al,13h
    int 10h
    
	xor ax,ax

    mov bh,0
    mov bl,0xf

    setText 2, 0, enunciado5, 7
    call endl
    
    mov di, numeroLido
    call get_input

    mov si, numeroLido
    call stoi  

    setText 6, 0, stringImpressa, ax

    ret

_questao1:
    setText 2, 0, enunciado1, 7
    call endl
    mov di, valor
    call get_input
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
    call putchar
    jmp .done5
    .print10:
        setText 7, 0, printf10, 7
        jmp .done5
    .done5:
        setText 8, 0, vazio, 7
    ret
