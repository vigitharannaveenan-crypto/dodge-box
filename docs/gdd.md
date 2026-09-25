# Dodge Box - Game Design Document

**Student Name:** Naveenan Vigitharan  
**Student ID:** 100867059  
**Class:** CSCI 4160U Game Development  
**Game Name:** Dodge Box

## Description

Dodge Box is a  survival game where the player controls a box inside an arena. Enemy boxes move toward or across the player, and the player must avoid touching them. The goal is to survive for as long as possible and achieve a high score.

## Core Gameplay Loop

The player moves around the arena using the keyboard while avoiding enemy boxes. The longer the player survives, the higher their score becomes. Over time, the game becomes more difficult as enemies become faster or appear more frequently. If the player touches an enemy, the game ends. The player can then restart and try to beat their previous score.

### Primary Mechanics

- Moving the player using WASD or arrow keys.
- Dodging enemy boxes.
- Collision with an enemy causes a game over.

### Secondary Mechanics

- The player's score increases based on survival time.
- The difficulty increases as the player survives longer.

### Tertiary Mechanics

- Restarting the game after losing.
- Displaying the player's score.

## MDA Framework

### Mechanics

Player movement, enemy movement, collision detection, survival timer, increasing difficulty, scoring, and restarting.

### Dynamics

As more enemies appear or enemies become faster, the player must react quickly and make decisions about where to move. The player will try to find safe spaces while avoiding being trapped by enemies.

### Aesthetics

The game is intended to create a feeling of challenge and excitement. The increasing difficulty should create tension as the player attempts to survive longer and improve their score.

## Player Experience

### LeBlanc's Taxonomy

The main player experiences are **Challenge** and **Sensation**. Challenge comes from avoiding increasingly difficult enemies. Sensation comes from the fast movement and immediate feedback when avoiding obstacles.

### Game Inspirations

- Simple arcade survival games.
- Dodge-based mini-games where the goal is to survive for as long as possible.

### Non-Game Inspirations

The game is inspired by the simple idea of avoiding moving obstacles in a confined space.

## Genre

Arcade / Survival

## Target Audience

Using Bartle's taxonomy, the game is mainly designed for **Achievers** who enjoy improving their score and trying to beat their previous performance.

## Progression Over Time

The game starts slowly with fewer or slower enemies. As the player survives longer, enemies become faster or appear more frequently. The player's score increases with survival time.

## Themes

The main themes are survival, persistence, and improving through repeated attempts.

## Platform & Tools

- Platform: PC
- Programming Language: Odin
- Graphics/Game Library: Raylib
- Version Control: Git and GitHub

## Anything Else

The game will use simple shapes and visuals so that the main focus remains on movement, dodging, and survival.
