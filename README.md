# 64-bit bare bones

So. You want to write a 64-bit OS.

You have to do many things, like enabling the A20 line, setting up paging, global descriptor tables.

So I have compiled all that code into *one simple file*. 512 bytes, too! It enables A20, both 32-bit and 64-bit GDT, PAE and 32-bit and 64-bit mode.

This actually fits in 355 bytes (without the boot signature), so there's space for improvement.

You can use it for your bootloader,kernel,etc.

It prints "P" for protected mode, then "L" if it is in long mode, otherwise it prints "N" (not supported)

Thanks to all of these websites for information and great tutorials:

[http://3zanders.co.uk/2017/10/16/writing-a-bootloader2](http://3zanders.co.uk/2017/10/16/writing-a-bootloader2)
[https://wiki.osdev.org/Pmode](https://wiki.osdev.org/Pmode)
[https://wiki.osdev.org/Setting_Up_Long_Mode](https://wiki.osdev.org/Setting_Up_Long_Mode)
[http://www.osdever.net/tutorials/view/the-world-of-protected-mode](http://www.osdever.net/tutorials/view/the-world-of-protected-mode)
