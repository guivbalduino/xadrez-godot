# ♟️ Xadrez em Godot

[![Godot v4.x](https://img.shields.io/badge/Godot_Engine-v4.x-478cbf?logo=godot-engine&logoColor=white)](https://godotengine.org)
[![GDScript](https://img.shields.io/badge/GDScript-100%25-478cbf?logo=gdscript)](https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/index.html)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Um projeto de xadrez desenvolvido com a Godot Engine v4.x. Este repositório serve como base para a criação de um jogo de xadrez completo, começando com a configuração inicial do tabuleiro e das peças.

---

## 🌟 Funcionalidades Atuais

O projeto atualmente implementa a base visual e estrutural do jogo:

- **Geração Procedural do Tabuleiro:** O tabuleiro de 8x8 é gerado dinamicamente, com `Sprite2D` para cada casa, aplicando as texturas de casas claras and escuras.
- **Setup Inicial das Peças:** As peças são instanciadas e posicionadas em suas casas iniciais de acordo com as regras do xadrez.
- **Estrutura de Peças:** Cada peça é um objeto (`Piece`) com tipo, cor, e posição definidos, e seu visual é carregado de arquivos de imagem correspondentes.

## 🎯 Objetivos Futuros (TODO)

A lista de funcionalidades a serem implementadas para tornar o jogo funcional inclui:

- **Lógica de Movimentação de Peças:**
    - Implementar a movimentação de todas as peças (Peão, Torre, Cavalo, Bispo, Rainha, Rei) de acordo com suas regras.
- **Regras do Xadrez:**
    - Lógica de captura de peças.
    - Validação de movimentos para impedir jogadas ilegais.
    - Detecção de Xeque (Check) e Xeque-Mate (Checkmate).
    - Prevenção de movimentos que deixem o próprio rei em xeque.
- **Interface e Experiência do Jogador:**
    - Sistema de seleção de peças e feedback visual.
    - Exibição dos movimentos possíveis para a peça selecionada.
    - Indicador de turno (vez das brancas ou pretas).
    - Interface para exibir mensagens (ex: "Xeque!").

## 🚀 Como Executar

1.  **Baixe ou clone este repositório.**
2.  **Tenha a Godot Engine v4.2 ou superior instalada.** Você pode baixá-la no [site oficial](https://godotengine.org/download).
3.  **Importe o projeto:**
    - Abra o gerenciador de projetos da Godot.
    - Clique em "Importar" e selecione o arquivo `project.godot` na raiz deste repositório.
4.  **Execute o projeto:** Com o projeto aberto, pressione `F5` ou clique no botão "Executar Projeto" no canto superior direito.

## 🏗️ Estrutura do Código

O projeto é estruturado em torno de algumas cenas e scripts principais:

- **`Game.tscn` / `Game.gd`:** A cena principal e o script que orquestra o jogo. Atualmente, é responsável por instanciar o tabuleiro e as peças em suas posições iniciais.
- **`Board.gd`:** Um script anexado a um `Node2D` que gera proceduralmente o tabuleiro visual usando os sprites de tiles.
- **`Piece.tscn` / `Piece.gd`:** Uma cena base para todas as peças. O script `Piece.gd` (com `class_name Piece`) define as propriedades de uma peça (tipo, cor) e gerencia seu visual.

## 🎨 Atribuição de Assets

Os sprites para as peças de xadrez e os tiles do tabuleiro foram obtidos de:
- **Autor:** C-TOY
- **Fonte:** [OpenGameArt.org](https://opengameart.org/content/chess-pieces-and-board-squares)
- **Licença:** [CC0](https://creativecommons.org/publicdomain/zero/1.0/)
