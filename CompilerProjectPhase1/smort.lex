%{
#include <stdio.h>
int row = 1;
int col = 1;
%}

NUMBER [0-9]
IDENTIFIER [a-z]("_"*?[a-zA-Z0-9])*
LINE_COMMENT "\/\/".*"\n"

%%

{NUMBER}+           {printf("NUMBER %s\n", yytext);col += yyleng;}
"+"                 {printf("PLUS\n");col++;}
"-"                 {printf("MINUS\n");col++;}
"*"                 {printf("MULT\n");col++;}
"/"                 {printf("DIV\n");col++;}
"("                 {printf("L_PAREN\n");col++;}
")"                 {printf("R_PAREN\n");col++;}
"="                 {printf("EQUAL\n");col++;}
"<"                 {printf("LESS_THAN\n");col++;}
">"                 {printf("GREATER_THAN\n");col++;}
"!"                 {printf("NOT\n");col++;}
"!="                {printf("NOT_EQUAL\n");col+=2;}
">="                {printf("GTE\n");col+=2;}
"<="                {printf("LTE\n");col+=2;}
"=="                {printf("EQUAL_TO\n");col+=2;}
"&&"                {printf("AND\n");col+=2;}
"||"                {printf("OR\n");col+=2;}
"{"                 {printf("L_BRACE\n");col++;}
"}"                 {printf("R_BRACE\n");col++;}
";"                 {printf("SEMICOLON\n");col++;}
","                 {printf("COMMA\n");col++;}
"["                 {printf("L_BRACK\n");col++;}
"]"                 {printf("R_BRACK\n");col++;}
if                  {printf("IF\n");col+=2;}
else                {printf("ELSE\n");col+=4;}
elif                {printf("ELIF\n");col+=4;}
int                 {printf("INTEGER\n");col+=3;}
while               {printf("WHILE\n");col+=5;}
whileo              {printf("WHILEO\n");col+=6;}
break               {printf("BREAK\n");col+=5;}
read                {printf("READ\n");col+=4;}
write               {printf("WRITE\n");col+=5;}
func                {printf("FUNCTION\n");col+=4;}
return              {printf("RETURN\n");col+= 6;}
arr                 {printf("ARRAY\n");col+=3;}
{IDENTIFIER}        {printf("IDENTIFIER %s\n", yytext);col += yyleng;}
" "                 {col++;}
"\t"                {col+=2;}
"\n"                {row++;col = 1;}
{LINE_COMMENT}      {}
"/*"(.|\n)*"*/"     {}
[0-9]{IDENTIFIER}   {printf("Invalid Identifier: cannot start with a number\n");col+=yyleng+1;}
"_"{IDENTIFIER}     {printf("Invalid Identifier: cannot start with an underscore\n");col+=yyleng+1;}
[A-Z]{IDENTIFIER}   {printf("Invalid Identifier: cannot start with a captital letter\n");col+=yyleng+1;}
{IDENTIFIER}"_"     {printf("Invalid Identifier: cannot end in an underscore\n");col+=yyleng+1;}
.                   {printf("Invalid input: %s at row %d col %d\n", yytext, row, col);return;}

%%

main(int argc, char* argv[])
{
    yyin = fopen(argv[1], "r");
    yylex();
    fclose(yyin);
}
