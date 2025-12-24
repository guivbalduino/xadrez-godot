# ♟️ Xadrez em Godot

[![Godot v4.x](https://img.shields.io/badge/Godot_Engine-v4.x-478cbf?logo=godot-engine&logoColor=white)](https://godotengine.org)
[![GDScript](https://img.shields.io/badge/GDScript-100%25-478cbf?logo=gdscript)](https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/index.html)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Um jogo de xadrez funcional desenvolvido do zero usando a Godot Engine v4.x. Este projeto foi criado como um exercício de desenvolvimento de jogos, cobrindo a lógica de movimentação de peças, regras de xadrez e uma interface de usuário interativa.

---

## 🌟 Funcionalidades Implementadas

### Lógica de Jogo
- **Movimentação Completa:** Todas as peças (Peão, Torre, Cavalo, Bispo, Rainha, Rei) se movem de acordo com as regras oficiais do xadrez.
- **Lógica de Captura:** Captura de peças inimigas.
- **Validação de Movimentos:** Um sistema robusto que impede movimentos ilegais.
- **Detecção de Xeque (Check):** O jogo identifica quando um rei está sob ataque.
- **Prevenção de Movimentos Ilegais em Xeque:** Impede que o jogador faça qualquer movimento que deixe seu próprio rei em xeque (peças cravadas, movimento do rei para uma casa atacada, etc.).
- **Detecção de Xeque-Mate (Checkmate):** O jogo detecta e anuncia o fim da partida quando um jogador não tem movimentos legais para escapar de um xeque.

### Interface de Usuário (UI) e Experiência do Jogador (UX)
- **Tabuleiro e Peças Visuais:** Utiliza sprites para o tabuleiro e para todas as peças, com visuais distintos para as cores preta e branca.
- **Seleção e Feedback:** Destaque visual (aumento de escala) para a peça selecionada.
- **Exibição de Movimentos Possíveis:** Ao selecionar uma peça, o jogo destaca todas as casas para as quais ela pode se mover legalmente.
- **Feedback de Xeque:**
    - Uma borda vermelha aparece ao redor do rei que está em xeque.
    - Um texto "XEQUE!" animado aparece no centro da tela.
- **Indicador de Turno:** Uma barra na parte inferior da tela muda de cor para indicar qual jogador deve mover.

## 🚀 Como Executar

1.  **Baixe ou clone este repositório.**
2.  **Tenha a Godot Engine v4.2 ou superior instalada.** Você pode baixá-la no [site oficial](https://godotengine.org/download).
3.  **Importe o projeto:**
    - Abra o gerenciador de projetos da Godot.
    - Clique em "Importar" e selecione o arquivo `project.godot` na raiz deste repositório.
4.  **Execute o projeto:** Com o projeto aberto, pressione `F5` ou clique no botão "Executar Projeto" no canto superior direito.

## 🏗️ Estrutura do Código

O projeto é estruturado em torno de algumas cenas e scripts principais:

- **`Game.tscn` / `Game.gd`:** A cena principal e o script que orquestra todo o jogo. Ele gerencia o estado do tabuleiro (`board_state`), o turno atual, a lógica de seleção e movimento, e as regras de xeque e xeque-mate.
- **`Board.gd`:** Um script simples anexado a um `Node2D` que gera proceduralmente o tabuleiro visual usando os sprites de tiles.
- **`Piece.tscn` / `Piece.gd`:** Uma cena base para todas as peças. O script `Piece.gd` (com `class_name Piece`) define as propriedades de uma peça (tipo, cor) e gerencia seu visual, incluindo a textura do sprite e o destaque de xeque.

## 🎨 Atribuição de Assets

Os sprites para as peças de xadrez e os tiles do tabuleiro foram obtidos de:
- **Autor:** C-TOY
- **Fonte:** [OpenGameArt.org](https://opengameart.org/content/chess-pieces-and-board-squares)
- **Licença:** [CC0](https://creativecommons.org/publicdomain/zero/1.0/)