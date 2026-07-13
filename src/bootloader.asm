use16
org 0x7C00
jmp start
include 'libs/boot.inc'

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

    mov bx, 1
    call sleep

    call clear_screen

    mov si, boot_confirm_msg
    mov cx, boot_confirm_msg_len
    call print

    mov dh, 2
    mov dl, 0
    call set_cursor

    mov si, boot_confirm_keys
    mov cx, boot_confirm_keys_len
    call print

wait_for_acp:
    mov ah, 0x00
    int 0x16
    
    or al, 0x20
    cmp al, 'y'
    je boot

    cmp al, 'n'
    je reboot

    jmp wait_for_acp

boot:
    mov bx, 1
    call sleep
    
    call clear_screen

    mov si, boot_msg
    mov cx, boot_msg_len
    call print

    mov bx, 1
    call sleep

    mov dl, [boot_drive]
    mov ax, 0x1000
    mov es, ax
    mov bx, 0x0000

    mov ah, 0x02
    mov al, [kernel_sectors]
    mov ch, 0
    mov cl, 2
    mov dh, 0
    int 0x13

    jc error

    mov ax, 0x1000
    mov ds, ax

    jmp 0x1000:0x0000

error:
    call clear_screen

    mov si, error_msg
    mov cx, error_msg_len
    mov al, 0x07
    mov ah, 0x04
    call print_color

    mov al, [kernel_sectors]
    add al, '0'
    mov ah, 0x0E
    int 0x10

    mov dh, 2
    mov dl, 0
    call set_cursor
    
    mov si, error_retry_msg
    mov cx, error_retry_msg_len
    call print

wait_for_key:
    mov ah, 0x00
    int 0x16
    
    or al, 0x20
    cmp al, 'r'
    je boot

    cmp al, 'b'
    je reboot

    jmp wait_for_key

reboot:
    jmp 0xFFFF:0x0000 



boot_confirm_msg db "Wait... Are you sure you want to boot the OS?"
boot_confirm_msg_len = $ - boot_confirm_msg

boot_confirm_keys db "Press Y or N"
boot_confirm_keys_len = $ - boot_confirm_keys

boot_msg db "Attempting to load kernel..."
boot_msg_len = $ - boot_msg

error_msg db "  sect. Kernel loading error!"
error_msg_len = $ - error_msg

error_retry_msg db "Press R to retry or B to reboot"
error_retry_msg_len = $ - error_retry_msg

boot_drive rb 1
kernel_sectors db 4



times 510 - ($ - $$) db 0
dw 0xAA55
