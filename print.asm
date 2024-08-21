[bits 32]
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

; Write null terminated string 
; into buffer pointed to by edx
print:
  pusha
  mov edx, VIDEO_MEMORY

print_loop:
  mov al, [ebx]
  mov ah, WHITE_ON_BLACK

  cmp al, 0     ; End of string found
  je print_done

  mov [edx], ax ; Write char into video memory

  add ebx, 1    ; Increment to next char in string
  add edx, 2    ; Move to next char cell in memory

  jmp print_loop

print_done:
  popa
  ret
