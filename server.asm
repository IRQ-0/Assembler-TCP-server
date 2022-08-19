	global _start
section .text
_start:
	;; int sock = socket(AF_INET, SOCKET_STREAM, 0)
	mov rax, 41 		; function number for syscall
	mov rdi, 2		; domain selection (2 = AF_INET)
	mov rsi, 1		; type selection (1 = SOCKET STREAM)
	mov rdx, 0		; protocol selection (0 = IP)
	syscall			; kernel call
	
	;; bind(sock, s, 16)
	mov rdi, rax 		; handle to socket created by previous function
	mov rax, 49		; function number for syscall
	mov rsi, s		; sockaddr struct defined in .data section
	mov rdx, 16 		; struct length
	syscall 		; kernel call

	;; lsiten(sock, 10)
	mov rax, 50 		; function number for syscall
	mov rsi, 10		; max clients
	syscall 		; kernel call
	;; Note that main socket handle is in rdi register

	;; int client = accept(sock, 0, 0)
	mov rax, 43		; function number for syscall
	xor rsi, rsi		; clear rsi register
	xor rdx, rdx		; clear rdx register
	syscall			; kernel call
	mov [client], rax	; move main socket handle to client value
	
	;; puts("Client connected!")
	mov rax, 1		; function number for syscall
	mov rdi, 1		; file descriptor (1 = stdout)
	mov rsi, conn		; conn string defined in .data section
	mov rdx, conn_l		; conn string length
	syscall 		; kernel call

	;; sendto(client, mess, strlen(mess))
	mov rax, 1		; function number for syscall
	mov rdi, [client] 	; file descriptor (client value because we are writing to client)
	mov rsi, mess 		; message
	mov rdx, mess_l 	; message length
	syscall			; kernel call

	;; exit(0)
	mov rax, 60		; function number for syscall
	mov rdi, 0		; exit code 0
	syscall			; kernel call

section .data
	;; struct sockaddr_in s;
	;; s.sin_family = AF_INET;
	;; s.sin_port = htons(1234);
	;; s.sin_addr = "127.0.0.1";
s:	dw 2			; AF_INET
	db 04h, 0D2h		; 1234
	db 7fh, 0h, 0h, 01h	; 127.0.0.1 (localhost)
	db 0, 0, 0, 0, 0, 0, 0, 0 ; 8 zeros

	;; char* str = {"Client connected!\n"};
conn:	db "Client connected!", 0xa ; "Client connected!" string with EOL
	;; int len = strlen(str);
conn_l:	equ $ - conn		    ; string length

	;; char* str = {Hello world!\n"};
mess:	db "Hello world!", 0xa	; "Hello world!" string with EOL
	;; int len = strlen(str);
mess_l:	equ $ - mess		; string length

	;; DWORD client;
client:	resw 2			; reserve 2 words for client value
