# z80-pong

This is a tiny pong-like game for the zx spectrum written in z80 assembly language.  There's not much to it, just the basic physics and two paddles, no sounds or scoring, and the code is rudimentary.  It doesn't even use the actual screen bitmap, only the 32x24 attributes

I wrote this as a trip down memory lane, having spent a lot of time as a kid trying to understand z80 machine code.  I had a zx spectrum but no assembler and no other machines to cross-compile from, indeed cross-compiling seemed like magic.  My efforts at the time were all hand-constructed hex dumps using lists of opcodes and the z80 rom disassembly book, not a very easy way to get stuff done.

I wrote this using vscode and the excellent DeZog debugger https://github.com/maziac/DeZog, with its in built zsim emulator.  The z80 compiled is sjasmplus https://github.com/z00m128/sjasmplus which I compiled for MacOs.  This project is cannibalised from the https://github.com/maziac/z80-sample-program sample program.

https://raw.githubusercontent.com/pgleghorn/z80-pong/main/videos/pong-bitmap-video-1.mp4
