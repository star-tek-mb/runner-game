const rl = @import("c.zig").raylib;
const Background = @import("background.zig").Background;

pub fn main() !void {
    rl.InitWindow(800, 600, "Game");
    rl.SetWindowState(rl.FLAG_WINDOW_RESIZABLE);
    defer rl.CloseWindow();

    var bg = Background.init();
    defer bg.deinit();

    while (!rl.WindowShouldClose()) {
        rl.BeginDrawing();
        defer rl.EndDrawing();
        rl.ClearBackground(rl.RAYWHITE);

        // var w = rl.GetScreenWidth();
        // var h = rl.GetScreenHeight();

        // var first = rl.Rectangle{ .x = 0.0, .y = 0.0, .width = @intToFloat(f32, w), .height = @intToFloat(f32, h) };
        // var bg_rect = rl.Rectangle{ .x = 0.0, .y = 0.0, .width = @intToFloat(f32, bg.texture.width), .height = @intToFloat(f32, bg.texture.height) };
        // rl.DrawTexturePro(bg.texture, bg_rect, first, rl.Vector2{ .x = 0.0, .y = 0.0 }, 0.0, rl.WHITE);
        bg.update();
    }
}
