# Trabalho Organizacao de computadores

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
		beq  $t0, $t1, op_mostrar
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
		la	$a0, txt_valor
		syscall		
		li	$v0, 5	#pq 5?		
		syscall
		add $a1,$zero,$v0  #valorpararemover
		add $a2,$zero,$s0  #inicio da lista
		sw $s2, ($t9)
				
		bne $t9,$zero,excluir_i	#verificasealistaévazia
		j mostra_menu		
op_excluiv: 
		la	$a0, txt_valor
		syscall		
		li	$v0, 5	#pq 5?		
		syscall
		add $a1,$zero,$v0  #valorpararemover
		add $a2,$zero,$s0  #inicio da lista
		sw $s2, ($t9)
				
		bne $t9,$zero,excluir_v	#verificasealistaévazia
		j mostra_menu
		
op_mostrar:
		add $a0, $zero, $s0		# carrega inicio da lista em $v0
		jal mostrar_lista
		addi $t0, $zero, -1
		beq  $v0, $t0, imprime_lista_vazia		
		jal   mostra_menu

##################################################
# Mosta a lista duplamente encadeada ordenada	 #		
##################################################		
segue_mostra:
		li $v0, 4
		la	$a0, txt_lista
		syscall
		
		
laco_mostra:
		lw $a0, 4($t0)
		li $v0, 1
		syscall
		
		la $a0, txt_espaco
		li $v0, 4
		syscall		
		
		lw $t0, 8($t0)
		bne $t0, $zero, laco_mostra
		jr $ra

mostrar_lista:
		add $t0, $zero, $a0						# copia posição do inicio da lista
		bne $t0, $zero, segue_mostra			# se a lista nao for vazia imprime a lista
		beq $t0, $zero, imprime_lista_vazia		# se a lista estiver vazia informa
		addi $v0, $zero, -1		  				# retorna -1
		jr  $ra
		
imprime_lista_vazia:
		li $v0, 4
		la	$a0, txt_vazia
		syscall
		jr $ra

###################################
# fim funcao mostrar lista


##################################################
# Insere um item na lista duplamente encadeada	 #		
##################################################	
insere_primeiro_elemento:		
		add  $s0, $zero, $t6 						# faz inicio apontar para primeiro elemento
		addi $v0, $zero, 0 	  						# coloca 0 em $v0
		jr $ra 										# depois de inserir o primeiro elemento retorna da chamada
	
insert: 
		add $t0, $zero, $a0							# copia posição do inicio da lista
		add $t1, $zero, $a1 						# copia valor a ser inserido
													# sempre que a funcao insert é executada é criado um nodo, mesmo que nao seja usado por algum erro
		li	$a0, 12			 						# quantidade de bytes de memória a ser alocado
		li	$v0, 9
		syscall	
		add $t6, $zero, $v0
		sw $t1, 4($t6)     							# coloca valor na memoria
		sw $zero, 0($t6)  							# indica o anterior como NULL
		sw $zero, 8($t6)							# indica o proximo como NULL		
		bne $t0, $zero, insere_lista 				# caso a lista nao estaja vazia, desvia para a funcao que insere na lista
		beq $t0, $zero, insere_primeiro_elemento	# caso a lista esteja vazia devia para a funcao insere primeiro elemento
		jr $ra
		
insere_lista:
 
		lw $t3, 4($s0) 								# copia para t3 o valo do primiero elemento da lista
		slt $t5, $t1 , $t3							# se valor a ser inserido for menor que o valor do primeiro nodo
		addi $t3, $zero, 1							# define t3 como 1 para teste do desvio condicional
		bne $t5, $zero, insere_no_incio				# quando o valor sera maior que o primeiro valor, sera inserido no inicio da lista
		add $t4, $zero, $s0							# t4 sera o reposavel por passar pelos nodos
		bne $t5, $t3, loop_insere 					# se nao for menor que o primeiro sera inserido no meio ou no final da lista
		jr $ra
		
insere_no_incio:									# quando o valor a ser inserido é menor que o valor do primeiro elemento da lista
		sw $t6, 0($s0)								# proximo do novo nodo sera o incio da lista
		sw $s0, 8($t6)								# anterior do inicio da fila aponta para o novo nodo
		add $s0, $zero, $t6							# ponteiro do comeco da lista aponta para no novo nodo
		jr $ra

		
loop_insere:  										# loop que percore a lista ate encontrar a posicao onde sera inserido o novo nodo
		add $t8, $zero, $t4
		lw $t4, 8($t4)								# salva qual é o nodo anterior
		beq $t4, $zero, insere_fim					# se o t4 chegar a 0 insere no final da lista
		lw $t3, 4($t4)
		slt $t5, $t1, $t3							# t5 recebe 1 se o valor a ser inserido é menor que o do nodo em que esta a interacao 
		beq $t5, $zero, loop_insere					# se nao for menor, faz mais uma interada
		bne $t5, $zero, insere_meio					# se for menor, vai para a funcao de inserir entre 2 nodos
		jr $ra
			
insere_meio:										# quando a insercao precisa ser feita entre dois nodos 
		sw $t6, 8($t8)								# o nodo anterior recebe como proximo o novo nodo
		sw $t8, 0($t6)								# o novo nodo recebe o nodo anterior
		sw $t4, 8($t6)								# o novo nodo recebe proximo nodo
		sw $t6, 0($t4)
		jr $ra	
		
insere_fim:											# insercao no final da lista, se o valor a ser inserido é maior que o ultimo valor na lista
		sw $t6, 8($t8) 								# o antigo ultimo nodo recebe como proximo o novo nodo
		sw $t8, 0($t6)								# o novo nodo recebe como anterior o antigo ultimo nodo
		jr $ra	
		
##################################################
# Exclui um item na lista duplamente encadeada	 #
#	por valor 									 #		
##################################################
excluir_i:
		la	$a0, txt_inicioele
		li   $v0, 4
		syscall
		addi $t9,$zero,1				
		beq $t9,$a1,remove_inicio
		add $t9,$t9,$zero #inicia o contador
		lw $t8,($a2)
		laco: slt $t4,$t9,$a1
				beq $t4,$zero,exit_lacoR	 #senão fimdelaço
		  		lw $t5,0($t8) 
		  		lw $t6,4($t8)
		  		lw $t7,8($t8)
		 		lw $t8,($t7)
		  		addi $t9,$t9,1
			j laco
		beq $t9,$a1, remover_ele
		j mostra_menu


##################################################
# Exclui um item na lista duplamente encadeada	 #		
#	por indice									 #
##################################################
excluir_v:
		la	$a0, txt_inicioele
		li   $v0, 4
		syscall	
		lw $t8,4($a2) #valor do primeiro elemento
		
		beq $t8,$a1, remove_inicio #verifica se o primeiro elemento é igual ao valor a ser removido
		add $t9,$t9,$zero #inicia o contador
		lw $t8,($a2) #passa o inicio da lista
			jump: slt $t4,$t9,$s2  #inicio do laço se i<total de inserção
				beq $t4, $zero , exit_lacoR #senão fimdelaço
		  		lw $t5,0($t8)
		  		lw $t6, 4($t8)
		  		lw $t7,8($t8)
		 		beq $t6,$a1, remover_ele
		 		lw $t8,($t7)
		  		addi $t9,$t9,1
			j jump
		j mostra_menu	
exit_lacoR:
	j mostra_menu

remover_ele:
 		beq $t7,$zero,remover_ult
 		lw $t3,8($t5)
 		lw $t2,0($t7)
 		sw $t2,8($t3)
 		sw $t3,0($t2)
 		sw $zero,($t5)
 		sw $zero,($t7)
 		addi $t9,$t9,1
 		addi $t2,$t2,1 #incrementa 1
 		sub $s2,$s2,$t2 #decrementa no contador de inserções
 		sw $s2,($s2)  #salva

 		j mostra_menu

remover_ult:
		lw $t3,($t5)
		sw $zero,8($t3)
		sw $zero,($t5)
		addi $t9,$t9,1
		addi $t2,$t2,1 #incrementa 1
 		sub $s2,$s2,$t2 #decrementa no contador de inserções
 		sw $s2,($s2)  #salva
		j mostra_menu


remove_inicio:
		la	$a0, txt_inicioele
		li   $v0, 4
		syscall
		
		lw $t3,8($a2) #endereco do proximo
		
		beq $t3,$zero,remove_inicio_1Elemento #verifica se é o unico elemento da lista 
		jal remove_inicio_nElemento


		j mostra_menu

remove_inicio_1Elemento:
		la	$a0, txt_inicioele
		li   $v0, 4
		syscall
		lw $t8,0($a2) #ponteiro que aponta para o inicio
		li $t8,0
		li $s0,0
		
		addi $t2,$t2,1 #incrementa 1
 		sub $s2,$s2,$t2 #decrementa no contador de inserções
 	  
 		j mostra_menu

remove_inicio_nElemento:
		la	$a0, txt_inicioele
		li   $v0, 4
		syscall
 		lw $t8, 8($a2) #
 		lw $t9, 0($t8) #left do proximo nodo
 		lw $t3,0($a2)
 		sw $t3,($t9)
 		li $t8,0 #

 		lw $t7,8($t8)
 		li $t7,0
 		##sw $t9,0($s2)
 		
 		addi $t2,$t2,1 #incrementa 1
 		sub $s2,$s2,$t2 #decrementa no contador de inserções
 	

 		j mostra_menu
		


		
##################################################
# Nostra totais da lista duplamente encadeada	 #		
##################################################
mostrar_totais:
		j mostra_menu
		


