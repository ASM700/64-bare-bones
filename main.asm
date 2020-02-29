use16
org 7c00h

CODE_SEG equ gdt_code - gdt
DATA_SEG equ gdt_data - gdt
CODE64_SEG equ gdt64_code - gdt64
DATA64_SEG equ gdt64_data - gdt64

start:
  mov ax, 0x2401
  int 15h
  mov ax, 0x3
  int 10h
  cli
  xor ax, ax
  mov ds, ax
  lgdt [gdt_desc]
  mov eax, cr0
  or eax, 0x1
  mov cr0, eax
  jmp CODE_SEG:clear_pipe

use32
clear_pipe:
  mov ax, DATA_SEG
  mov ds, ax
  mov ss, ax
  mov es, ax
  mov fs, ax
  mov gs, ax
  mov ebp, 090000h
  mov esp, ebp
  mov byte [0xB8000], 'P'
mov byte [0xB8001], 1Bh
setup_64:
  mov eax, 80000000h
  cpuid
  cmp eax, 80000001h
  jb nope
  mov eax, 80000001h
  cpuid
  test edx, 1 shl 29
  jz nope
  mov eax, cr0
  and eax, 01111111111111111111111111111111b
  mov cr0, eax
  mov edi, 0x1000
  mov cr3, edi
  xor eax, eax
  mov ecx, 4096
  rep stosd
  mov edi, cr3
  mov dword [edi], 0x2003
  add edi, 0x1000
  mov dword [edi], 0x3003
  add edi, 0x1000
  mov dword [edi], 0x4003
  add edi, 0x1000
  mov ebx, 0x00000003
  mov ecx, 512
setentry:
  mov dword [edi], ebx
  add ebx, 0x1000
  add edi, 8
  loop setentry
  mov eax, cr4
  or eax, 1 shl 5
  mov cr4, eax
  mov ecx, 0xC0000080
  rdmsr
  or eax, 1 shl 8
  wrmsr
  mov eax, cr0
  or eax, 1 shl 31
  mov cr0, eax
  lgdt [gdt64_desc]
  jmp CODE64_SEG:final64
nope:
  mov byte [0xB8002], 'N'
  mov byte [0xB8003], 1Bh
  jmp $

use64
final64:
  mov ax, DATA64_SEG
  mov ds, ax
  mov ss, ax
  mov es, ax
  mov fs, ax
  mov gs, ax
  mov byte [0xB8002], 'L'
  mov byte [0xB8003], 1Bh
  jmp $

gdt:
gdt_null:
  dq 0
gdt_code:
  dw 0FFFFh
  dw 0
  db 0
  db 10011010b
  db 11001111b
  db 0
gdt_data:
  dw 0FFFFh
  dw 0
  db 0
  db 10010010b
  db 11001111b
  db 0
gdt_end:

gdt_desc:
  dw gdt_end - gdt - 1
  dd gdt

gdt64:
gdt64_null:
  dw 0xFFFF
  dw 0
  db 0
  db 0
  db 1
  db 0
gdt64_code:
  dw 0
  dw 0
  db 0
  db 10011010b
  db 10101111b
  db 0
gdt64_data:
  dw 0
  dw 0
  db 0
  db 10010010b
  db 00000000b
  db 0
gdt64_end:

gdt64_desc:
  dw gdt64_end - gdt64 - 1
  dq gdt64

times 510-($-start) db 0
dw 0xAA55
times (1440*1024-512) db 0
