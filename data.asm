	; Questão 1
printf10 db "10" , 0
valor db 0, 0, 0, 0
valor2 db 0, 0, 0, 0
vazio db "" , 0
enunciado1 db "Digite um numero n para calcular o n-esimo termo da sequencia de fibbonacci, x. O programa consiste em fazer a operacao x(mod 11) e printar seu resultado." , 0
	; Questão 2
menor: times 100 db 0
maior: times 100 db 0
enunciado2 db "Digite uma palavra e em segida digite uma letra para saber a frequencia dessa letra na palavra" , 0
	; Questão 3
string db 0, 0
enunciado3 db "Digite os valores de X, Y, Z e W, respectivamente, para entao efetuar o calculo de (X*Y)+(Z*W)-(X/Z)+(W/Y) e retornar se seu resultado e par ou impar." , 0
string2 db " -> Par" , 0
string3 db " -> Impar" , 0
string4 db "Resultado: " , 0
resultado3 db 0, 0, 0, 0
	; Questão 4
enunciado4 db "Digite uma data para calcular o numero que representa essa data na numerologia(para isso sera somado todos os algarismos da data, e das somas subsequentes,ate termos um numero entre 1-9)", 0


	; Questão 5
enunciado5 db "Digite um numero de 0 a 15 para printar uma frase de acordo com a lista de cores da BIOS." , 0
stringImpressa db "Como e facil trocar a cor", 0
numeroLido db 0,0,0









