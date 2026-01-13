macro push [reg] { push reg }

macro pop [reg] { pop reg }

macro init_stack seg, ofs {
    mov ax, seg
    mov ss, ax
    mov sp, ofs
}

macro clear_screen attr=0x07 {
    push ax, bx, cx, dx

    mov ax, 0x0600
    mov bh, attr
    mov cx, 0x0000
    mov dx, 0x184F
    int 0x10

    pop dx, cx, bx, ax
}

macro set_cursor row, col {
    push ax, bx, dx

    mov ah, 0x02
    mov bh, 0x00
    mov dh, row
    mov dl, col
    int 0x10

    pop dx, bx, ax
}

macro print_color ptr, len, fg=0x07, bg=0x00 {
    push ax, cx, si, di

    local .print_loop

    mov ax, 0xB800
    mov es, ax
    mov di, 0
    mov si, ptr
    mov cx, len

    .print_loop:
        lodsb
        mov ah, bg
        shl ah, 4
        or ah, fg
        stosw
        loop .print_loop

    pop di, si, cx, ax
}

macro print ptr, len {
    push ax, cx, si

    local .print_loop

    mov si, ptr
    mov cx, len

    .print_loop:
        lodsb
        mov ah, 0x0E
        int 0x10
        loop .print_loop

    pop si, cx, ax
}

macro sleep secs {
    push ax, bx, cx, dx

    mov bx, secs

    local .wait_loop

    .wait_loop:
        mov ah, 0x86
        mov cx, 0x000F
        mov dx, 0x4240
        int 0x15
        jc .wait_loop

        dec bx
        jnz .wait_loop

    pop dx, cx, bx, ax
}

macro input {
    push ax, bx, dx

    local .loop, .done

    .loop:
        mov ah, 0x00
        int 0x16

        cmp al, 0x0D
        je .done

        mov ah, 0x0E
        int 0x10

        jmp .loop

    .done:
        mov ah, 0x03
        mov bh, 0x00
        int 0x10

        add dh, 2
        mov dl, 0

        set_cursor dh, dl

    pop dx, bx, ax
}
