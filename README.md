# Small-C-compiler
This is the project of course CS308, compiler principle, in SJTU

####lex.l yacc.y main.h
These three programs can read Small-C source code, return tokens and build a parse tree together.
####tree.c
This program is used to print the parse tree that has been built. 
####IR.c
This program can translate the parse tree into LLVM codes.

##How to use it:
There is a Makefile in this project. So you can just make it and run.

./scc "your input source file" "your output source file"

####You can use the testcases to test this program.