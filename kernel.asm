org 0x7e00
jmp 0x0000:start

%include "fuctions.asm"
%include "questoes.asm"

opcao db 0, 0
opcao3 db "3. Acessar questao 3", 0
opcao6 db "6. Acessar questao 6", 0

data:

start:
    mov ax, 0
    mov ds, ax

    mov ah, 0
    mov bh, 10h
    int 10h

    mov ah, 0xb
    mov bh, 0
    mov bl, 1
    int 10h

    mov si, opcao3
    call printString
    call endl
    mov si, opcao6
    call printString
    call endl

    mov di, opcao
    call gets
    mov si, opcao
    call stoi

    cmp ax, 6
    je .q6
    .q3:
        call _questao3
        jmp .end
    .q6:
        call _questao6
        jmp .end
    .end:
jmp $