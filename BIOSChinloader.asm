[BITS 16]
[ORG 0x7C00] ; BIOS loads the bootloader at this address

; Data section
menu db 'Welcome to ChinLoader!', 0
os_found db 'Detected OS: ', 0
os_not_found db 'No OS found.', 0
prompt db 'Select an OS to boot (1-9): ', 0
invalid db 'Invalid selection, please try again.', 0
partition_table db 64 dup(0)

; OS signatures for detection
windows_signature db 'bootmgr', 0
ubuntu_signature db 'vmlinuz', 0
fedora_signature db 'vmlinuz', 0
solaris_signature db 'kernel', 0
symbian_signature db 'Symbian', 0
zorin_signature db 'vmlinuz', 0
kali_signature db 'vmlinuz', 0
arch_signature db 'vmlinuz', 0
unix_signature db 'vmlinuz', 0 ; Placeholder for Unix

; Function to print a string
print_string:
    pusha
.next_char:
    lodsb
    cmp al, 0
    je .done
    mov ah, 0x0E ; BIOS teletype output
    int 0x10
    jmp .next_char
.done:
    popa
    ret

; Function to detect operating systems in partitions
detect_os:
    ; Read the first sector of the disk to get the partition table
    mov ah, 0x02         ; Read sectors
    mov al, 1            ; Number of sectors to read
    mov ch, 0           ; Cylinder
    mov cl, 2           ; Sector (start at 2)
    mov dh, 0           ; Head
    mov bx, partition_table ; Buffer for the partition table
    int 0x13            ; Call BIOS

    ; Check partition entries
    mov si, partition_table

    ; Loop through the first four partition entries
    mov cx, 4
.next_partition:
    cmp byte [si + 0x1BE], 0 ; Check if the partition is active
    je .next_entry           ; If not active, skip

    ; Here you would add logic to read the first sector of each partition
    ; and look for the OS signatures. This is simplified for brevity.

    call check_os           ; Check for OS signatures
.next_entry:
    add si, 16              ; Move to the next partition entry
    loop .next_partition
    jmp .done_detecting

.done_detecting:
    mov si, os_not_found
    call print_string
    ret

check_os:
    ; Read the first sector of the partition to look for OS signatures
    ; (You will need to implement this read logic)

    ; Example check for Windows
    mov si, windows_signature
    call print_string
    ; Check for Ubuntu
    mov si, ubuntu_signature
    call print_string
    ; Check for Fedora
    mov si, fedora_signature
    call print_string
    ; Check for Solaris
    mov si, solaris_signature
    call print_string
    ; Check for Symbian
    mov si, symbian_signature
    call print_string
    ; Check for Zorin
    mov si, zorin_signature
    call print_string
    ; Check for Kali
    mov si, kali_signature
    call print_string
    ; Check for Arch Linux
    mov si, arch_signature
    call print_string
    ; Check for Unix
    mov si, unix_signature
    call print_string
    
    ret

; Function to read user input and boot the selected OS
boot_os:
    mov si, prompt
    call print_string

    ; Read input
    mov ah, 0
    int 0x16 ; Wait for key press
    sub al, '0' ; Convert ASCII to integer
    cmp al, 9
    jg invalid_selection ; Check bounds

    ; Boot selected OS (dummy implementation)
    jmp $ ; Hang for now

invalid_selection:
    mov si, invalid
    call print_string
    jmp detect_os ; Show detected OS again

; Main entry point
start:
    call detect_os
    call boot_os

; Fill the rest of the boot sector with zeros
times 510 - ($ - $$) db 0
dw 0xAA55 ; Boot sector signature
