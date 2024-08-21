[bits 16]
switch_to_pm:
  ; Disable interrupts
  cli

  ; Load GDT
  lgdt [gdt_descriptor]

  ; Flip first bit of cr0 to switch to 32-bit protected mode
  mov eax, cr0
  or eax, 0x1
  mov cr0, eax

  ; Make far jump to the start of the 32-bit code
  ; and flushes the CPU's cache to prevent use of
  ; instructions pre-decoded in 16-bit mode
  jmp CODE_SEG:init_pm


[bits 32] ; 32-bit protected mode from here on
init_pm:
  mov ax, DATA_SEG  ; Point all the real mode
  mov ds, ax        ; segments to the data
  mov ss, ax        ; selector of the GDT
  mov es, ax
  mov fs, ax
  mov gs, ax

  mov ebp, 0x90000  ; Point stack to the top 
  mov esp, ebp      ; of the free space

  call BEGIN_PM
