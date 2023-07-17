org 0x7e00
jmp 0x0000:start

%define blackColor 0
%define darkGreenColor 2
%define redColor 4
%define greenColor 10
%define yellowColor 14
%define whiteColor 15
;%include "functions.asm"
;%include "questoes.asm"
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


;olá amigo, vamos começar nossa jornada aqui
;os bagulho ai em cima são algumas definições que usei para pintar a manga e etc
;esse start ai em baixo só faz carregar a animação bunitinha da manga e tals
;
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
;
start:
	call initVideo
	call login
	system:
	call initVideo
	setText 15, 16, title, yellowColor
	call draw_logo
	call delay
	call menu
jmp $

;esse bagulho de senha foi do projeto de lk
;então acho que daqui a pouco vou tirar essa merda

get_password:
	xor cl,cl ;zera variavel cl (sera usada como contador)
	loop_get_password:
		mov ah,0
		int 16h
		cmp al,08h ;backspace teclado?
		je key_backspace_password
		cmp al,0dh ;enter teclado?
		je key_enter_password
		cmp cl,0fh ;15 valores ja teclados?
		je loop_get_password ;só aceita backspace ou enter

		mov byte [di],al
		inc di
		mov al,'*'
		mov ah,0eh
		int 10h
		inc cl
	jmp loop_get_password

	key_backspace_password:
		cmp cl,0
		je loop_get_password ;n faz sentido apagar string vazia

		dec di ;volta dl pra o caractere anterior
		mov byte [di],0 ;zera o valor daquela posicao
		dec cl ;diminui o contador em 1

		mov ah,0eh
		mov al,08h ;imprime backspace(volta o cursor)
		int 10h

		mov al,' '
		int 10h

		mov al,08h 
		int 10h
	jmp loop_get_password

	key_enter_password:
		mov al,0
		mov byte[di],al

		mov ah,0eh
		mov al,0dh
		int 10h
		mov al,0ah
		int 10h
	ret

login:
	getspassword:
		simplePrintf stringusuario, whiteColor
		mov di, stringname
		call get_input
		simplePrintf string_senha, whiteColor
		mov di,password
		call get_password
		
		jmp comp_pass
	comp_pass:
		simplePrintf String_senha2, whiteColor
		mov di, stringpassword
		call get_password
		mov si, stringpassword
		mov di, password
		call strcmp
		cmp al,1
		jne wrong
		jmp system
	wrong:
		simplePrintf stringwrongpassword, whiteColor
		call endl
	jmp comp_pass

;esse drawer só serve pra desenhar
%macro drawer 1
	mov ah, 0ch 
	mov al, %1
	mov bh, 0
%endmacro

;esse tbm só desenha
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

;mais desenho
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

;isso aqui é um mini cursor que fica no canto inferior direito das caixas de seleção
;basicamente só serve pra vc saber onde vc está
cursorApp:
	drawer blackColor
	call cursor_app1
	drawer yellowColor
	ret

getchar:
  mov ah, 00h
  int 16h
  ret

initVideo:
	mov ah, 00h
	mov al, 13h
	int 10h
	ret

printf_color:
	loop_print_string:
		lodsb
		cmp al,0
		je end_print_string
		mov ah,0eh
		int 10h
		jmp loop_print_string
	end_print_string:
	ret

;aqui é a parte gráfica do menu, onde coloquei questão1 2 3 etc
menu:
	call initVideo
	call draw_logo_background ; Desenha a borda
	call draw_border ; Escreve nome de cada APP
	call draw_box_app ; Desenha os retangulos
	setText 1, 16, title, yellowColor
	setText 6, 3, app1, yellowColor
	setText 6, 26, app2, yellowColor
	setText 13, 3, app3, yellowColor
	setText 13, 26, app4, yellowColor
	setText 20, 3, app5, yellowColor
	setText 20, 28, app6, yellowColor
	call first_cursor ; Inicia a aplicação

delay:
	mov ah, 86h
	mov cx, 30
	mov dx, 500
	int 15h
	ret

fast_delay:
	mov ah, 86h
	mov dx, 3000
	int 15h
	ret

endline:
	mov ah, 02h ; setar o cursor
	mov bh, 0   ; pagina
	mov dl, 1
	inc dh
	int 10h
jmp teclado

delete_endline:
	cmp dh, 2 ;Linha inicial
	je teclado

	mov al, ' '
	mov ah, 09h ; codigo para printar caractere apenas onde esta o cursor
	mov bh, 0   ; seta a pagina
	mov bl, whiteColor  ; seta a cor do caractere, nesse caso, branco
	int 10h

	mov ah, 02h ; setar o cursor
	mov bh, 0   ; pagina
	dec dh
	mov dl, 100
	int 10h

jmp teclado

backspace:
	cmp dl, 1
	je delete_endline

	mov al, ' '
	mov cx, 1
	mov ah, 09h ; codigo para printar caractere apenas onde esta o cursor
	mov bh, 0   ; seta a pagina
	mov bl, whiteColor  ; seta a cor do caractere, nesse caso, branco
	int 10h

	mov ah, 02h ; setar o cursor
	dec dl ; coluna --
	mov bh, 0   ; pagina
	int 10h

jmp teclado


teclado:
	mov ah, 0   ; prepara o ah para a chamada do teclado
	int 16h     ; interrupcao para ler o caractere e armazena-lo em al

	cmp al, 8
	je backspace
	cmp al, 27
	je menu
	cmp dl, 100
	je endline
	
	mov ah, 02h ; setar o cursor
	mov bh, 0   ; pagina
	inc dl
	int 10h

	mov ah, 09h ; codigo para printar caractere apenas onde esta o cursor
	mov bh, 0   ; seta a pagina
	int 10h

jmp teclado

strcmp:;di é a constante ;autoexplicativo
	strcmp_loop:
		mov al,byte [di]
		inc di
		mov ah,byte [si]
		inc si
		cmp al,0
		je eq
		cmp ah,al
		jne dif
		jmp strcmp_loop
	eq:
		mov al,1
		jmp strcmp_end
	dif:
		xor al,al
	strcmp_end:
	ret

get_input:;autoexplicativo
	xor cl,cl ;zera variavel cl (sera usada como contador)
	loop_get_input:
		mov ah,0
		int 16h
		cmp al,08h ;backspace teclado?
		je key_backspace_input
		cmp al,0dh ;enter teclado?
		je key_enter_input
		cmp cl,28h ;40 valores ja teclados?
		je loop_get_input ;só aceita backspace ou enter

		mov ah,0eh
		int 10h
		mov byte [di],al
		inc di
		inc cl
	jmp loop_get_input

	key_backspace_input:
		cmp cl,0
		je loop_get_input ; n faz sentido apagar string vazia

		dec di ; volta dl pra o caractere anterior
		mov byte [di],0 ; zera o valor daquela posicao
		dec cl ; diminui o contador em 1

		mov ah,0eh
		mov al,08h ; imprime backspace(volta o cursor)
		int 10h

		mov al,' '
		int 10h

		mov al,08h 
		int 10h
	jmp loop_get_input

	key_enter_input:
		mov al,0
		mov byte[di],al

		mov ah,0eh
		mov al,0dh
		int 10h
		mov al,0ah
		int 10h
	ret
draw_logo:
	mov si, manga
	mov dx, 0            ; Y
	mov bx, si
	add si, 2
	.for1:
		cmp dl, byte[bx+1]
		je .endfor1
		mov cx, 0        ; X
	.for2:
		cmp cl, byte[bx]
		je .endfor2
		lodsb
		push dx
		push cx
		mov ah, 0ch
		add dx, 70
		add cx, 140
		int 10h
		pop cx
		pop dx
		inc cx
		jmp .for2
	.endfor2:
		inc dx
		jmp .for1
	.endfor1:
	ret

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

manga_positions:
	position 25, 141
	ret

draw_logo_background: 
	mov si, manga
	mov dx, 0            ; Y
	mov bx, si
	add si, 2
	.for1:
		cmp dl, byte[bx+1]
		je .endfor1
		mov cx, 0        ; X
	.for2:
		cmp cl, byte[bx]
		je .endfor2
		lodsb
		call manga_positions
		inc cx
		jmp .for2
	.endfor2:
		inc dx
		jmp .for1
	.endfor1:
	ret

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
	mov al, whiteColor ; Voltando a cor original
%endmacro

;aqui são as caixas onde ficam os nomes questao 1 2 3 etc
box_app1: 
	drawSquare 20, 145, 100, 180
	blackBackgroundApp 21, 146, 100, 180
box_app2:
	drawSquare 200, 35, 280, 70
	blackBackgroundApp 201, 36, 280, 70
box_app3:
	drawSquare 200, 90, 280, 125
	blackBackgroundApp 201, 91, 280, 125
box_app4:
	drawSquare 200, 145, 280, 180
	blackBackgroundApp 201, 146, 280, 180
box_app5:
	drawSquare 20, 35, 100, 70
	blackBackgroundApp 21, 36, 100, 70
box_app6:
	drawSquare 20, 90, 100, 125
	blackBackgroundApp 21, 91, 100, 125
ret

;isso aqui desenha a caixa
draw_box_app:
	drawer whiteColor
	call box_app1
ret

draw_border:
	drawer whiteColor
	mov cx, 0
	.draw_seg:
		mov dx, 0
		int 10h
		mov dx, 199
		int 10h
		inc cx
		cmp cx, 319
		je .end_column
		jmp .draw_seg
	.end_column:
		mov dx, 0
	.draw_columns:
		mov cx, 0
		int 10h
		mov cx, 319
		int 10h
		inc dx
		cmp dx, 199
		jne .draw_columns
	ret

draw_white_border:
	mov ah, 0ch 
	mov al, whiteColor
	mov bh, 0
	mov cx, 0
	.draw_seg:
		mov dx, 0
		int 10h
		mov dx, 198
		int 10h
		inc cx
		cmp cx, 319
		je .end_column
		jmp .draw_seg
	.end_column:
		mov dx, 0
	.draw_columns:
		mov cx, 0
		int 10h
		mov cx, 319
		int 10h
		inc dx
		cmp dx, 198
		jne .draw_columns
	ret

;isso aqui é aquele cursor que falei anteriormente
cursor_app1: 
	drawCursor 85, 54, 67, 98
cursor_app2:
	drawCursor 85, 109, 122, 98
cursor_app3:
	drawCursor 85, 164, 177, 98
cursor_app4:
	drawCursor 265, 54, 67, 278
cursor_app5:
	drawCursor 265, 109, 122, 278
cursor_app6:
	drawCursor 265, 164, 177, 278
ret

;isso aqui é animação fofa de carregar a manga
loading_app:
	call initVideo
	call draw_logo
	call loading_limit
	call loading
ret

;aqui que começa os bagulho tenso
;basicamente são seis "cursores", cada um deles está associado a uma caixa de seleção de questão
;ou seja, first_cursor está associado à questão1
first_cursor:
	call cursorApp
	drawCursor 85, 54, 67, 98

  call getchar

  cmp al, 13
	je init_q1 ;isso aqui é o inicializador da questão1, vai ser nessa função init que o código da questão vai entrar
	cmp al, 'w'
  je third_cursor
	cmp al, 'a'
  je fourth_cursor
  cmp al, 's'
  je second_cursor
	cmp al, 'd'
  je fourth_cursor

  jmp first_cursor
ret

;é aqui onde vcs vão colocar o código da questão 1
init_q1:
	call loading_app;isso aqui é o gráfico fofo da manga
	call initVideo
	;call draw_mango;manga fofa
	call draw_esc_button;isso aqui é só um botão de esc, puramente estético

    ;------ coloque o código abaixo desse linha -------
	xor ax,ax
	xor bx,bx
	xor cx,cx
	xor dx,dx

	mov ah,00h
    mov al,13h
    int 10h

    mov bh,0
    mov bl,0xf


	mov di, valor
    call get_input
    mov si, valor
    call stoi

    xor bx,bx
	xor cx,cx

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
    setText 9, 0, valor, 15

    ;------ final da questão ------

	exitq1: ;isso aqui serve pra checar de o usuário apertou esc, se sim ele volta para o menu
		call getchar
		cmp al, 27
	je menu
jmp exitq1

second_cursor:;aqui é o cursor da segunda questão
	call cursorApp
	drawCursor 85, 109, 122, 98

  call getchar

  cmp al, 13
	je init_q2;inicializador
	cmp al, 'w'
  je first_cursor
	cmp al, 'a'
  je fifth_cursor
  cmp al, 's'
  je third_cursor
	cmp al, 'd'
  je fifth_cursor

  jmp second_cursor
ret

init_q2:;segunda questão
	call loading_app
	call initVideo
	call draw_mango

	call draw_esc_button

	exitq2:
		call getchar
		cmp al, 27
	je menu
jmp exitq2


third_cursor:;enfim, mesmo esquema, acredito que até aqui esteja dando pra entender
	call cursorApp
	drawCursor 85, 164, 177, 98

  call getchar
  
	cmp al, 13
  je init_q3
	cmp al, 'w'
  je second_cursor
	cmp al, 'a'
  je sixth_cursor
  cmp al, 's'
  je first_cursor
	cmp al, 'd'
  je sixth_cursor

  jmp third_cursor
ret

init_q3:;terceira questão
	
	call loading_app
	call initVideo
	call draw_esc_button
	;call draw_mango
	;
	xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx
    
    mov ds, ax

	mov ah,00h
    mov al,13h
    int 10h

    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx
	
    setText 0, 0, string1, 15 
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

    setText 9, 0, string4, 15
    pop dx
    pop ax
    push dx


    pop dx
    cmp dx, 1
    je .diff
    .equal:
        setText 9, 10, string2, 15
		jmp exitq3
    .diff:
		setText 9, 10, string2, 15
		jmp exitq3
	;
	exitq3:
		call getchar
		cmp al, 27
	je menu
jmp exitq3


endl:;função fds de end line
	mov ax,0x0e0a
	int 10h
	mov al,0x0d
	int 10h
	ret



fourth_cursor:;quarta questão
	call cursorApp
	drawCursor 265, 54, 67, 278

  call getchar
  
	cmp al, 13
	je init_q4
	cmp al, 'w'
  je sixth_cursor
	cmp al, 'a'
  je first_cursor
  cmp al, 's'
  je fifth_cursor
	cmp al, 'd'
  je first_cursor

  jmp fourth_cursor
ret

init_q4:;quarta questão
	call loading_app
	call initVideo
	call draw_mango



	call draw_esc_button

	exitq4:
		call getchar
		cmp al, 27
	je menu
jmp exitq4

fifth_cursor:;quinta questão
	call cursorApp
	drawCursor 265, 109, 122, 278

  call getchar

  cmp al, 13
	je init_q5
	cmp al, 'w'
  je fourth_cursor
	cmp al, 'a'
  je second_cursor
  cmp al, 's'
  je sixth_cursor
	cmp al, 'd'
  je second_cursor

  jmp fifth_cursor
ret

init_q5:;quinta questão
	call loading_app
	call initVideo

	
    xor ax,ax
    xor bx,bx 

    mov ah,00h
    mov al,13h
    int 10h
    
	xor ax,ax

    mov bh,0
    mov bl,0xf
    
    mov di, numeroLido
    call get_input

    mov si, numeroLido
    call stoi  

    setText 1, 0, stringImpressa, ax

	exitq5:
		call getchar
		cmp al, 27
	je menu
jmp exitq5

sixth_cursor:;esse aqui é um menu que mostra as informações gerais do SO
	call cursorApp
	drawCursor 265, 164, 177, 278

  call getchar
  cmp al, 13
	je about_app
	cmp al, 'w'
  je fifth_cursor
	cmp al, 'a'
  je third_cursor
  cmp al, 's'
  je fourth_cursor
	cmp al, 'd'
  je third_cursor

  jmp sixth_cursor
ret

about_app:;então por exemplo, coloquei os nossos nomes, o nome do PC, o nome da empresa etc
;é só estético msm, pra ficar fofo
	call initVideo
	setText 1, 16, spec, yellowColor
	setText 4, 3, nomePc, yellowColor
	setText 4, 24, nomePc1, yellowColor
	setText 7, 3, empresa, yellowColor
	setText 7, 24, empresa1, yellowColor
	setText 10, 3, edicao, yellowColor
	setText 10, 24, edicao1, yellowColor
	setText 13, 3, grupo, yellowColor
	setText 13, 24, grupo1, yellowColor
	setText 16, 24, grupo2, yellowColor
	setText 19, 24, grupo3, yellowColor
	
	call draw_white_border
	call draw_esc_button
	call getchar
	cmp al, 27
	je menu
jmp about_app

draw_mango: 
	mov si, manga
	mov dx, 0           
	mov bx, si
	add si, 2
	.for1:
		cmp dl, byte[bx+1]
		je .endfor1
		mov cx, 0       
		.for2:
			cmp cl, byte[bx]
			je .endfor2
			lodsb
			push dx ; Draw pixel
			push cx
			mov ah, 0ch
			add dx, 50
			add cx, 130
			int 10h
			pop cx
			pop dx
			inc cx
			jmp .for2
		.endfor2:
		inc dx
		jmp .for1
	.endfor1:
	ret

draw_esc_button:
	mov si, esc_button
	mov dx, 0            ; Y
	mov bx, si
	add si, 2
	.for1:
		cmp dl, byte[bx+1]
		je .endfor1
		mov cx, 0        ; X
	.for2:
		cmp cl, byte[bx]
		je .endfor2
		lodsb
		push dx
		push cx
		mov ah, 0ch
		add dx, 2
		add cx, 2
		int 10h
		pop cx
		pop dx
		inc cx
		jmp .for2
	.endfor2:
		inc dx
		jmp .for1
	.endfor1:
	ret

data:;aqui é onde eu coloquei os nomes nas caixas de seleção
;se quiser mudar fique a vontade
	; SO interface
	title db 'MangoOS', 0
	app1 db 'Questao 1', 0
	app2 db 'Questao 4', 0
	app3 db 'Questao 2', 0
	app4 db 'Questao 5', 0
	app5 db 'Questao 3', 0
	app6 db 'About', 0
	
	
;esses bagulho em baixo é caso vcs queiram printar algo na tela quando entrar nas questões
;de certa forma é desnecessário, então rlx

	; Questão 1
	valor db 0, 0, 0, 0
	valor2 db 0, 0, 0, 0
	; Questão 2

	; Questão 3
	string db 0, 0
	string1 db "Digite os valores de X, Y, Z e W, respectivamente, para entao efetuar o calculo de (X*Y)+(Z*W)-(X/Z)+(W/Y) e retornar se seu resultado e par ou impar." , 0
	string2 db " -> Par" , 0
	string3 db " -> Impar" , 0
	string4 db "Resultado: " , 0
	; Questão 4

	; Questão 5
		stringImpressa db "Como e facil trocar a cor", 0
		numeroLido db 0,0,0
	; About
	;nosso grupin bala
	spec db 'SO Specs', 0
	nomePc db 'Nome do PC', 0                       
	nomePc1 db 'manguinha', 0
	empresa db 'Empresa', 0
	empresa1 db 'MangaCoorp', 0
	edicao db 'Versao da maquina', 0
	edicao1 db '1.20.1', 0
	grupo db 'Grupo responsavel',0
	grupo1 db 'Icaro Melo', 0
	grupo2 db 'Isabella Vittori', 0
	grupo3 db 'Rodrigo Pontes', 0

	ESC db 'ESC', 0

	; Login
	;bagulho de login, talvez eu tire depois
	stringusuario db 'Username:', 0
	string_senha db 'Create Password:',0
	String_senha2 db 'Confirm password:',0
	stringwrongpassword db 'Incorrect Password.',0
	stringpassword times 16 db 0
	password times 16 db 0
	
	stringname times 16 db 0
	stringinput times 40 db 0

;isso aqui em baixo são os 1050 pixels da manga
;demorou 2h pra fazer essa merda kkk
manga db 35, 30, 0, 0, 0, 0, 0, 0, 0, 0, 10, 10, 10, 10, 2, 2, 0, 0 ,0 ,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 10, 10, 10, 10, 10, 10, 10, 10, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 10, 2, 2, 10, 10, 10, 10, 10, 10, 10, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 2, 10, 10, 10, 10, 10, 2, 2, 2, 2, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 10, 10, 10, 10, 2, 2, 0, 0, 12, 12, 12, 12, 14, 14, 14, 14, 14, 14, 14, 14, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 10, 10, 10, 2, 2, 0, 0, 0, 12, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 0, 0, 0, 0, 12, 14, 14, 15, 15, 15, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14, 14, 14, 14, 15, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14, 14, 14, 14, 15, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14, 14, 14, 15, 15, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 12, 0, 0, 0, 0, 0, 0, 0 ,0 ,0 ,0, 0, 0, 0, 0, 14, 14, 14, 15, 15, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 12, 0 ,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14, 14, 14, 15, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14, 14, 14, 15, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 12, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 , 0, 0 , 0 ,0, 14, 14, 14, 15, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 12, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 , 0, 0, 0, 0, 14, 14, 14, 15, 15, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14, 14, 14, 14, 15, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 12, 0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0, 14, 14, 14, 14, 15, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 12, 0 ,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14, 14, 14, 15, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 12, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 12, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 12, 4, 12, 14, 14, 14, 14, 14, 14, 12, 12, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  

esc_button db 15, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 4, 15, 15, 15, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 4, 15, 12, 4, 4, 15, 15, 15, 4, 15, 15, 15, 4, 0, 0, 4, 15, 15, 15, 4, 15, 12, 4, 4, 15, 4, 4, 4, 0, 0, 4, 15, 4, 4, 4, 15, 15, 15, 4, 15, 4, 4, 4, 0, 0, 4, 15, 4, 4, 4, 4, 4, 15, 4, 15, 4, 4, 4, 0, 0, 12, 15, 15, 15, 4, 15, 15, 15, 4, 15, 15, 15, 12, 0, 0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0


;algumas funções meio fds
hold:
	call getchar
	cmp al, 27
	je menu
	cmp al, ' '
	jne hold
ret

video:
	mov ah, 0 ; Set video mode
	mov al, 12h
	int 10h
ret

%macro setColor 1
  mov ah, 0ch
	mov bh, 0
	mov al, %1 ; cor
	int 10h
%endmacro

%macro setBackground 1
	mov ah, 0x0
	mov bh, 0
	mov bl, %1
	int 10h
%endmacro

loading:
	mov cx, 50
	loop_loading:
		call loading_unit
		inc cx
		push cx
		xor cx, cx
		call fast_delay
		pop cx
		cmp cx, 250
		jne loop_loading
		mov ah, 86h; INT 15h / AH = 86h
		mov cx, 1	
		xor dx, dx ;CX:DX = interval in microseconds
		mov dx, 5	
		int 15h
	ret

loading_unit_off:
	mov ax,0x0c00 ;Write graphics pixel, preto
	mov bh,0x00
	mov dx, 160
	loop_loading_unit_off:
		int 10h
		inc dx
		cmp dx, 170
		jne loop_loading_unit_off
	ret 

loading_limit:
	mov ax,0x0c0f ;Write graphics pixel,white
	mov bh,0x00
	mov dx, 160
	loop_loading_limit:
		mov cx, 49
		int 10h
		mov cx, 250
		int 10h
		inc dx
		cmp dx, 170
		jne loop_loading_limit
	ret

loading_unit:
	mov ax,0x0c0e ;Write graphics pixel, amarelo
	mov bh,0x00
	mov dx, 160
	loop_loading_unit:
		int 10h	
		inc dx
		cmp dx, 170
		jne loop_loading_unit
	ret 
;acabou :)
