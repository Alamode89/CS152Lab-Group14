%{
#include <stdio.h>

int intAmnt = 0;
int opsAmnt = 0;
int parenAmnt = 0;
int equalAmnt = 0;
%}

DIGIT [0-9]
ALPHA [a-zA-Z]

%%

{DIGIT}+ {intAmnt++;printf("DIGIT %s\n", yytext);}
{ALPHA}+ {printf("STRING %s\n", yytext);}
"+"      {opsAmnt++;printf("PLUS\n");}
"-"      {opsAmnt++;printf("MINUS\n");}
"*"      {opsAmnt++;printf("MULT\n");}
"/"      {opsAmnt++;printf("DIV\n");}
"("      {parenAmnt++;printf("L_PAREN\n");}
")"      {parenAmnt++;printf("R_PAREN\n");}
"="      {equalAmnt++;printf("EQUAL\n");}
" "	     {}
.  		 {printf("Invalid input: %s\n",yytext); return;}



%%

main(int argc, char* argv[]) {
	yyin = fopen(argv[1], "r");
	yylex();
	printf("Number of total integers: %d\n", intAmnt);
	printf("Number of total operators: %d\n", opsAmnt);
	printf("Number of total parentheses: %d\n", parenAmnt);
	printf("Number of total equal signs: %d\n", equalAmnt);
	fclose(yyin);
}
