programa {
  inclua biblioteca Util --> y
  inclua biblioteca Matematica --> mat

  funcao inicio() {
    //MEDIDAS (TUDO QUE FOR VÁRIAVEL)

    caracter game_grid [5][5] //Matriz principal do jogo
    inteiro player_pos[2] = {y.sorteia(0,4),y.sorteia(0,4)}, temp_player_pos[2] //player
    inteiro enemies[4][2] //Inimigos e suas posições 0 -> @, 1 -> #, 2-> &, 3-> $
    inteiro enemies_temp[4][2] //Temporária para eles se movimentarem
    caracter sticker[4] = {'@', '#', '&', '$'} //Carinha dos inimigos
    inteiro random_enemies_order[4] = {0,1,2,3} //Para aleatorizar a ordem dos inimigos gerados
    inteiro win_grid[5][5] //Matriz que guarda todas as posições onde o player já passou
    inteiro count = 0//Conta todos os 1's da matriz win_grid, se eu tiver 25, então o player venceu o jogo

    logico stay = falso //Para verificar se o player está na mesma posição (entrada inválida)
    logico allowed = verdadeiro //Para verificar se posso sortear a posição de um inimigo numa linha
    logico over_game = falso //Acabou o jogo (perdeu)
    logico win_game = falso //Acabou o jogo (ganhou)

    caracter key // Entrada do jogador

    para (inteiro i = 0; i < 4; i++) { //Sorteia posições aleatórias para os inimigos (assim eles não aparecem sempre na msm ordem de cima para baixo)
      inteiro temp
      inteiro j = y.sorteia(0,3)

      temp = random_enemies_order[i]
      random_enemies_order[i] = random_enemies_order[j]
      random_enemies_order[j] = temp

    }

    //Inicia a matriz para contar os quadrados que o player já passou
    para (inteiro i = 0; i < 5; i++) {
      para (inteiro j = 0; j < 5; j++) win_grid[i][j] = 0
    } win_grid[player_pos[0]][player_pos[1]] = 1 //Já atribui um ponto para onde o player começar


    //prenche game_grid com espaços vazios
    para (inteiro i = 0; i < 5; i++) {
      para (inteiro j = 0; j < 5; j++) game_grid[i][j] = ' '
    } game_grid[player_pos[0]][player_pos[1]] = 'X' //e o player

    inteiro k = 0
    para (inteiro i = 0; i < 5; i++) { //Sorteia as posições iniciais dos inimigos (nunca na mesma linha que o player)

      para (inteiro j = 0; j < 5; j++) {//Verifica se o player está na mesma linha, se sim, allowed = falso
        se (i == player_pos[0] e j == player_pos[1]) allowed = falso
      }

      se (allowed == verdadeiro) {
        enemies[random_enemies_order[k]][0] = i //Permanece na mesma linha (que não tem o player)
        enemies[random_enemies_order[k]][1] = y.sorteia(0,4) //Sorteia uma posição qualquer (coluna)
        k++
      } allowed = verdadeiro
    }

    para (inteiro i = 0; i < 4; i++) {//Coloca os inimigos no game grid
      game_grid[enemies[i][0]][enemies[i][1]] = sticker[i]
    }



    //RENDERIZAÇÃO INICIAL

    //Introdução
    escreva("SUDO_TRIX VERSÃO: 0.3\n\nPara ganhar você (X) deve percorrer todos quadrados do mapa pelo menos uma vez.")
    escreva("\nOs fantasmas @ # & e $ surgirão e se movimentarão pelo mapa de forma ordenada para tentar te impedir.")
    escreva("\nNão ocupe a mesma posição que eles, nem tente cruzar seus caminhos na mesma direção e eles te deixarão em paz.")
    escreva("\nUse W, A, S, D + Enter para se movimentar pelo mapa. A tecla 'q' encerra o jogo e qualquer outra tecla o mantém parado.")
    escreva("\nA matriz da direita mostrará os quadrados em que vocẽ já passou como '1' e os que não passou como '0'.")
    escreva("\nDicas: # só se movimenta para cima ; @ só se movimenta para baixo; & só se movimenta para a direita; $ só se movimenta para a esquerda.")
    escreva("\n\n")

    para (inteiro i = 0; i < 5; i++) {
      para (inteiro j = 0; j < 5; j++) escreva("[",game_grid[i][j],"]") //renderiza game_grid
      escreva("   ")
      para (inteiro j = 0; j < 5; j++) escreva("[",win_grid[i][j],"]") //renderiza win_grid
      escreva("\n")
    }

    faca {
    //---> LOOP DO JOGO <--- INICIA
    //COMANDO
      escreva("COMANDO: ")
      leia(key)
      limpa()

    //LÓGICA
      temp_player_pos[0] = player_pos[0]
      temp_player_pos[1] = player_pos[1]


      escolha (key) {
        caso 'W':
          player_pos[0] = player_pos[0] - 1
          pare
        caso 'S':
          player_pos[0] = player_pos[0] + 1
          pare
        caso 'A':
          player_pos[1] = player_pos[1] - 1
          pare
        caso 'D':
          player_pos[1] = player_pos[1] + 1
          pare
        caso contrario:
          stay = verdadeiro  
      }


      //Limita o player ao tabuleiro, tem warp
      para (inteiro i = 0; i < 2; i++) {
        se (player_pos[i] > 4) player_pos[i] = 0
        se (player_pos[i] < 0) player_pos[i] = 4
      }

      //Só movimenta o player se a entrada for válida (w, a, s ou d, do contrário fica no mesmo lugar)
      se (stay == falso) {
        game_grid[player_pos[0]][player_pos[1]] = 'X'
        game_grid[temp_player_pos[0]][temp_player_pos[1]] = ' '
      } stay = falso

      //Inimigos

      para (inteiro i = 0; i < 4; i++) { //salva as antigas posiçoes dos inimigos
        enemies_temp[i][0] = enemies[i][0]
        enemies_temp[i][1] = enemies[i][1]
      }

      //movimenta os inimigos, cada um se movimenta de um jeito para uma direção diferente
      enemies[0][0] = enemies[0][0] + 1
      enemies[1][0] = enemies[1][0] - 1
      enemies[2][1] = enemies[2][1] + 1
      enemies[3][1] = enemies[3][1] - 1

      para (inteiro i = 0; i < 2; i++) { //mantém inimigos no grid, tem warp
        se (enemies[i][0] > 4) enemies[i][0] = 0
        se (enemies[i][0] < 0) enemies[i][0] = 4
        se (enemies[i+2][1] > 4) enemies[i+2][1] = 0
        se (enemies[i+2][1] < 0) enemies[i+2][1] = 4
      }

      para (inteiro i = 0; i < 4; i++) {//preenche a posição anterior de todos os inimigos com ' '
        game_grid[enemies_temp[i][0]][enemies_temp[i][1]] = ' '
      }

      para (inteiro i = 0; i < 4; i++) {// coloca os inimigos nas posições novas no game_grid
        game_grid[enemies[i][0]][enemies[i][1]] = sticker[i]
      }


      //Colisão com o player, casos que colidiu:
      para (inteiro i = 0; i < 4; i++) {
        //Player e inimigo ocupam a mesma posição
        se (enemies[i][0] == player_pos[0] e enemies[i][1] == player_pos[1]) over_game = verdadeiro
        //A antiga posiçao do player é a nova posição do inimigo e a posição antiga do inimigo é a nova posição do player
        //Basicamente vc cruzou o caminho do inimigo na mesma direção
        se ((enemies[i][0] == temp_player_pos[0]) e (enemies[i][1] == temp_player_pos[1])) {
          se ((player_pos[0] == enemies_temp[i][0]) e (player_pos[1] == enemies_temp[i][1])) over_game = verdadeiro
        }
      }

      para (inteiro i = 0; i < 4; i++) { //Impede do player sumir pq o espaço antigo do inimigo foi substituído por espaço
        se ((player_pos[0] == enemies_temp[i][0]) e (player_pos[1] == enemies_temp[i][1])) {
          game_grid[enemies_temp[i][0]][enemies_temp[i][1]] = 'X'
        }
      }

      //Só conto pontos e verifico se ganhou, se o jogo não tiver acabado (o player não colidiu com nenhum inimigo)
      se (over_game == falso) {
        win_grid[player_pos[0]][player_pos[1]] = 1

        para (inteiro i = 0; i < 5; i++) {//Soma todos os 1's da Matriz win grid, e guarda no count
          para (inteiro j = 0; j < 5; j++) {
            se (win_grid[i][j] == 1) count = count + win_grid[i][j]
          }
        }

        escreva("Win Grid Count = ", count, "\n")
        //Se der 25 (5*5); o player ganhou o jogo, do contrário eu reseto o count
        se (count == 25) win_game = verdadeiro
        senao count = 0
      }
    

    //RENDER
      para (inteiro i = 0; i < 5; i++) {
        para (inteiro j = 0; j < 5; j++) escreva("[",game_grid[i][j],"]") //renderiza game_grid
        escreva("   ")
        para (inteiro j = 0; j < 5; j++) escreva("[",win_grid[i][j],"]") //renderiza win_grid
        escreva("\n")
      }
      se (over_game == verdadeiro) {
        escreva("\nGAME OVER")
        pare
      } senao se (win_game == verdadeiro) {
        escreva("\nYOU WON!")
        pare
      }

    } enquanto (key != 'q')
    
  }
}