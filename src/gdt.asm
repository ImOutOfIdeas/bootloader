gdt_start:

gdt_null: ; Mandatory null descriptor
  dd 0x0 
  dd 0x0

gdt_code: ; Code segment descriptor
  ; base = 0x0, limit = 0xfffff,
  ; (present)1 (privilege)00 (desc type)1
  ; (code)1 (conforming)0 (readable)1 (accessed)0
  ; (granularity)1 (32-bit)1 (64-bit seg)0 (AVL)0
  dw 0xffff     ; Limit (bits 0 -15)
  dw 0x0        ; Base (bits 0 -15)
  db 0x0        ; Base (bits 16 -23)
  db 10011010b  ; 1st flags, type flags
  db 11001111b  ; 2nd flags, Limit (bits 16-19)
  db 0x0        ; Base (bits 24-31)

gdt_data: ; Data segment descriptor
  ; Same as code segment expect type flags...
  ; (code)0 (expand down)0 (writable)1 (accessed )0
  dw 0xffff     ; Limit (bits 0-15)
  dw 0x0        ; Base (bits 0-15)
  db 0x0        ; Base (bits 16-23)
  db 10010010b  ; 1st flags, type flags
  db 11001111b  ; 2nd flags, Limit (bits 16-19)
  db 0x0        ; Base (bits 24-31)

gdt_end: ; Used to calculate GDT size

gdt_descriptor:
  dw gdt_end - gdt_start - 1 ; GDT size
  dd gdt_start               ; Address of our GDT

; Define constants for the GDT segment descriptor offsets, which
; are what segment registers must contain when in protected mode.
; (0x0 -> NULL ; 0x08 -> CODE ; 0x10 -> DATA)
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

; Disable interrupts
cli

; Load the GDT
lgdt [gdt_descriptor]

; flip first bit of cr0 to switch to 32-bit protected mode
mov eax, cr0
or eax, 0x1
mov cr0, eax
