## Compilation:
```nasm -f elf 64 server.asm -o server.o```
## Linking:
```ld server.o -o server```
## Run:
```./server```
## Testing:
``` nc -v 127.0.0.1 1234```
