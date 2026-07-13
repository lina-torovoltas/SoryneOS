org 0x0000
include 'libs/kernel.inc'



start:
    clear_screen

    set_cursor 0, 0
    print_color welcome_msg, welcome_msg_len, 0x0A, 0x07

    sleep 2
    set_cursor 2, 0
    print version_msg, version_msg_len

    set_cursor 4, 0
    print command_promt_msg, command_promt_msg_len
    input

    print test_msg, test_msg_len

    cli
    hlt




welcome_msg db "Welcome to the SoryneOS!"
welcome_msg_len = $ - welcome_msg

version_msg db "Current version: 0.1.5 Alpha"
version_msg_len = $ - version_msg

command_promt_msg db "~ # "
command_promt_msg_len = $ - command_promt_msg

test_msg db "Input validation passed!"
test_msg_len = $ - test_msg


times 2040 - ($ - $$) db 0
dq 0x534f656e79726f53