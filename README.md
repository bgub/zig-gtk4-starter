# zgtk

A simple demo of using Zig to create a GTK4 application. Inspired by [Ghostty](https://github.com/ghostty-org/ghostty), which uses Zig as the core and GTK4 for the Linux GUI.

Just publishing since it took a while to get everything working (C interop and build especially).

## Requirements

- Zig (latest stable)
- GTK4 development libraries

## Build & Run

```bash
zig build run
```

The executable will be built in `zig-out/bin/gtk4-app`.

## What it does

Creates a simple GTK4 window with a button. Clicking the button changes its label from "Click Me!" to "Clicked!".

## Screenshot

![Contents of the GTK window that pops up](./images/screenshot.png)