macro clear_flags {
    cld
    push 0
    popf
}

macro clear_segments {
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
}

macro enable_a20 {
    local .check_a20, .skip

    jmp .skip
    .check_a20:
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
    .skip:

    call .check_a20
    jnz .a20_done
    
    mov ax, 0x2401
    int 0x15
    call .check_a20
    jnz .a20_done
    
    in al, 0x92
    or al, 0x02
    out 0x92, al
    call .check_a20
    jnz .a20_done
    
    mov al, 0xD1
    out 0x64, al
    mov al, 0xDF
    out 0x60, al
    call .check_a20
    
    .a20_done:
}

macro disable_nmi {
    in al, 0x70
    or al, 0x80
    out 0x70, al
}

macro enable_nmi {
    in al, 0x70
    and al, 0x7F
    out 0x70, al
}

macro init_stack seg, ofs {
    mov ax, seg
    mov ss, ax
    mov sp, ofs
}

macro clear_screen attr=0x07 {
    push ax bx cx dx

    mov ax, 0x0600
    mov bh, attr
    mov cx, 0x0000
    mov dx, 0x184F
    int 0x10

    pop dx cx bx ax
}

macro get_cursor {
    push ax bx

    mov ah, 0x03
    mov bh, 0x00
    int 0x10
    pop bx ax
}

macro set_cursor row, col {
    push ax bx dx

    mov ah, 0x02
    mov bh, 0x00
    mov dh, row
    mov dl, col
    int 0x10

    pop dx bx ax
}

macro print_color ptr, len, fg=0x07, bg=0x00 {
    push ax cx si di

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

    pop di si cx ax
}

macro print ptr, len {
    push ax cx si

    local .print_loop

    mov si, ptr
    mov cx, len

    .print_loop:
        lodsb
        mov ah, 0x0E
        int 0x10
        loop .print_loop

    pop si cx ax
}

macro sleep secs {
    push ax bx cx dx

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

    pop dx cx bx ax
}

macro input {
    push ax bx dx

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

    pop dx bx ax
}