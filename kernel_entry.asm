[BITS 32]
[extern main] ; Tell the assembler that 'main' is defined elsewhere (in our C file)

CALL main
JMP $