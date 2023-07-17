gets:
    xor cx, cx
    .loop1
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

;getchar:
;    mov ah, 0x00
;    int 16h
;ret

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

;endl:
;    mov al, 0x0a
;    call putchar
;    mov al, 0x0d
;    call putchar
;ret

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