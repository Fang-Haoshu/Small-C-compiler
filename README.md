# Small-C-compiler
This is the project of course CS308, compiler principle, in SJTU

There are two parts of it. 
The first part translate Small-C into a parse tree. This part is in the file tree.c

The second part translate the parse tree into intermediate code. This part is in the file IR.c
The intermediate code can be translated by LLVM.

How to use it:

1. cd to this directory

2. make

3. ./a.out "your source file"

You can use the testcases to test this program.