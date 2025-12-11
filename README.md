---

# 🕹️ Jogo Sério para Avaliação de Soft Skills

**Desenvolvido em Godot Engine 4**

Este projeto consiste em um **jogo sério (serious game)** criado com a **Godot Engine 4**, projetado para **coletar informações comportamentais** relacionadas a soft skills como:

* Comunicação
* Trabalho em equipe
* Gestão do tempo
* Tomada de decisão
* Organização e colaboração

O jogo faz parte de uma plataforma de avaliação comportamental que utiliza mecânicas colaborativas e situações dinâmicas para registrar ações dos jogadores durante a partida.

---

## 🎯 Objetivo do Projeto

Criar um ambiente interativo capaz de **simular cenários colaborativos**, permitindo que o comportamento dos participantes seja observado **de forma natural, orgânica e contextualizada**.
Ao final de cada partida, o jogo envia dados estruturados sobre o desempenho dos jogadores.

---

## 🧩 Gameplay

O jogo se passa em uma **fábrica de montagem de robôs**, onde os jogadores devem trabalhar juntos para completar objetivos antes do tempo acabar.

### Principais Mecânicas

* **Divisão de tarefas**: programar computadores, carregar itens, consertar máquinas, comprar recursos etc.
* **Imprevistos dinâmicos**: computadores podem quebrar aleatoriamente, exigindo reorganização entre os jogadores.
* **Administração de recursos**: itens são adquiridos com pontos obtidos durante a partida.
* **Ambiente colaborativo**: comunicação constante e adaptação rápida são essenciais.

### Elementos do Cenário

* **Computadores** (ativos, antigos e quebrados)
* **Mercado** com itens como kits de cura, peças antigas, pendrives, pacotes de Wi-Fi e outros
* **Robôs em construção**, cada um com requisitos únicos
* **Televisores** exibindo os objetivos em tempo real
* **Área de finalização** dos robôs

---

## 📊 Coleta de Dados

Durante a partida, o jogo registra automaticamente ações realizadas pelos jogadores.
Ao final da sessão, essas informações são enviadas para análise em formato JSON.

---

## 🏗️ Estrutura do Projeto (Godot)

O jogo foi desenvolvido utilizando:

* **Godot Engine 4**
* **GDScript**
* Cena principal representando a fábrica
* Nodes organizados por:

  * Jogadores
  * Computadores
  * Robôs
  * Mercado
  * Eventos dinâmicos
  * Sistema de coleta de ações

---

## ▶️ Como Executar o Projeto

1. Instale o **Godot Engine 4.x**
2. Clone o repositório:

```bash
git clone https://github.com/usuario/projeto-softskills-godot.git
```

3. Abra a pasta do projeto no Godot
4. Clique em **Run Project**

---

## 📦 Formato dos Dados Enviados

Os dados são enviados ao final da partida em formato **JSON**, contendo informações gerais da sessão e das ações realizadas pelos jogadores.

```json
{
  "session_code": "XYZ123",
  "players": [...],
  "actions": [...]
}
```

---

## 🧑‍🤝‍🧑 Público-Alvo

* Recrutadores
* Empresas
* Instituições de ensino
* Pesquisadores
* Equipes de RH que buscam métodos não subjetivos para avaliação

---

## 🚀 Futuras Melhorias

* Novos mapas e desafios
* Suporte a diferentes modos de jogo
* Expansão do sistema de coleta de dados
* Interface de feedback pós-partida

---

### Assets

https://aztrakatze.itch.io/simple-cute-robot

https://kenney.nl/assets/roguelike-indoors

https://kenney.nl/assets/generic-items

https://limezu.itch.io/moderninteriors

https://trevor-pupkin.itch.io/tech-dungeon-roguelite

https://arlantr.itch.io/free-office-pixel-art

https://opengameart.org/content/futuristic-industrial-technical-tileset

https://opengameart.org/content/lpc-misc-tile-atlas-interior-exterior-trees-bridges-furniture

https://opengameart.org/content/the-boss

https://opengameart.org/content/screens-displays

https://tilation.itch.io/16x16-small-indoor-tileset

https://limezu.itch.io/kitchen

https://blood-seller.itch.io/factory-assets-conveyer-belt

https://foozlecc.itch.io/sci-fi-lab-droids

https://craftpix.net/freebies/free-city-enemies-pixel-art-sprite-sheets/?num=3&count=60&sq=robot&pos=15

https://craftpix.net/freebies/free-drones-pack-pixel-art/?num=2&count=60&sq=robot&pos=7

https://craftpix.net/freebies/free-sci-fi-antagonists-pixel-character-pack/?num=1&count=60&sq=robot&pos=15

https://craftpix.net/freebies/free-simple-platformer-game-kit-pixel-art/?num=2&count=60&sq=robot&pos=15

https://nyknck.itch.io/explosion

https://osmanfrat.itch.io/coin

https://szadiart.itch.io/3-direction-npc-characters

https://blue00.itch.io/electronics-pixel-pack

https://anokolisa.itch.io/free-pixel-art-asset-pack-topdown-tileset-rpg-16x16-sprites

https://chottoinc.itch.io/buttons-pixel-art

https://opengameart.org/content/clicker-game

https://poppyworks.itch.io/silver

https://opengameart.org/content/top-down-basic-construction

https://fightswithbears.itch.io/2d-health-and-ammo-pickups

https://skalding.itch.io/coffee-cup-001

https://opengameart.org/content/8-bitnes-explosion-sound-effecs

https://mixkit.co/free-sound-effects/type/

https://yourpalrob.itch.io/must-have-horror-sound-effects

https://opengameart.org/content/pressure-0

https://marceles.itch.io/land-of-pixels-laboratory-tileset-pixel-art

https://pixelfranek.itch.io/free-textures-of-light

https://opengameart.org/content/door-open-door-close-set

https://opengameart.org/content/dungeon-tileset-1

https://opengameart.org/content/office-objects
