section .data
send_buffer db "hello", 10
len1 equ $ - send_buffer
optval dq 1

sockaddr:

dw 2
dw 0x4A75
dd 0x0100007F
dq 0


section .bss
recv_buffer resb 10
serv_addr resb 16
lenserv_addr resb 16
len_addr resq 1

section .text
global _start

_start:

;socket syscall

mov rax, 41
mov rdi, 2
mov rsi, 2
mov rdx, 0
syscall

mov r12, rax

;socketoption

mov rax, 54
mov rdi, r12
mov rsi, 1
mov rdx, 2
mov r10, optval
mov r8, 8
syscall


looping:

;send syscall

mov rax, 44
mov rdi, r12
mov rsi, send_buffer
mov rdx, len1
mov r10, 0
mov r8, sockaddr
mov r9, 16
syscall

;recv syscall

mov qword [len_addr], 16

mov rax, 45
mov rdi, r12
mov rsi, recv_buffer
mov rdx, 10
mov r10, 0
mov r8, serv_addr
mov r9, len_addr
syscall

;write syscall

mov rax, 1
mov rdi, 1
mov rsi, recv_buffer
mov rdx, 10
syscall

jmp looping


;close syscall

mov rax, 3
mov rdi, r12
syscall

;exit syscall

mov rax, 60
mov rdi, 0
syscall

