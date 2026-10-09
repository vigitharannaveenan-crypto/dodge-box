
package main

import rl "vendor:raylib"

Game_State :: enum {
    Menu,
    Playing,
    Game_Over,
}

Game :: struct {
    state: Game_State,
    player: Player,
    enemies: [4]Enemy,
    barriers: [5]Barrier,
    level: Level,
    score: int,
    survival_time: f32,
}

// ========================================
// INITIALIZE GAME
// ========================================

init_game :: proc() -> Game {
    game := Game{
        state = .Menu,
        player = init_player(),
        barriers = init_barriers(),
        level = get_level(1),
        score = 0,
        survival_time = 0,
    }

    reset_enemies(&game)
    return game
}

// ========================================
// INITIALIZE ENEMIES
// ========================================

reset_enemies :: proc(game: ^Game) {
    game.enemies = {
        Enemy{100, 100, 30, 120, .Basic, 1},
        Enemy{700, 150, 25, 190, .Fast, -1},
        Enemy{100, 500, 30, 100, .Chaser, 1},
        Enemy{750, 500, 30, 140, .Zigzag, -1},
    }
}

// ========================================
// START / RESTART GAME
// ========================================

start_game :: proc(game: ^Game) {
    game.player = init_player()
    game.barriers = init_barriers()
    game.level = get_level(1)
    game.score = 0
    game.survival_time = 0

    reset_enemies(game)

    game.state = .Playing
}

// ========================================
// UPDATE - GAME LOGIC ONLY
// ========================================

update_game :: proc(game: ^Game, dt: f32) {
    switch game.state {

    case .Menu:
        if rl.IsKeyPressed(.ENTER) {
            start_game(game)
        }

    case .Playing:
        // Update damage cooldown
        update_player_damage(&game.player, dt)

        // Update electric barriers
        for i in 0..<len(game.barriers) {
            update_barrier(&game.barriers[i], dt)
        }

        // Update player movement and barrier collisions
        update_player(
            &game.player,
            &game.barriers,
            dt,
        )

        // End game when health reaches zero
        if game.player.health <= 0 {
            game.state = .Game_Over
            return
        }

        // Update enemies and check collisions
        for i in 0..<len(game.enemies) {
            update_enemy(
                &game.enemies[i],
                game.player,
                dt,
            )

            enemy := game.enemies[i]

            if check_collision(
                game.player.x,
                game.player.y,
                game.player.width,
                game.player.height,
                enemy.x,
                enemy.y,
                enemy.size,
                enemy.size,
            ) {
                game.state = .Game_Over
                break
            }
        }

        // Update survival timer and score
        if game.state == .Playing {
            game.survival_time += dt
            game.score = int(game.survival_time)

            if game.survival_time >= game.level.survival_target {
                game.state = .Game_Over
            }
        }

    case .Game_Over:
        if rl.IsKeyPressed(.R) {
            start_game(game)
        }

        if rl.IsKeyPressed(.M) {
            game.state = .Menu
        }
    }
}

// ========================================
// RENDER - DRAWING ONLY
// ========================================

render_game :: proc(game: ^Game) {
    rl.BeginDrawing()
    defer rl.EndDrawing()

    // Dark navy background
    rl.ClearBackground(rl.Color{15, 23, 42, 255})

    switch game.state {

    case .Menu:
        draw_menu()

    case .Playing:
        // Draw electric barriers
        for barrier in game.barriers {
            draw_barrier(barrier)
        }

        // Draw robot player
        draw_player(game.player)

        // Draw enemies
        for enemy in game.enemies {
            draw_enemy(enemy)
        }

        // Draw score and level
        draw_hud(
            game.score,
            game.level.number,
        )

        // Draw player health bar
        draw_health_bar(game.player.health)

    case .Game_Over:
        draw_game_over(game.score)
    }
}
