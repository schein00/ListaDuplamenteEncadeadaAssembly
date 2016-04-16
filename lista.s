# Trabalho Organizacao de computadores
#
#
#
			.data
menu:   	.asciiz		"\n\n-  Lista Ordenada  -\n-       MENU       -
					\n1 - Incluir Elemento
					\n2 - Excluir Elemento por indice
					\n3 - Excluir Elemento por valor
					\n4 - Mostrar Lista Ordenada
					\n5 - Mostrar Totais					
					\n6 - Sair					
					\n\nopcao: "

txt_invalida: 	.asciiz		"OPCAO INVALIDA\n"
txt_valor: 		.asciiz		"Entre com o valor a ser inserido: "
txt_indice: 	.asciiz		"Entre com o indice do valor a ser removido: "	
txt_ind_inex:	.asciiz 	"Indice Inexistente\n"				
txt_val_inex:	.asciiz 	"Valor Inexistente\n"	
txt_valor_rem: 	.asciiz		"Entre com o valor a ser removido: "
txt_vazia: 		.asciiz		"Lista Vazia \n"
txt_sair: 		.asciiz		"SAIR \n"
txt_total_inc: 	.asciiz		"\n\nTotal de inclusoes: "
txt_total_exc:	.asciiz		"\nTotal de exclusoes: "
txt_lista: 		.asciiz		"Lista: "
txt_espaco: 	.asciiz		" "
txt_posicao:	.asciiz     "Posicao Inserida: "
txt_vremovido:	.asciiz		"Valor Removido: "
txt_iremovido:	.asciiz		"Indice Removido: "
		
		.text
		
main: 
		add $t9, $zero, $ra
		add $s0, $zero, $zero  # $s0 é o registrador apontador para o início da lista
		add $s1, $zero, $zero  # $s1 contador de inserções
		add $s2, $zero, $zero  # $s2 contador de exclusõesz
	
mostra_menu:
		li	$v0, 4			
		la	$a0, menu
		syscall
