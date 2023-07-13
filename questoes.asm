string db 0, 0
string1 db "Digite os valores de X, Y, Z e W, respectivamente, para entao efetuar o calculo de (X*Y)+(Z*W)-(X/Z)+(W/Y) e retornar se seu resultado e par ou impar." , 0
string2 db " -> Par" , 0
string3 db " -> Impar" , 0
string4 db "Resultado: " , 0

valor db 0, 0, 0, 0
valor2 db 0, 0, 0, 0

_questao3:
    mov ax, 0
    mov ds, ax

    mov ah, 0
    mov bh, 10h
    int 10h

    mov ah, 0xb
    mov bh, 0
    mov bl, 1
    int 10h

    mov si, string1
    call printString
    call endl

    mov di, string
    call gets
    mov si, string
    call stoi
    push ax

    mov di, string
    call gets
    mov si, string
    call stoi
    pop bx
    push ax
    mul bx
    push ax
    push bx

    mov di, string
    call gets
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
    call gets
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

    mov si, string4
    call printString
    pop dx
    pop ax
    push dx
    mov di, string
    call tostring
    mov si, string
    call printString

    pop dx
    cmp dx, 1
    je .diff
    .equal:
        mov si, string2
        call printString
        ret
    .diff:
        mov si, string3
        call printString
        ret

_questao6:
    mov di, valor
    call gets
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

    mov di, valor2
    call tostring
    mov si, valor2
    call printString

    ret