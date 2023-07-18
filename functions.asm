%macro setText 4
	mov ah, 02h  
	mov bh, 0    
	mov dh, %1   
	mov dl, %2   
	int 10h
	mov bx, %4
	mov si, %3
	call printf_color
%endmacro

%macro simplePrintf 2
	mov bx, %2
	mov si, %1
	call printf_color
%endmacro

%macro getInput 0
    pusha
        mov bx,lightGrey
        call get_input
    popa
%endmacro

%macro setOutput 0
    pusha
        mov bx,lightGrey
        call putchar
    popa
%endmacro

%macro drawer 1
	mov ah, 0ch 
	mov al, %1
	mov bh, 0
%endmacro

%macro drawSquare 4
	mov cx, %1
	.draw_rows:
		mov dx, %2
		int 10h
		mov dx, %4
		int 10h
		inc cx
		cmp cx, %3
		je .end_column
		jmp .draw_rows
	.end_column:
		mov dx, %2
	.draw_columns:
		mov cx, %1
		int 10h
		mov cx, %3
		int 10h
		inc dx
		cmp dx, %4
    jne .draw_columns
%endmacro

%macro drawCursor 4
	mov cx, %1
	.draw_seg:
		mov dx, %3-1
		int 10h
		mov dx, %3
		int 10h
		inc cx
		cmp cx, %4
		je .end_column
		jmp .draw_seg
	.end_column:
		mov dx, %2
	.draw_columns:
		mov cx, %4-2
		int 10h
		mov cx, %4-1
		int 10h
		inc dx
		cmp dx, %3
	jne .draw_columns
%endmacro

%macro position 2
	push dx
	push cx
	mov ah, 0ch
	add dx, %1
	add cx, %2
	int 10h
	pop cx
	pop dx
%endmacro

%macro blackBackgroundApp 4
	mov ah, 0ch 
	mov al, blackColor
	mov bh, 0
	mov cx, %1
	mov dx, %2
	.draw_seg:
		int 10h
		inc cx
		cmp cx, %3
		je .jump_row
		jne .draw_seg
	.back_column:
		mov cx, %1
		jmp .draw_seg
	.jump_row:
		inc dx
		cmp dx, %4
		jne .back_column
	mov al, whiteColor
%endmacro

%macro setColor 1
  mov ah, 0ch
	mov bh, 0
	mov al, %1
	int 10h
%endmacro

%macro setBackground 1
	mov ah, 0x0
	mov bh, 0
	mov bl, %1
	int 10h
%endmacro

gets:
    xor cx, cx
    .loop1:
        call getchar
        cmp al, 0x08
        je .backspace
        cmp al, 0x0d
        je .done
        cmp cl, 50
        je .loop1
        stosb
        inc cl
        call putchar
        jmp .loop1
        .backspace:
            cmp cl, 0
            je .loop1
            dec di
            dec cl
            mov byte[di], 0
            call delchar
            jmp .loop1
    .done:
        mov al, 0
        stosb
        call endl
ret

getchar:
    mov ah, 0x00
    int 16h
ret

putchar:
    mov ah, 0x0e
    int 10h
ret

delchar:
    mov al, 0x08
    call putchar
    mov al, ''
    call putchar
    mov al, 0x08
    call putchar
ret

endl:
    mov al, 0x0a
    call putchar
    mov al, 0x0d
    call putchar
ret

stoi:
    xor cx, cx
    xor ax, ax
    .loop1:
        push ax
        lodsb
        mov cl, al
        pop ax
        cmp cl, 0
        je .endloop1
        sub cl, 48
        mov bx, 10
        mul bx
        add ax, cx
        jmp .loop1
    .endloop1:
ret

printString:
    .loop:
        lodsb
        cmp al, 0
        je .endloop
        call putchar
        jmp .loop
    .endloop:
ret

reverse:
    mov di, si
    xor cx, cx
    .loop1:
        lodsb
        cmp al, 0
        je .endloop1
        inc cl
        push ax
        jmp .loop1
    .endloop1:
    .loop2:
        cmp cl, 0
        je .endloop2
        dec cl
        pop ax
        stosb
        jmp .loop2
    .endloop2:
ret
        
tostring:
    push di
    .loop1:
        cmp ax, 0
        je .endloop1
        xor dx, dx
        mov bx, 10
        div bx
        xchg ax, dx
        add ax, 48
        stosb
        xchg ax, dx
        jmp .loop1
    .endloop1:      
        pop si
        cmp si, di
        jne .done
        mov al, 48
        stosb
    .done:
        mov al, 0
        stosb
        call reverse
ret

_fix:
    cmp al, 118
    jae .fix1
    cmp al, 108
    jae .fix2
    cmp al, 98
    jae .fix3
    cmp al, 88
    jae .fix4
    cmp al, 78
    jae .fix5
    cmp al, 68
    jae .fix6
    cmp al, 58
    jae .fix7
    .normal:
        setOutput
        jmp .done2
    .fix1:
        push ax
        mov ax, 55
        setOutput
        pop ax
        sub al, 70
        jmp .normal
    .fix2:
        push ax
        mov ax, 54
        setOutput
        pop ax
        sub al, 60
        jmp .normal
    .fix3:
        push ax
        mov ax, 53
        setOutput
        pop ax
        sub al, 50
        jmp .normal
    .fix4:
        push ax
        mov ax, 52
        setOutput
        pop ax
        sub al, 40
        jmp .normal
    .fix5:
        push ax
        mov ax, 51
        setOutput
        pop ax
        sub al, 30
        jmp .normal
    .fix6:
        push ax
        mov ax, 50
        setOutput
        pop ax
        sub al, 20
        jmp .normal
    .fix7:
        push ax
        mov ax, 49
        setOutput
        pop ax
        sub al, 10
        jmp .normal
    .done2:
        ret

comp:
    xor bl,bl
    xor cl,cl
    .loop1:
    lodsb

    cmp al, 0
    je .end_count

    cmp al, dl
    je .equal2 
    jne .next_char
    jmp .loop1

    .equal2:
        inc bl
        inc cl
        jmp .loop1

    .next_char:
        inc bl
        jmp .loop1

    .end_count:
        xor al,al

        mov al,cl
        add al,48
        pusha
        mov bl,7
        call _fix
        popa

        mov al, '/'
        pusha
        mov bl,7
        call putchar
        popa
        
        mov al, bl
        add al, 48
        pusha
        mov bl,7
        call _fix
        popa

    ret
