const rl = @import("c.zig").raylib;
const std = @import("std");


pub const Background = struct {
    texture: rl.Texture,
    x: f32,

    pub fn init() Background {
        var self: Background = undefined;
        self.texture = rl.LoadTexture("assets/Background.png");
        self.x = 0.0;
        return self;
    }

    // pub inline fn update(self: *Background) void {
    pub inline fn update(self: *Background) void {
        var w = rl.GetScreenWidth();
        var h = rl.GetScreenHeight();

        var first = rl.Rectangle{ .x = 0.0, .y = 0.0, .width = @intToFloat(f32, w), .height = @intToFloat(f32, h) };
        var bg_rect = rl.Rectangle{ .x = 0.0, .y = 0.0, .width = @intToFloat(f32, self.texture.width), .height = @intToFloat(f32, self.texture.height) };
        rl.DrawTexturePro(self.texture, bg_rect, first, rl.Vector2{ .x = 0.0, .y = 0.0 }, 0.0, rl.WHITE);
    }

    pub fn deinit(self: *Background) void {
        rl.UnloadTexture(self.texture);
    }
};
