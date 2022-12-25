# Installation

Clone raylib first

```
git clone https://github.com/raysan5/raylib.git --single-branch --depth 1
```

Default target is Windows

So to build, use your target triple:

```
zig build run -Drelease-fast -Dtarget=x86_64-linux-gnu
```
