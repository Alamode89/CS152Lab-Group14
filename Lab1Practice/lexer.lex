%{
#include <stdio.h>
%}

DIGIT [0-9]
ALPHA [a-zA-Z]

%%

{DIGIT}+ {printf("DIGIT %s\n", yytext);}
{ALPHA}+ {printf("STRING %s\n", yytext);}
"+"      {printf("PLUS\n");}
"-"      {printf("MINUS\n");}
"*"      {printf("MULT\n");}
"/"      {printf("DIV\n");}
"("      {printf("L_PAREN\n");}
")"      {printf("R_PAREN\n");}
"="      {printf("EQUAL\n");}
.  		 {printf("Invalid input: %s\n",yytext); return;}



%%

main(void) {
	printf("INTEGER: %d\n", 12345);
	printf("STRING : %s\n", "[A String]");
	printf("Ctrl+D to quit\n");
	yylex();
}
