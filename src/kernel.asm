org 0x7E00
include 'macros.inc'

start:
    init_stack 0x9000, 0xFFFF

    clear_screen

    set_cursor 0, 0
    print_color welcome_msg, welcome_msg_len, 0x0A, 0x07

    sleep 2
    set_cursor 2, 0
    print version_msg, versiom_msg_len

    set_cursor 4, 0
    print command_promt_msg, command_promt_msg_len
    input

    print test_msg, test_msg_len

    hlt
    jmp $

welcome_msg db "Welcome to the OS prototype!"
welcome_msg_len = $ - welcome_msg

version_msg db "Current version: 0.0.3 Alpha"
versiom_msg_len = $ - version_msg

command_promt_msg db "~ # "
command_promt_msg_len = $ - command_promt_msg

test_msg db "Input validation passed!"
test_msg_len = $ - test_msg
