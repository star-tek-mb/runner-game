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

# Maybe bug?

Compile in release fast mode.

Literally the same code in `main.zig` (commented) and `background.zig` (actual) does not work same

`main.zig` - **working**, same code in separate function update (`background.zig`) - **not working**

if i try to mark function update (`background.zig`) inline - code is **working**
