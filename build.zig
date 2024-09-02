const std = @import("std");

const flags = [_][]const u8{
    "-Wall",
    "-Werror",
};

pub fn build(b: *std.Build) void {
    // Build options
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const optimize_external = switch (optimize) {
        .Debug => .ReleaseSafe,
        else => optimize,
    };

    // Build the upstream library
    const upstream = b.dependency("SPIRV-Reflect", .{});
    const lib = b.addStaticLibrary(.{
        .name = "SPIRV-Reflect",
        .target = target,
        .optimize = optimize_external,
    });
    if (optimize == .ReleaseSafe or optimize == .ReleaseFast) {
        lib.root_module.addCMacro("SPIRV_REFLECT_ENABLE_ASSERTS", "1");
    }
    lib.addCSourceFile(.{
        .file = upstream.path("spirv_reflect.c"),
        .flags = &flags,
    });
    lib.installHeadersDirectory(upstream.path(""), "spirv_reflect", .{});
    lib.linkLibC();

    // Build the Zig API
    const mod = b.addModule("spirv_reflect", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    mod.linkLibrary(lib);
    b.installArtifact(lib);

    // Test the Zig API
    const tests = b.addTest(.{
        .root_source_file = b.path("src/tests.zig"),
        .target = target,
        .optimize = optimize,
    });
    tests.linkLibrary(lib);
    tests.root_module.addImport("spirv_reflect", mod);

    const run_tests = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_tests.step);
}
