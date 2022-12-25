const rl = @import("c.zig").raylib;
const std = @import("std");


pub const Hero = struct {
    pub const FrameSize = 200;
    pub const FrameTime = 0.03;

    pub const Animation = enum(u8) {
        Attack1,
        Attack2,
        Death,
        Fall,
        Idle,
        Jump,
        Run,
        Hit
    };

    textures: [@typeInfo(Animation).Enum.fields.len]rl.Texture,
    animation: Animation,
    previous_animation: Animation,
    animation_index: u8,
    loop: bool,
    playing: bool,
    on_ground: bool,
    elapsed: f32,
    x: f32,
    y: f32,
    y_vel: f32,
    bg_vel: f32,

    pub fn init() Hero {
        
        var self = std.mem.zeroes(Hero);
        inline for (@typeInfo(Animation).Enum.fields) |field, i| {
            self.textures[i] = rl.LoadTexture("assets/Hero/" ++ field.name ++ ".png");
        }
        self.animation = .Run;
        self.previous_animation = .Run;
        self.animation_index = 0;
        self.loop = true;
        self.playing = true;
        self.on_ground = true;
        self.elapsed = 0.0;
        self.x = 100.0;
        const h = rl.GetScreenHeight();
        var y_limit = @intToFloat(f32, h) * 995.0 / 1080.0;
        self.y = y_limit - (@intToFloat(f32, h) * 120.0 / FrameSize);
        self.y_vel = 0.0;
        self.bg_vel = 0.0;
        return self;
    }

    pub fn animationFinished(self: *Hero, last: Animation) void {
        switch (last) {
            .Jump => {},
            .Fall => {},
            .Attack1 => self.playAnimation(.Run, true),
            else => self.playAnimation(self.previous_animation, true),
        }
    }

    pub fn playAnimation(self: *Hero, animation: Animation, loop: bool) void {
        self.previous_animation = self.animation;
        self.animation = animation;
        self.animation_index = 0;
        self.elapsed = 0.0;
        self.loop = loop;
        self.playing = true;
    }

    pub fn update(self: *Hero, delta: f32) void {
        
        const w = rl.GetScreenWidth();
        const h = rl.GetScreenHeight();
        const speed = @intToFloat(f32, w) / 1.5;
        const y_grav = @intToFloat(f32, h) * 4.0;
        self.bg_vel = 0.0;

        self.elapsed += delta;
        if (self.playing and self.elapsed > FrameTime) {
            self.animation_index += 1;
            self.elapsed -= FrameTime;
        }
        if (self.animation_index >= self.getAnimationFrameCount(self.animation)) {
            self.animation_index = if (self.loop) 0 else self.getAnimationFrameCount(self.animation) - 1;
            self.playing = if (self.loop) true else false;
            if (!self.playing) {
                self.animationFinished(self.animation);
            }
        }

        var y_limit = @intToFloat(f32, h) * 995.0 / 1080.0;
        if (self.on_ground) {
            self.y = y_limit - (@intToFloat(f32, h) * 120.0 / FrameSize);
        }

        var sprite_size: f32 = @intToFloat(f32, h) * 200.0 / FrameSize;
        var draw_rect = rl.Rectangle{ .x = self.x, .y = self.y, .width = sprite_size, .height = sprite_size };
        var sprite_rect = rl.Rectangle{ .x = @intToFloat(f32, self.animation_index) * FrameSize, .y = 0.0, .width = @intToFloat(f32, FrameSize), .height = @intToFloat(f32, FrameSize) };
        rl.DrawTexturePro(self.textures[@enumToInt(self.animation)], sprite_rect, draw_rect, rl.Vector2{ .x = 0.0, .y = 0.0 }, 0.0, rl.WHITE);

        if (rl.IsMouseButtonPressed(rl.MOUSE_BUTTON_LEFT) and self.animation != .Attack1) {
            self.playAnimation(.Attack1, false);
        }
        if (rl.IsMouseButtonPressed(rl.MOUSE_BUTTON_RIGHT) and self.animation != .Attack2) {
            self.playAnimation(.Attack2, false);
        }
        if (rl.IsKeyDown(rl.KEY_A)) {
            self.x -= speed * delta;
        }
        if (rl.IsKeyDown(rl.KEY_D)) {
            self.x += speed * delta;
        }
        if (rl.IsKeyPressed(rl.KEY_SPACE) and self.on_ground) {
            self.on_ground = false;
            self.y_vel = @intToFloat(f32, h) * -2.0;
            self.playAnimation(.Jump, false);
        } 
        if (self.x < -sprite_size / 2.0) {
            self.x = -sprite_size / 2.0;
        }
        if (self.x > @intToFloat(f32, w) - sprite_size / 2.0) {
            self.bg_vel = -speed;
            self.x = @intToFloat(f32, w) - sprite_size / 2.0;
        }

        self.y += self.y_vel * delta;
        self.y_vel += y_grav * delta;
        if (self.y_vel > 0.0 and (self.previous_animation != .Fall or self.animation == .Run) and !self.on_ground) {
            self.playAnimation(.Fall, true);
        }

        if (!self.on_ground and self.y >= y_limit - (@intToFloat(f32, h) * 120.0 / FrameSize)) {
            self.on_ground = true;
            self.playAnimation(.Run, true);
        }
    }

    pub fn getAnimationFrameCount(self: *Hero, animation: Animation) u8 {
        return @intCast(u8, @divExact(self.textures[@enumToInt(animation)].width, FrameSize));
    }

    pub fn deinit(self: *Hero) void {
        inline for (self.textures) |texture| {
            rl.UnloadTexture(texture);
        }
    }
};
