const rl = @import("c.zig").raylib;
const std = @import("std");


pub const FlyingEye = struct {
    pub const FrameSize = 150;
    pub const FrameTime = 0.03;

    pub const Animation = enum(u8) {
        Attack,
        Death,
        Flight,
        Hit
    };

    textures: [@typeInfo(Animation).Enum.fields.len]rl.Texture,
    animation: Animation,
    previous_animation: Animation,
    animation_index: u8,
    loop: bool,
    playing: bool,
    elapsed: f32,
    time: f32,
    x: f32,
    y: f32,
    x_vel: f32,
    y_vel: f32,

    pub fn init() FlyingEye {
        
        var self = std.mem.zeroes(FlyingEye);
        inline for (@typeInfo(Animation).Enum.fields) |field, i| {
            self.textures[i] = rl.LoadTexture("assets/Flying eye/" ++ field.name ++ ".png");
        }
        self.animation = .Flight;
        self.previous_animation = .Flight;
        self.animation_index = 0;
        self.loop = true;
        self.playing = true;
        self.elapsed = 0.0;
        self.time = 0.0;
        const w = rl.GetScreenWidth();
        self.x = @intToFloat(f32, w) / 3.0;
        self.y = @intToFloat(f32, rl.GetScreenHeight()) / 3.0;
        self.x_vel = @intToFloat(f32, w) / 1.5;
        self.y_vel = @intToFloat(f32, w) / 1.5;
        return self;
    }

    pub fn playAnimation(self: *FlyingEye, animation: Animation, loop: bool) void {
        self.previous_animation = self.animation;
        self.animation = animation;
        self.animation_index = 0;
        self.elapsed = 0.0;
        self.loop = loop;
        self.playing = true;
    }

    pub fn update(self: *FlyingEye, delta: f32) void {
        
        const w = rl.GetScreenWidth();
        const h = rl.GetScreenHeight();
        const speed = @intToFloat(f32, w) / 1.5;

        self.elapsed += delta;
        self.time += delta;
        if (self.playing and self.elapsed > FrameTime) {
            self.animation_index += 1;
            self.elapsed -= FrameTime;
        }
        if (self.animation_index >= self.getAnimationFrameCount(self.animation)) {
            self.animation_index = if (self.loop) 0 else self.getAnimationFrameCount(self.animation) - 1;
            self.playing = if (self.loop) true else false;
        }

        var sprite_size: f32 = @intToFloat(f32, h) * 100.0 / FrameSize;
        var draw_rect = rl.Rectangle{ .x = self.x, .y = self.y, .width = sprite_size, .height = sprite_size };
        var sprite_rect = rl.Rectangle{ .x = @intToFloat(f32, self.animation_index) * FrameSize, .y = 0.0, .width = @intToFloat(f32, FrameSize), .height = @intToFloat(f32, FrameSize) };
        rl.DrawTexturePro(self.textures[@enumToInt(self.animation)], sprite_rect, draw_rect, rl.Vector2{ .x = 0.0, .y = 0.0 }, 0.0, rl.WHITE);

        if (self.time > 1.0) {
            var randomizer = std.rand.Xoshiro256.init(@intCast(u64, std.time.milliTimestamp()));
            self.x_vel = if (randomizer.random().boolean()) speed else -speed;
            self.y_vel = if (randomizer.random().boolean()) speed else -speed;
            self.time = 0.0;
        }

        if (self.x < -sprite_size / 2.0) {
            self.x = -sprite_size / 2.0;
            self.x_vel = speed;
        }
        if (self.x > @intToFloat(f32, w) - sprite_size / 2.0) {
            self.x = @intToFloat(f32, w) - sprite_size / 2.0;
            self.x_vel = -speed;
        }
        if (self.y < -sprite_size / 2.0) {
            self.y = -sprite_size / 2.0;
            self.y_vel = speed;
        }
        if (self.y > @intToFloat(f32, h) - sprite_size / 2.0) {
            self.y = @intToFloat(f32, h) - sprite_size / 2.0;
            self.y_vel = -speed;
        }
        self.y += self.y_vel * delta;
        self.x += self.x_vel * delta;
    }

    pub fn getAnimationFrameCount(self: *FlyingEye, animation: Animation) u8 {
        return @intCast(u8, @divExact(self.textures[@enumToInt(animation)].width, FrameSize));
    }

    pub fn deinit(self: *FlyingEye) void {
        inline for (self.textures) |texture| {
            rl.UnloadTexture(texture);
        }
    }
};
