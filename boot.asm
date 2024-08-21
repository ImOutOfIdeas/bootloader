[org 0x7c00]

[bits 16]
  call switch_to_pm ; Never returns

  jmp $

%include "src/gdt.asm"
%include "src/print.asm"
%include "src/switch_to_pm.asm"

[bits 32]
BEGIN_PM: ; start of 32-bit pm code
  mov ebx, MSG_PROT_MODE
  call print

  jmp $

; Global variables
MSG_PROT_MODE db "You've made it to the protected land. Congrats!", 0

times 510-($-$$) db 0
dw 0xaa55
