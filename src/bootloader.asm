use16
org 0x7C00
include 'macros.inc'

start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    init_stack 0x9000, 0xFFFF

    mov [boot_drive], dl

    clear_screen
    set_cursor 0, 0
    print_color boot_msg, boot_msg_len

    sleep 5

    mov dl, [boot_drive]
    xor ax, ax
    mov es, ax
    mov bx, 0x7E00

    mov ah, 0x02
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov dh, 0
    int 0x13
    jc .error

    jmp 0x0000:0x7E00

.error:
    clear_screen
    print_color error_msg, error_msg_len, 0x07, 0x04

    hlt
    jmp $

boot_msg db "Booting OS..."
boot_msg_len = $ - boot_msg
error_msg db "Error while loading main kernel!"
error_msg_len = $ - error_msg


boot_drive rb 0

times 510 - ($ - $$) db 0
dw 0xAA55
