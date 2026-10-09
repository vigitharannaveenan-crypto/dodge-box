
package main

import rl "vendor:raylib"

MAX_HEALTH :: 100
BARRIER_DAMAGE :: 20
DAMAGE_COOLDOWN :: 1.0

Player :: struct {
    x: f32,
    y: f32,
    width: f32,
    height: f32,
    speed: f32,
    facing_x: f32,
    facing_y: f32,
    health: int,
    damage_timer: f32,
}

init_player :: proc() -> Player {
    return Player{
        x = 450,
        y = 550,
        width = 30,
        height = 30,
        speed = 250,
        facing_x = 0,
        facing_y = -1,
        health = MAX_HEALTH,
        damage_timer = 0,
    }
}

clamp :: proc(value, minimum, maximum: f32) -> f32 {
    if value < minimum {
        return minimum
    }
    if value > maximum {
        return maximum
    }
    return value
}

// UPDATE: Damage cooldown
update_player_damage :: proc(player: ^Player, dt: f32) {
    if player.damage_timer > 0 {
        player.damage_timer -= dt

        if player.damage_timer < 0 {
            player.damage_timer = 0
        }
    }
}

// UPDATE: Apply damage only when cooldown is finished
damage_player :: proc(player: ^Player, amount: int) {
    if player.damage_timer > 0 || player.health <= 0 {
        return
    }

    player.health -= amount

    if player.health < 0 {
        player.health = 0
    }

    player.damage_timer = DAMAGE_COOLDOWN
}

// UPDATE: Movement and barrier collisions
update_player :: proc(
    player: ^Player,
    barriers: ^[5]Barrier,
    dt: f32,
) {
    dx: f32 = 0
    dy: f32 = 0

    if rl.IsKeyDown(.W) || rl.IsKeyDown(.UP) {
        dy -= player.speed * dt
        player.facing_x = 0
        player.facing_y = -1
    }

    if rl.IsKeyDown(.S) || rl.IsKeyDown(.DOWN) {
        dy += player.speed * dt
        player.facing_x = 0
        player.facing_y = 1
    }

    if rl.IsKeyDown(.A) || rl.IsKeyDown(.LEFT) {
        dx -= player.speed * dt
        player.facing_x = -1
        player.facing_y = 0
    }

    if rl.IsKeyDown(.D) || rl.IsKeyDown(.RIGHT) {
        dx += player.speed * dt
        player.facing_x = 1
        player.facing_y = 0
    }

    // Horizontal movement
    old_x := player.x

    player.x = clamp(
        player.x + dx,
        0,
        f32(WINDOW_WIDTH) - player.width,
    )

    for i in 0..<len(barriers^) {
        barrier := &barriers[i]

        if check_collision(
            player.x, player.y,
            player.width, player.height,
            barrier.x, barrier.y,
            barrier.width, barrier.height,
        ) {
            player.x = old_x
            barrier.glow_timer = 0.5
            damage_player(player, BARRIER_DAMAGE)
        }
    }

    // Vertical movement
    old_y := player.y

    player.y = clamp(
        player.y + dy,
        0,
        f32(WINDOW_HEIGHT) - player.height,
    )

    for i in 0..<len(barriers^) {
        barrier := &barriers[i]

        if check_collision(
            player.x, player.y,
            player.width, player.height,
            barrier.x, barrier.y,
            barrier.width, barrier.height,
        ) {
            player.y = old_y
            barrier.glow_timer = 0.5
            damage_player(player, BARRIER_DAMAGE)
        }
    }
}

// RENDER: Futuristic robot
draw_player :: proc(player: Player) {
    x := i32(player.x)
    y := i32(player.y)
    w := i32(player.width)
    h := i32(player.height)

    // Flash red briefly after taking damage
    body_color := rl.SKYBLUE

    if player.damage_timer > 0 {
        body_color = rl.PINK
    }

    // Dark outer armour
    rl.DrawRectangle(x - 2, y - 2, w + 4, h + 4, rl.DARKBLUE)

    // Main body
    rl.DrawRectangle(x, y, w, h, body_color)

    // Inner armour
    rl.DrawRectangle(x + 5, y + 5, w - 10, h - 10, rl.BLUE)

    // Eyes
    rl.DrawRectangle(x + 7, y + 9, 5, 5, rl.YELLOW)
    rl.DrawRectangle(x + 18, y + 9, 5, 5, rl.YELLOW)

    // Power core
    rl.DrawCircle(x + w / 2, y + 22, 4, rl.GREEN)

    // Direction indicator
    center_x := x + w / 2
    center_y := y + h / 2

    indicator_x := center_x + i32(player.facing_x * 13)
    indicator_y := center_y + i32(player.facing_y * 13)

    rl.DrawCircle(indicator_x, indicator_y, 3, rl.WHITE)
}
