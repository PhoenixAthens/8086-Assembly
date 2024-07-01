# Doubts and Notes
Q1: What's the meaning of a `COM` template in x86 programming especially msDOS 8086 Assembly?

A: The `.COM` file-format is a very simple executable file format used in MS-DOS and early version of Windows. Here are the key points about the `.COM` format:<br>
1. **Simplicity**: The `.COM` format has no complex file structure or headers. It is simply a flat binary of the executable code and data.
2. **Memory Layuot**: When a `.COM` file is executed, the entire file is loaded into memory starting at address `0x0100`. The memory below `0x0100` is used for the Program Segment Prefix (PSP), which contains information about the program.
3. **Entry Point**: The program execution always begins at the very first byte of the `.COM` file, which is located at address `0x0100`.
4. **Memory Model**: `.COM` files are limited to a "tiny" memory model, meaning the entire program (code, data, and stack) must fit within a single 64KB segment of memory.
5. **Registers**: When the `.COM` file starts executing, the CPU registers are set up such that `CS`, `DS`, `ES`, and `SS` all point to the same segment where the program is loaded.
6. **Simplicity for Developers**: The simplicity of the `.COM` format made it easy for early assembly language programmers to create small, self-contained programs that could be easily distributed and executed on MS-DOS systems.

In systems, the `.COM` format was a very lightweight and straightforward executable format well-suited for the limited memory and resourcs of early personal computers running MS-DOS. Its simplicity made it a popular choice for small, standalone programs written in 8086 assembly language.

------

Q2: How about the `BIN`, `BOOT`, and `EXE` templates?

A: `BIN`, `BOOT`, and `EXE` are some other common executable file formats used in the MS-DOS and early Windows environments:

1. `BIN (Binary) Format`:
  - The `.BIN` format is even simpler than the `.COM` format.
  - It is just a raw binary image of the executable code, without any file header or structure.
  - The `.BIN` format is often used for small, low-level programs or firmware images that need to be loaded directly into memory.
  - There is no defined entry point or memory layout, so the loading process must know exactly where to place the binary in memory.

2. `BOOT (Boot Sector) Format`:
  - The `.BOOT` or boot sector format is used for programs that are designed to be loaded and executed directly from the first sector of a bootable storage device, such as a floopy disk or hard drive.
  - The boot sector is the first 512 bytes of a bootable volume, and it contains the code necessary to load the rest of the operating system.
  - Boot sector programs are very small and have a specific memory layout, as they need to fit within the 512-byte limit and be able to load the rest of the OS.

3. `EXE (Executable) Format`:
  - The `.EXE` format is a more complex executable file format used in MS-DOS and early Windows systems.
  - It includes a file header that provides information about the program, such as the entry point, memory layout, and other metadata.
  - The `.EXE` format supports more advanced features than the `.COM` format, such as segmented memory, relocation, nad the ability to load additional data or libraries.
  - The `.EXE` format was the primary executable format used for larger and more complex programs in the MS-DOS and early Windows environments.

In summary, while the `.COM` format was a simple and lightweight opition, the `.BIN`, `.BOOT`, and `.EXE` formats provided additional capabilities and flexibility for different types of programs and systems requirements in the MS-DOS and early Windows ecosystems.

----
Q3: Why do I have to wrap my `.COM` format 8086 assembly code for ms-DOS within the following lines ?
```asm
org 100h

; your code here

ret
```

A: The `org 100h` and `ret` lines in 8086 assembly code for the `MS-DOS` `.COM` format serve specific purposes:

1. `org 100h`:
  - The `org 100h` directive tells the assembler to start the program code at the memory address `0x0100`.
  - This is because in the `.COM` format, the entire program is loaded into memory starting at address `0x0100`.
  - The memory below `0x0100` is reserved for the `Program Segment Prefix (PSP)` which contains information abou the program.

2. `ret`:
  - The `ret` instruction at the end of the program is the return instruction, which tells the processor to return control back to the operating system (MS-DOS in this case).
  - In the `.COM` format, the program execution starts at `0x0100` and continues until the `ret` instruction is encountered, at which point the program terminates and control is returned to the operating system.

The reason for this specific structure is due to the way the `.COM` format works:
- The entire program, including the code and any data, must fit within a single 64KB segment of memory.
- The program is loaded starting at address `0x0100`, so the code needs to be positioned accordingly.
- The `ret` instruction at the end ensures that the program execution terminates and control is returned to the operating system.

By following this structure, your 8086 assembly code can be properly executed as a standalone `.COM` file in the MS-DOS environment. The `org 100h` and `ret` lines are essential for ensuring the correct memory layout and program flow for the `.COM` format.

---

Let's understand the following assembly code
```asm
org 100h
    mov ah, 0eh
    mov al, 'A'
    int 10h
ret
```
This is a simple x86 assembly program that displays the letter 'A' on the screen.<br>
Let's break down the code step by step:
- `org 100h`: This directive sets the origin of the program to `100h` (hexadecimal), which is the standard starting address for a `COM` (Compact) executable file.
- `mov ah, 0eh`: This instruction moves the value `0eh` (hexadecimal) into the `AH` register. The `AH` register is used to specify the function to be performed by the BIOS interrupt.
- `mov al, 'A'`: This instruction is used to moves the ASCII value of the letter 'A' (which is 41h) into the `AL` register. The `AL` register is used to hold the character to be displayed.
- `int 10h`: This instruction triggers the BIOS video interrupt (interrupt 10h). The BIOS video interrupt is responsible for handling all video-related operations, such as displaying characters on the screen. In this case, the combination of `AH=oeh` and `AL='A'`, tells the BIOS video interrupt to display the character 'A' on the screen using the current cursor position.
- `ret`: this instruction returns control back to the operating system or the program that called this assembly code.

When this program is executed, it will display the letter 'A' on the screen at the current cursor position. The cursor position may be the default position (usually the top-left corner of the screen) or a position that was set previously by the program of the operating system.

This basic x86 assembly program demonstrates the use of BIOS interrupts to perform simple I/O operations on the computer's display.

---
Q4: Let's try to understand the following code, line by line
```asm
org 100h

jmp main

message:
    db 'Hello World!', 0

print:
    mov ah, 0eh

._loop:
    lodsb
    cmp al, 0
    je .done
    int 10h

    jmp ._loop

.done:
    ret

main:
    mov si, message
    call print

ret
```

A:
Let's go through the 8086 assembly code you provided line by line:

1. `org 100h`: This is an assembler directive that sets the origin of the program to 100h (256 in decimal). This is the standard starting address for programs loaded by the BIOS in a DOS environment.

2. `jmp main`: This is a jump instruction that transfers control to the `main` label. The reason for this is that if the assembler finds the `message` label first, it will try to execute the data there, which is not the intended behavior. By jumping to the `main` label first, we ensure that the program execution starts from the correct point.

3. `message:` This is a label that marks the beginning of the data section. It is not a variable, but a label that the assembler uses to reference the data that follows.

4. `db 'Hello, World', 0:` This is a directive that defines a sequence of bytes in memory. The `db` stands for `"define byte"`, and the string `'Hello World!'`  is followed by a null character `0`, which is used to indicate the end of the string.

5. `print:` This is a label that marks the beginning of the `print` subroutine.

6. `mov ah, 0eh`: This instruction moves the value `0eh` (14 in decimal) into the `ah` register. This value is a BIOS interrupt code that corresponds to the "teletype output" function, which is used to display a character on the screen.

7. `._loop:`: This is a label that marks the beginning of the loop that prints the characters in the `message` string.

8. `lodsb`: This instruction loads the byte at the memory address pointed to by the `si` register into the `al` register, and then increments the `si` register to point to the next byte.

9. `cmp al, 0`: This instruction compares the value in the `al` register (the character just loaded) to the value `0` (the null character). If the values are equal, the `je` (jump if equal) instruction at the next line will be executed.

10. `je .done`: This instruction jumps to the `.done` label if the comparison in the previous line was true (i.e., the character in `al` was the null character).

11. `int 10h`: This instruction triggers BIOS interrupt `10h`, which is the video service interrupt. This will display the character in the `al` register on the screen.

12. `jmp ._loop`: This instruction jumps back to the beginning of the loop at the `._loop` label, so that the next character in the `message` string can be printed.

13. `.done:`: This is a label that marks the end of the `print` subroutine.

14. `ret` This instruction returns from the `print` subroutine.

15. `main:` This is a label that marks the beginning of the `main` subroutine.

16. `mov si, message`: This instruction moves the address of the `message` label into the `si` register. This is done to prepare the `lodsb` instruction in the `print` subroutine to read the characters from the `message` string.

17. `call print`: This instruction calls the `print` subroutine, which will print the `message` string to the screen.

18. `ret`: This instruction returns from the `main` subroutine, effectively ending the program.

In summary, the 8086 assembly code defines a simple program that prints the string "Hello World!" to the screen. The `jmp main` instruction at the beginning ensures that the program execution starts from the `main` subroutine, and the `print` subroutine is responsible for actually displaying the characters on the screen.
