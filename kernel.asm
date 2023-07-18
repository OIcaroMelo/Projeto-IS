org 0x7e00
jmp 0x0000:start

%define blackColor 0
%define darkGreenColor 2
%define redColor 4
%define lightGrey 7
%define greenColor 10
%define yellowColor 14
%define whiteColor 15

%include "functions.asm"
%include "questoes.asm"
%include "data.asm"

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

get_password:
	xor cl,cl
	loop_get_password:
		mov ah,0
		int 16h
		cmp al,08h 
		je key_backspace_password
		cmp al,0dh 
		je key_enter_password
		cmp cl,0fh 
		je loop_get_password 

		mov byte [di],al
		inc di
		mov al,'*'
		mov ah,0eh
		int 10h
		inc cl
	jmp loop_get_password

	key_backspace_password:
		cmp cl,0
		je loop_get_password 

		dec di 
		mov byte [di],0 
		dec cl 

		mov ah,0eh
		mov al,08h 
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

cursorApp:
	drawer blackColor
	call cursor_app1
	drawer yellowColor
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

menu:
	call initVideo
	call draw_logo_background 
	call draw_border 
	call draw_box_app 
	setText 1, 16, title, yellowColor
	setText 6, 3, app1, yellowColor
	setText 6, 26, app2, yellowColor
	setText 13, 3, app3, yellowColor
	setText 13, 26, app4, yellowColor
	setText 20, 3, app5, yellowColor
	setText 20, 28, app6, yellowColor
	call first_cursor 

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
	mov ah, 02h 
	mov bh, 0   
	mov dl, 1
	inc dh
	int 10h
jmp teclado

delete_endline:
	cmp dh, 2 
	je teclado

	mov al, ' '
	mov ah, 09h 
	mov bh, 0 
	mov bl, whiteColor 
	int 10h

	mov ah, 02h 
	mov bh, 0 
	dec dh
	mov dl, 100
	int 10h

jmp teclado

backspace:
	cmp dl, 1
	je delete_endline

	mov al, ' '
	mov cx, 1
	mov ah, 09h 
	mov bh, 0   
	mov bl, whiteColor 
	int 10h

	mov ah, 02h 
	dec dl 
	mov bh, 0 
	int 10h

jmp teclado


teclado:
	mov ah, 0 
	int 16h 

	cmp al, 8
	je backspace
	cmp al, 27
	je menu
	cmp dl, 100
	je endline
	
	mov ah, 02h 
	mov bh, 0 
	inc dl
	int 10h

	mov ah, 09h 
	mov bh, 0 
	int 10h

jmp teclado

strcmp:
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

get_input:
	xor cl,cl 
	loop_get_input:
		mov ah,0
		int 16h
		cmp al,08h 
		je key_backspace_input
		cmp al,0dh 
		je key_enter_input
		cmp cl,28h 
		je loop_get_input 

		mov ah,0eh
		int 10h
		mov byte [di],al
		inc di
		inc cl
	jmp loop_get_input

	key_backspace_input:
		cmp cl,0
		je loop_get_input 

		dec di 
		mov byte [di],0 
		dec cl 

		mov ah,0eh
		mov al,08h 
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

manga_positions:
	position 25, 141
	ret

draw_logo_background: 
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
		call manga_positions
		inc cx
		jmp .for2
	.endfor2:
		inc dx
		jmp .for1
	.endfor1:
	ret

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

loading_app:
	call initVideo
	call draw_logo
	call loading_limit
	call loading
ret

exitq:
	call draw_esc_button
	call getchar
	cmp al, 27
	je menu
	jmp exitq

first_cursor:
	call cursorApp
	drawCursor 85, 54, 67, 98

  call getchar

  cmp al, 13
  je init_q1 
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

init_q1:
	call loading_app
	call initVideo
	
	call _questao1
	jmp exitq

second_cursor:
	call cursorApp
	drawCursor 85, 109, 122, 98

  call getchar

  cmp al, 13
	je init_q2
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

init_q2:
	call loading_app
	call initVideo

	call _questao2
	jmp exitq

third_cursor:
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

init_q3:
	call loading_app
	call initVideo

	call _questao3
	jmp exitq


fourth_cursor:
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

init_q4:
	call loading_app
	call initVideo

	call _questao4
	jmp exitq

fifth_cursor:
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

init_q5:
	call loading_app
	call initVideo

	call _questao5
	jmp exitq

sixth_cursor:
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

about_app:
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
			push dx 
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
	
hold:
	call getchar
	cmp al, 27
	je menu
	cmp al, ' '
	jne hold
ret

video:
	mov ah, 0 
	mov al, 12h
	int 10h
ret

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
		mov ah, 86h 
		mov cx, 1	
		xor dx, dx 
		mov dx, 5	
		int 15h
	ret

loading_unit_off:
	mov ax,0x0c00 
	mov bh,0x00
	mov dx, 160
	loop_loading_unit_off:
		int 10h
		inc dx
		cmp dx, 170
		jne loop_loading_unit_off
	ret 

loading_limit:
	mov ax,0x0c0f 
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
	mov ax,0x0c0e 
	mov bh,0x00
	mov dx, 160
	loop_loading_unit:
		int 10h	
		inc dx
		cmp dx, 170
		jne loop_loading_unit
	ret 
