; Printing A to the screen
org 100h
    mov ah, 0eh
    mov al, 'A'
    int 10h
ret
