# zgtk

A simple demo of using Zig to create a GTK4 application. Inspired by [Ghostty](https://github.com/ghostty-org/ghostty), which uses Zig as the core and GTK4 for the Linux GUI. This project now consumes the [zig-gobject](https://github.com/ianprime0509/zig-gobject) bindings to talk to GTK instead of hand-written FFI.

Just publishing since it took a while to get everything working (C interop and build especially).

## Requirements

- Zig 0.14.0 or newer
- GTK4 development libraries that match the GNOME 47 SDK (the pre-built bindings we use target GNOME 47)
- Internet access the first time you run `zig build` so the zig package manager can fetch the `zig-gobject` bindings

## Build & Run

```bash
zig build run
```

The executable will be built in `zig-out/bin/gtk4-app`.

The build pulls in the GNOME 47 bindings bundle from the `zig-gobject` v0.3.0 release and wires up the `gtk`, `gio`, `gobject`, and `glib` modules automatically. If you want to target a different GNOME SDK version, update the dependency URL in `build.zig.zon` accordingly.

## What it does

Creates a simple GTK4 window with a button. Clicking the button changes its label from "Click Me!" to "Clicked!".

## Screenshot

![Contents of the GTK window that pops up](./images/screenshot.png)