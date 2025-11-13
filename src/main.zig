const std = @import("std");
const glib = @import("glib");
const gobject = @import("gobject");
const gio = @import("gio");
const gtk = @import("gtk");

pub fn main() void {
    var app = gtk.Application.new("com.example.gtk4zig", .{});
    defer app.unref();

    _ = gio.Application.signals.activate.connect(app, ?*anyopaque, &activate, null, .{});

    const status = gio.Application.run(
        app.as(gio.Application),
        @intCast(std.os.argv.len),
        std.os.argv.ptr,
    );
    std.process.exit(@intCast(status));
}

fn activate(app: *gtk.Application, _: ?*anyopaque) callconv(.c) void {
    var window = gtk.ApplicationWindow.new(app);
    gtk.Window.setTitle(window.as(gtk.Window), "GTK4 + Zig");
    gtk.Window.setDefaultSize(window.as(gtk.Window), 400, 300);

    var button = gtk.Button.newWithLabel("Click Me!");
    _ = gtk.Button.signals.clicked.connect(button, ?*anyopaque, &onButtonClicked, null, .{});

    gtk.Window.setChild(window.as(gtk.Window), button.as(gtk.Widget));
    gtk.Widget.show(window.as(gtk.Widget));
}

fn onButtonClicked(button: *gtk.Button, _: ?*anyopaque) callconv(.c) void {
    gtk.Button.setLabel(button, "Clicked!");
}
