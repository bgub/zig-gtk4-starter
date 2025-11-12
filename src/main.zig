const std = @import("std");
const GtkApplication = opaque {};
const GtkApplicationWindow = opaque {};
const GtkWidget = opaque {};
const GtkButton = opaque {};

extern fn gtk_application_new(application_id: [*:0]const u8, flags: c_int) ?*GtkApplication;
extern fn g_application_run(app: *GtkApplication, argc: c_int, argv: ?[*]?[*:0]u8) c_int;
extern fn g_object_unref(object: *anyopaque) void;
extern fn g_signal_connect_data(
    instance: *anyopaque,
    detailed_signal: [*:0]const u8,
    c_handler: *const anyopaque,
    data: ?*anyopaque,
    destroy_data: ?*const anyopaque,
    connect_flags: c_int,
) c_ulong;

extern fn gtk_application_window_new(app: *GtkApplication) *GtkApplicationWindow;
extern fn gtk_window_set_title(window: *GtkApplicationWindow, title: [*:0]const u8) void;
extern fn gtk_window_set_default_size(window: *GtkApplicationWindow, width: c_int, height: c_int) void;
extern fn gtk_window_set_child(window: *GtkApplicationWindow, child: *GtkWidget) void;
extern fn gtk_window_present(window: *GtkApplicationWindow) void;

extern fn gtk_button_new_with_label(label: [*:0]const u8) *GtkWidget;
extern fn gtk_button_set_label(button: *GtkButton, label: [*:0]const u8) void;

fn connect(instance: anytype, signal: [*:0]const u8, handler: anytype) void {
    const inst: *anyopaque = @ptrCast(instance);
    const func: *const anyopaque = @ptrCast(handler);
    _ = g_signal_connect_data(inst, signal, func, null, null, 0);
}

fn activate(app: *GtkApplication, _: ?*anyopaque) callconv(.c) void {
    const window = gtk_application_window_new(app);
    gtk_window_set_title(window, "GTK4 + Zig");
    gtk_window_set_default_size(window, 400, 300);

    const button = gtk_button_new_with_label("Click Me!");
    gtk_window_set_child(window, button);
    connect(button, "clicked", &onButtonClicked);

    gtk_window_present(window);
}

fn onButtonClicked(button: *GtkButton, _: ?*anyopaque) callconv(.c) void {
    gtk_button_set_label(button, "Clicked!");
}

pub fn main() !void {
    const app = gtk_application_new("com.example.gtk4zig", 0) orelse return error.FailedToCreateApp;
    defer g_object_unref(app);

    connect(app, "activate", &activate);

    std.process.exit(@intCast(g_application_run(app, 0, null)));
}
