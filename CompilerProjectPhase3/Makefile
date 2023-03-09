all:
	bison -v -d --file-prefix=y smort.y
	flex smort.lex
	# g++ -o lexer lex.yy.c -lfl
	g++ -o parser y.tab.c lex.yy.c -lfl