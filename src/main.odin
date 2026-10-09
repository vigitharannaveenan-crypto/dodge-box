
package main

import rl "vendor:raylib"

WINDOW_WIDTH :: 900
WINDOW_HEIGHT :: 650

main :: proc() {
    rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Dodge Box")
    defer rl.CloseWindow()

    rl.SetTargetFPS(60)

    game := init_game()

    for !rl.WindowShouldClose() {
        dt := rl.GetFrameTime()

        // UPDATE: All gameplay logic
        update_game(&game, dt)

        // RENDER: All drawing
        render_game(&game)
    }
}
