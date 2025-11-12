const std = @import("std");

// Opaque types for GTK4 C structs (we don't need their internals)
const GtkApplication = opaque {};
const GtkApplicationWindow = opaque {};
const GtkWidget = opaque {};
const GtkButton = opaque {};

// FFI declarations - C functions from GTK4
extern fn gtk_application_new(application_id: [*:0]const u8, flags: c_int) ?*GtkApplication;
extern fn g_application_run(app: *GtkApplication, argc: c_int, argv: ?[*]?[*:0]u8) c_int;
extern fn g_object_unref(object: *anyopaque) void; // Decrement ref count
extern fn g_signal_connect_data(
    instance: *anyopaque, // GTK object emitting the signal
    detailed_signal: [*:0]const u8, // Signal name (e.g., "clicked", "activate")
    c_handler: *const anyopaque, // Callback function pointer
    data: ?*anyopaque, // Optional user data to pass to callback
    destroy_data: ?*const anyopaque, // Optional cleanup function for user data
    connect_flags: c_int, // Connection flags (0 = default)
) c_ulong;

extern fn gtk_application_window_new(app: *GtkApplication) *GtkApplicationWindow;
extern fn gtk_window_set_title(window: *GtkApplicationWindow, title: [*:0]const u8) void;
extern fn gtk_window_set_default_size(window: *GtkApplicationWindow, width: c_int, height: c_int) void;
extern fn gtk_window_set_child(window: *GtkApplicationWindow, child: *GtkWidget) void; // GTK4: single child
extern fn gtk_window_present(window: *GtkApplicationWindow) void; // Show window
extern fn gtk_button_new_with_label(label: [*:0]const u8) *GtkWidget;
extern fn gtk_button_set_label(button: *GtkButton, label: [*:0]const u8) void;

// Helper to connect signals (wraps g_signal_connect_data)
fn connect(instance: anytype, signal: [*:0]const u8, handler: anytype) void {
    const inst: *anyopaque = @ptrCast(instance); // Cast to void* for C API
    const func: *const anyopaque = @ptrCast(handler);
    _ = g_signal_connect_data(inst, signal, func, null, null, 0);
}

// Called when app starts (activate signal)
fn activate(app: *GtkApplication, _: ?*anyopaque) callconv(.c) void {
    const window = gtk_application_window_new(app);
    gtk_window_set_title(window, "GTK4 + Zig");
    gtk_window_set_default_size(window, 400, 300);

    const button = gtk_button_new_with_label("Click Me!");
    gtk_window_set_child(window, button);
    connect(button, "clicked", &onButtonClicked);

    gtk_window_present(window);
}

// Called when button is clicked
fn onButtonClicked(button: *GtkButton, _: ?*anyopaque) callconv(.c) void {
    gtk_button_set_label(button, "Clicked!");
}

pub fn main() !void {
    const app = gtk_application_new("com.example.gtk4zig", 0) orelse return error.FailedToCreateApp;
    defer g_object_unref(app); // Cleanup on exit

    connect(app, "activate", &activate);
    std.process.exit(@intCast(g_application_run(app, 0, null))); // Run event loop
}
