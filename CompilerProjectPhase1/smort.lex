%{
#include <stdio.h>
%}

NUMBER [0-9]
IDENTIFIER [a-z][a-z0-9]*

%%

{NUMBER}+ {printf("NUMBER %s\n", yytext);}
"+"      {printf("PLUS\n");}
"-"      {printf("MINUS\n");}
"*"      {printf("MULT\n");}
"/"      {printf("DIV\n");}
"("      {printf("L_PAREN\n");}
")"      {printf("R_PAREN\n");}
"="      {printf("EQUAL\n");}
"<"      {printf("LESS_THAN\n");}
">"      {printf("GREATER_THAN\n");}
"!"      {printf("NOT\n");}
"!="     {printf("NOT_EQUAL\n");}
">="     {printf("GTE\n");}
"<="     {printf("LTE\n");}
"=="     {printf("EQUAL_TO\n");}
"&&"     {printf("AND\n");}
"||"     {printf("OR\n");}
"//"     {printf("LINE_COMMENT\n");}
"/*"     {printf("CBLOCK_OPEN\n");}
"*/"     {printf("CBLOCK_CLOSE\n");}
"{"      {printf("L_BRACE\n");}
"}"      {printf("R_BRACE\n");}
";"      {printf("SEMICOLON\n");}
","      {printf("COMMA\n");}
"["      {printf("L_BRACK\n");}
"]"      {printf("R_BRACK\n");}
if       {printf("IF\n");}
else     {printf("ELSE\n");}
elif     {printf("ELIF\n");}
int      {printf("INTEGER\n");}
while    {printf("WHILE\n");}
whileo   {printf("WHILEO\n");}
break    {printf("BREAK\n");}
read     {printf("READ\n");}
write    {printf("WRITE\n");}
func     {printf("FUNCTION\n");}
return   {printf("RETURN\n");}
{IDENTIFIER}  {printf("IDENTIFIER %s\n", yytext);}
" "|"\n"           {}
.                 {printf("Invalid input: %s\n", yytext);return;}



%%

main(int argc, char* argv[])
{
    yyin = fopen(argv[1], "r");
    yylex();
    fclose(yyin);
}
