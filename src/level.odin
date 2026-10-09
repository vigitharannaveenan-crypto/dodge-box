
package main

Level :: struct {
    number: int,
    enemy_count: int,
    enemy_speed: f32,
    survival_target: f32,
}

get_level :: proc(number: int) -> Level {
    switch number {
    case 1:
        return Level{1, 4, 100, 20}
    case 2:
        return Level{2, 6, 140, 25}
    case 3:
        return Level{3, 8, 180, 30}
    case 4:
        return Level{4, 10, 210, 35}
    case 5:
        return Level{5, 12, 250, 40}
    }

    return Level{1, 4, 100, 20}
}
