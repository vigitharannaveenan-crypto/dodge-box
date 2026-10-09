
package main

import rl "vendor:raylib"
import "core:math"

Enemy_Type :: enum {
    Basic,
    Fast,
    Chaser,
    Zigzag,
}

Enemy :: struct {
    x: f32,
    y: f32,
    size: f32,
    speed: f32,
    enemy_type: Enemy_Type,
    direction: f32,
}

// UPDATE: Enemy behavior
update_enemy :: proc(enemy: ^Enemy, player: Player, dt: f32) {
    switch enemy.enemy_type {
    case .Basic:
        enemy.x += enemy.speed * enemy.direction * dt

    case .Fast:
        enemy.x += enemy.speed * enemy.direction * dt

    case .Chaser:
        dx := player.x - enemy.x
        dy := player.y - enemy.y
        distance := f32(math.sqrt(dx * dx + dy * dy))

        if distance > 0 {
            enemy.x += (dx / distance) * enemy.speed * dt
            enemy.y += (dy / distance) * enemy.speed * dt
        }

    case .Zigzag:
        enemy.x += enemy.speed * enemy.direction * dt
        enemy.y += enemy.speed * 0.5 * enemy.direction * dt
    }

    // Bounce at horizontal boundaries
    if enemy.x <= 0 {
        enemy.x = 0
        enemy.direction = 1
    }

    if enemy.x >= f32(WINDOW_WIDTH) - enemy.size {
        enemy.x = f32(WINDOW_WIDTH) - enemy.size
        enemy.direction = -1
    }

    // Keep enemies inside vertical boundaries
    enemy.y = clamp(
        enemy.y,
        0,
        f32(WINDOW_HEIGHT) - enemy.size,
    )
}

// RENDER: Enemy drawing
draw_enemy :: proc(enemy: Enemy) {
    color := rl.RED

    switch enemy.enemy_type {
    case .Basic:
        color = rl.RED
    case .Fast:
        color = rl.ORANGE
    case .Chaser:
        color = rl.PURPLE
    case .Zigzag:
        color = rl.GREEN
    }

    rl.DrawRectangle(
        i32(enemy.x),
        i32(enemy.y),
        i32(enemy.size),
        i32(enemy.size),
        color,
    )
}
