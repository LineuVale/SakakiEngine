package sakaki

import rl "vendor:raylib"


Window :: struct {
    width  : i32,
    height : i32,
    name   : cstring
}

window := Window{
    width  = 1280,
    height = 720,
    name   = "Sakaki Engine"
}


main :: proc() {
    rl.InitWindow(window.width, window.height, window.name)
    
    rl.SetTargetFPS(60)

    for !rl.WindowShouldClose() {
        events()
        update()
        render()
    }
    
    rl.CloseWindow()
}

events :: proc (){

}

update :: proc(){

}

render :: proc() {
    rl.BeginDrawing()
    rl.ClearBackground(rl.RAYWHITE)
    rl.EndDrawing()
}

