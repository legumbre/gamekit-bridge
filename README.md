# gkbridge.framework

A minimal framework that implements a C shim for a subset of GameKit (GameCenter) functions.

Why? Because

 - I can use the exposed functions through LuaJIT's FFI
 - I want a drop-in shared library I can ship along a vanilla Love2D build.

