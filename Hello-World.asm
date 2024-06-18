org 100h

jmp main ; if we don't put this here, the assembler will find the code under `message` and try to execute it
; this is because, the assembler executes top-down

message: ;this is a label not a variable
    ; this is besically our data section
    ; db stands for data-byte
    db 'Hello World!', 0

print: ;this is a label not a variable
    mov ah, 0eh ;0eh is a command to the BIOS

._loop: ;this is a label not a variable
    lodsb ; loads the first character from message and increment the 'si' register
    cmp al, 0 ; compares al register's value to 0, if so, '.done' is executed
    je .done
    int 10h ; interrupt 10h is for vidoe routines

    jmp ._loop ; here we are jumping back to the starting of '._loop' if 'com al, 0' is 'false'

.done: ;this is a label not a variable
    ret

main: ;this is a label not a variable
    mov si, message ; here we are moving the address of `Hello World!` in memory to the `si` register
    call print

ret
