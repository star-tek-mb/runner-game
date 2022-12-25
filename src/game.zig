const rl = @import("c.zig").raylib;
const std = @import("std");
const Hero = @import("hero.zig").Hero;
const FlyingEye = @import("flyingeye.zig").FlyingEye;
const Background = @import("background.zig").Background;


pub const Game = struct {
    bg: Background,
    hero: Hero,
    enemy: FlyingEye,
    randomizer: std.rand.Random,

    pub fn init() Game {
        var game: Game = undefined;
        game.bg = Background.init();
        game.hero = Hero.init();
        game.enemy = FlyingEye.init();
        return game;
    }

    pub fn update(self: *Game, delta: f32) void {
        self.bg.update(delta);
        self.hero.update(delta);
        self.enemy.update(delta);
        self.bg.x += self.hero.bg_vel * delta;
    }

    pub fn deinit(self: *Game) void {
        self.bg.deinit();
        self.hero.deinit();
        self.enemy.deinit();
    }
};
