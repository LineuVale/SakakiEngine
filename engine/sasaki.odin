package sakaki

import rl "vendor:raylib"
import "core:fmt"


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


Vector2  :: [2]f32
Vector2i :: [2]i32
Texture  :: rl.Texture2D


// Command Buffer
cmd_buffer: [dynamic]draw_cmds

draw_cmds :: union {
    cmd_draw_sprite
}

cmd_draw_sprite :: struct {
    entity : Entity
}

// Most importar thing in this engine, someday i will tell why, 
// now i'm not creative to create a cool name. 
Entity :: struct { // TODO add transform
    position : Vector2,
    rotation : f32,
    scale    : f32,
    flip     : bool,
    speed    : f32,
    sprite   : Texture,
    state    : string
}

// global 4 now
blue_box : Entity


main :: proc() {
    rl.SetTraceLogLevel(.ALL)
    rl.InitWindow(window.width, window.height, window.name)

    // ///////////// For Debug purpose  ///////////////
    blue_box = Entity{
        position    = {f32(window.width / 2 - blue_box.sprite.width), f32(window.height / 2 - blue_box.sprite.height)},
        sprite      = rl.LoadTexture("tests/res/debug_blue.png"),
        speed       = 100,
        flip        = false,
        scale       = 0.5,
    }
    
    ////////////////////////////////////////////////////

    rl.SetTargetFPS(60)

    for !rl.WindowShouldClose() {
        events()
        update()
        render()
        cleanner()
    }
    
    rl.CloseWindow()
}


events :: proc () {
    // TODO
}


update :: proc() {
    delta_time := rl.GetFrameTime()
    
    // ///////////// For Debug purpose  ///////////////
    if rl.IsKeyDown(.R){
        blue_box.rotation += 1 * delta_time * blue_box.speed
    }
    if rl.IsKeyDown(.D){
        blue_box.position.x += 1 * delta_time * blue_box.speed
    }
    if rl.IsKeyDown(.A){
        blue_box.position.x -= 1 * delta_time * blue_box.speed
    }
    ////////////////////////////////////////////////////
    append(&cmd_buffer, cmd_draw_sprite{entity = blue_box})
         
}


render :: proc() {
    rl.BeginDrawing()
    run_cmds()
    rl.ClearBackground(rl.RAYWHITE)
    rl.EndDrawing()
}


// Engine Funcions
draw_sprite :: proc(e: ^Entity) {
    
    src := rl.Rectangle {
        x      = 0,
        y      = 0,
        width  = f32(e.sprite.width),
        height = f32(e.sprite.height)
    }

    if e.flip {
        src.width = -src.width
    }

    dest := rl.Rectangle {
        x      = e.position.x,
        y      = e.position.y,
        width  = f32(e.sprite.width) * e.scale,
        height = f32(e.sprite.height) * e.scale
    }

    orgin := Vector2 {
        f32(e.sprite.width) / 2 * e.scale,
        f32(e.sprite.height) / 2 * e.scale
    }

    rl.DrawTexturePro(e.sprite, src, dest, orgin, e.rotation, rl.WHITE)
}


run_cmds :: proc() {
    for cmd in cmd_buffer {
        switch &c in cmd {
            case cmd_draw_sprite:
                draw_sprite(&c.entity)
        }
    }
}


// Its called Cleanner to not colid with "clear"
cleanner :: proc() {
    clear(&cmd_buffer)
}