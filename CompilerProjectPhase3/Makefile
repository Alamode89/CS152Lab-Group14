all:
	flex smort.lex
	bison -v -d --file-prefix=y smort.y
	gcc -o lexer lex.yy.c -lfl
	g++ -o parser y.tab.c lex.yy.c -lfl