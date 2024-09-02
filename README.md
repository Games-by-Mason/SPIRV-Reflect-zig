# SPIRV-Reflect-zig

A port of [SPIRV-Reflect](https://github.com/KhronosGroup/SPIRV-Reflect/) to the Zig build system, and a Zig API for the library.

## Status

The static library is built nearly identically to the official CMake.

As for the Zig API, the port was very simple and as far as I know all functionality from the original library is exposed. I only use a small portion of the functionality myself though, mostly related to descriptor set bindings, if I missed anything contributions (or issues) are welcome. It's also possible that I was overly conservative with some pointer types.

## Usage

The simplest way to use the library is via the Zig API.

Zig code:
```zig
const spvr = @import("spirv_reflect");
var module = spvr.ShaderModule.init(spv) catch |err| @panic(@errorName(err));
defer module.deinit();
```

`ShaderModule` contains the reflection data.

The static library is also exported if you want access to the C API.

## SPIRV-Reflect version & upgrade process

The version of SPIRV-Reflect built is set in `build.zig.zon`.

To upgrade the static library, simply update this version.

If you are also using the Zig API, you'll need to also update any public enums or structures that were changed in `src/root`. I recommend looking at a diff to see what changed. You can run the tests to check for obvious mistakes in this process.
