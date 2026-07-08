use16
org 0x7C00
include 'macros.inc'



start:
    cli

    init_stack 0x2000, 0xFFFF

    disable_nmi
    clear_flags
    clear_segments
    enable_a20

    finit
    enable_nmi

    mov [boot_drive], dl

    sti

    clear_screen
    set_cursor 0, 0
    print_color boot_msg, boot_msg_len

    sleep 5

    mov dl, [boot_drive]
    mov ax, 0x1000
    mov es, ax
    mov bx, 0x0000

    mov ah, 0x02
    mov al, 4
    mov ch, 0
    mov cl, 2
    mov dh, 0
    int 0x13

    jc .error

    mov ax, 0x1000
    mov ds, ax

    jmp 0x1000:0x0000

.error:
    clear_screen
    print_color error_msg, error_msg_len, 0x07, 0x04

    cli
    hlt

check_a20:
    xor ax, ax
    mov es, ax
    mov ax, 0xFFFF
    mov ds, ax
    mov byte [es:0x7E00], 0x00
    mov byte [ds:0x7E10], 0xFF
    cmp byte [es:0x7E00], 0xFF
    
    xor ax, ax
    mov ds, ax
    ret



boot_msg db "Booting SoryneOS..."
boot_msg_len = $ - boot_msg

error_msg db "Kernel loading error!"
error_msg_len = $ - error_msg


boot_drive rb 1
times 510 - ($ - $$) db 0
dw 0xAA55
