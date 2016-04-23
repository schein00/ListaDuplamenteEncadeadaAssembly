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
txt_posicao:	.asciiz     	"Posicao Inserida: "
txt_vremovido:	.asciiz		"Valor Removido: "
txt_iremovido:	.asciiz		"Indice Removido: "
marcador:		.asciiz		"entro"	

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

le_opcao:
		li	$v0, 5			
		syscall
		add	$t0, $zero, $v0		#carrega valor lido em $t0
		li	$v0, 4	

		#faz desvio para a funcao que foi selecionada no menu
compara_e_desvia:
		addi $t1, $zero, 1
		beq  $t0, $t1, op_insere
		addi $t1, $zero, 2
		beq  $t0, $t1, op_excluii		
		addi $t1, $zero, 3
		beq  $t0, $t1, op_excluiv		
		addi $t1, $zero, 4
		beq  $t0, $t1, op_mostra
		addi $t1, $zero, 5
		beq  $t0, $t1, op_sair
		addi $t1, $zero, 6
		beq  $t0, $t1, op_sair
		
imprime_opcao_invalida:		
		la	$a0, txt_invalida
		syscall	
		j mostra_menu
		
op_sair:
		la	 $a0, txt_total_inc
		li   $v0, 4
		syscall
		add	 $a0, $zero, $s2
		li   $v0, 1
		syscall			
		la	 $a0, txt_total_exc
		li   $v0, 4
		syscall	
		add	 $a0, $zero, $s3
		li   $v0, 1
		syscall			
		jr $t9
		
op_insere: 
		la	$a0, txt_valor
		syscall		
		li	$v0, 5			
		syscall
		add	$a1, $zero, $v0		# carrega valor lido em $a1		
		add $a0, $zero, $s0		# carrega inicio da lista em $a0
		jal  insert
		addi $s2, $s2, 1		# incrementa contador de inserções
		add  $t0, $zero, $v0 	
		li	$v0, 4			
		la	$a0, txt_posicao
		syscall	
		add  $a0, $zero, $t0		
		li	$v0, 1			
		syscall
		j   mostra_menu
		
op_excluii:
		j mostra_menu
		
op_excluiv: 
		j mostra_menu
		
op_mostra:
		add $a0, $zero, $s0		# carrega inicio da lista em $v0
		jal  mostra_lista
		addi $t0, $zero, -1
		beq  $v0, $t0, imprime_lista_vazia		
		j   mostra_menu


		imprime_indice_nao_encontrado:		
		la	 $a0, txt_ind_inex
		li   $v0, 4
		syscall
		j    mostra_menu		
		add  $t0, $zero, $v0 
		li	 $v0, 4			
		la	 $a0, txt_vremovido
		syscall	
		add  $a0, $zero, $t0		
		li	 $v0, 1			
		syscall		
		j   mostra_menu


		
##################################################
# Insere um item na lista duplamente encadeada	 #		
##################################################
insert: 
		add $t0, $zero, $a0					# copia posição do inicio da lista
		add $t1, $zero, $a1 				# copia valor a ser inserido

		# sempre que a funcao insert é executada é criado um nodo, mesmo que nao seja usado por algum erro
		li	$a0, 12			 	# quantidade de bytes de memória a ser alocado
		li	$v0, 9
		syscall	
		sw $t1, 4($v0)     		# coloca valor na memoria
		sw $zero, 0($v0)  		# indica o anterior como NULL
		sw $zero, 8($v0)		# indica o proximo como NULL
		
		beq $t0, $zero, insere_primeiro_elemento		
		# caso a lista estaja vazia, desvia para a funcao que insere o primeiro elemento
		
		lw $t4, $t0							# carrega em t4 o primeiro elemento da lista
		
		lw $t3, 4($t0) 						# copia para t3 o valo do primiero elemento da lista
		slt $t5, $t1 , $t3					# se valor a ser inserido for menor que o valor do primeiro nodo
		bne $t5, $zero, insere_no_incio		# quando o valor sera maior que o primeiro valor, sera inserido no inicio da lista
		
		addi $t3, $zero, 1
		bne $t5, $t3, loop_insere 		# se nao for menor que o primeiro sera inserido no meio ou no final da lista
		
		jr $ra

		
insere_primeiro_elemento: 
		
		add  $s0, $zero, $v0 	# faz inicio apontar para primeiro elemento
		addi $v0, $zero, 0 	  	# coloca 0 em $v0
		add $s4, $zero, $zero	# inicia contador de elementos (indices)
		jr $ra 					# depois de inserir o primeiro elemento retorna da chamada

insere_no_incio:
		
		
		sw $v0, 0($t4)
		sw $t4, 4($v0)
		sw $v0, $s1
		j mostra_menu
		
loop_insere:  			# loop que percore a lista ate encontrar a posicao onde sera inserido o novo nodo
		lw $t4, 8($t4)
		
		beq $t4, $zero, insere_fim

		lw $t3, 4($t4)
		slt $t5, $t1, $t3
		bne $t5, $zero, insere_meio
		beq $t5, $zero, loop_insere
		
		j mostra_menu
		
insere_meio:
		lw $t5, 0($t4)
		sw $t5, 0($v0)
		sw $v0, 8($t5)
		sw $v0, 0($t4)
		sw $t4, 8($v0)
		addi $s4, $s4, 1
		jr $ra		
		

insere_fim:
		sw $v0, 8($t4)
		sw $t4, 0($v0)
		addi $s4, $s4, 1
		jr $ra
		
##################################################
# Exclui um item na lista duplamente encadeada	 #
#	por valor 									 #		
##################################################
excluir_i:
		j mostra_menu

##################################################
# Exclui um item na lista duplamente encadeada	 #		
#	por indice									 #
##################################################
excluir_v:
		j mostra_menu

		
##################################################
# Nostra totais da lista duplamente encadeada	 #		
##################################################
mostrar_totais:
		j mostra_menu
		
##################################################
# Mosta a lista duplamente encadeada ordenada	 #		
##################################################
mostrar_lista:
		add $t0, $zero, $a0	# copia posição do inicio da lista
		bne $t0, $zero, segue_mostra
		addi $v0, $zero, -1		  # retorna -1
		jr  $ra
		
		
laco_mostra:
		lw $a0, 4 ($t0)
		li $v0, 1
		syscall
		
		la $a0, txt_espaco
		li $v0, 4
		syscall		
		
		lw $t0, 0 ($t0)
		bne $t0, $zero, laco_mostra
		jr $ra
		

