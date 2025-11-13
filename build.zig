const std = @import("std");

// Build script - called by `zig build`
pub fn build(b: *std.Build) void {
    // Get target/optimize from command line (e.g., `zig build -Doptimize=ReleaseFast`)
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const gobject = b.dependency("gobject", .{
        .target = target,
        .optimize = optimize,
    });

    const root_module = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "glib", .module = gobject.module("glib2") },
            .{ .name = "gobject", .module = gobject.module("gobject2") },
            .{ .name = "gio", .module = gobject.module("gio2") },
            .{ .name = "gtk", .module = gobject.module("gtk4") },
        },
    });

    // Create executable with main.zig as entry point
    const exe = b.addExecutable(.{
        .name = "gtk4-app",
        .root_module = root_module,
    });

    // Install executable to zig-out/bin/
    b.installArtifact(exe);

    // Create run command (`zig build run`)
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep()); // Build before running

    // Forward command-line args to the executable
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    // Register "run" step
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
