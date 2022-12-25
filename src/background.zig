const rl = @import("c.zig").raylib;
const std = @import("std");


pub const Background = struct {
    texture: rl.Texture2D,
    x: f32,

    pub fn init() Background {
        var self: Background = undefined;
        self.texture = rl.LoadTexture("assets/Background.png");
        self.x = 0.0;
        return self;
    }

    pub fn update(self: *Background, delta: f32) void {
        const w = rl.GetScreenWidth();
        const h = rl.GetScreenHeight();

        self.x -= @intToFloat(f32, w) * delta * 0.5;
        if (self.x < -@intToFloat(f32, w) * 2.0) {
            self.x += @intToFloat(f32, w) * 2.0;
        }

        var first = rl.Rectangle{ .x = self.x, .y = 0.0, .width = @intToFloat(f32, w), .height = @intToFloat(f32, h) };
        var second = rl.Rectangle{ .x = self.x + @intToFloat(f32, w), .y = 0.0, .width = @intToFloat(f32, w), .height = @intToFloat(f32, h) };
        var third = rl.Rectangle{ .x = self.x + @intToFloat(f32, w) * 2.0, .y = 0.0, .width = @intToFloat(f32, w), .height = @intToFloat(f32, h) };
        var bg_rect = rl.Rectangle{ .x = 0.0, .y = 0.0, .width = @intToFloat(f32, self.texture.width), .height = @intToFloat(f32, self.texture.height) };
        var bg_mirror_rect = rl.Rectangle{ .x = 0.0, .y = 0.0, .width = -@intToFloat(f32, self.texture.width), .height = @intToFloat(f32, self.texture.height) };

        rl.DrawTexturePro(self.texture, bg_rect, first, rl.Vector2{ .x = 0.0, .y = 0.0 }, 0.0, rl.WHITE);
        rl.DrawTexturePro(self.texture, bg_mirror_rect, second, rl.Vector2{ .x = 0.0, .y = 0.0 }, 0.0, rl.WHITE);
        rl.DrawTexturePro(self.texture, bg_rect, third, rl.Vector2{ .x = 0.0, .y = 0.0 }, 0.0, rl.WHITE);
    }

    pub fn deinit(self: *Background) void {
        rl.UnloadTexture(self.texture);
    }
};
