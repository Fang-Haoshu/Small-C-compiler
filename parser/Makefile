Parser:lex.yy.c y.tab.c main.h tree.c
	gcc lex.yy.c y.tab.c 
lex.yy.c:y.tab.h lex.l main.h
	flex lex.l
y.tab.c y.tab.h:yacc.y main.h
	yacc -d yacc.y
clean:
	rm -rf *.o y.tab.c lex.yy.c y.tab.h stderr a.out
