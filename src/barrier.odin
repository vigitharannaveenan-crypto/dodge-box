
package main

import rl "vendor:raylib"

Barrier :: struct {
    x: f32,
    y: f32,
    width: f32,
    height: f32,
    glow_timer: f32,
}

init_barriers :: proc() -> [5]Barrier {
    return {
        Barrier{x = 200, y = 150, width = 150, height = 25},
        Barrier{x = 550, y = 150, width = 150, height = 25},
        Barrier{x = 350, y = 280, width = 200, height = 25},
        Barrier{x = 200, y = 420, width = 150, height = 25},
        Barrier{x = 550, y = 420, width = 150, height = 25},
    }
}

update_barrier :: proc(barrier: ^Barrier, dt: f32) {
    if barrier.glow_timer > 0 {
        barrier.glow_timer -= dt

        if barrier.glow_timer < 0 {
            barrier.glow_timer = 0
        }
    }
}

// RENDER: Metal hazard wall with electric warning strips
draw_barrier :: proc(barrier: Barrier) {
    x := i32(barrier.x)
    y := i32(barrier.y)
    w := i32(barrier.width)
    h := i32(barrier.height)

    active := barrier.glow_timer > 0

    if active {
        // Outer glow
        rl.DrawRectangle(x - 7, y - 7, w + 14, h + 14, rl.GOLD)
    }

    // Metal border
    rl.DrawRectangle(x - 2, y - 2, w + 4, h + 4, rl.BLACK)

    // Dark metallic base
    rl.DrawRectangle(x, y, w, h, rl.DARKGRAY)

    // Warning stripe pattern
    stripe_color := rl.RED
    electric_color := rl.SKYBLUE

    if active {
        stripe_color = rl.YELLOW
        electric_color = rl.WHITE
    }

    for i in 0..<w / 20 {
        stripe_x := x + i * 20

        rl.DrawRectangle(
            stripe_x + 3,
            y + 4,
            8,
            h - 8,
            stripe_color,
        )
    }

    // Electric center line
    rl.DrawRectangle(
        x + 4,
        y + h / 2 - 2,
        w - 8,
        4,
        electric_color,
    )
}
