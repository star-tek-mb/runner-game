const rl = @import("c.zig").raylib;
const std = @import("std");
const Game = @import("game.zig").Game;

pub fn main() !void {
    rl.InitWindow(800, 600, "Game");
    rl.SetWindowState(rl.FLAG_WINDOW_RESIZABLE);
    defer rl.CloseWindow();

    var game = Game.init();
    defer game.deinit();

    while (!rl.WindowShouldClose()) {
        const delta = rl.GetFrameTime();

        rl.BeginDrawing();
        defer rl.EndDrawing();

        rl.ClearBackground(rl.RAYWHITE);
        game.update(delta);
    }
}
