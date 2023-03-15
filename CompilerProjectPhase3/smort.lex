%option noyywrap

%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
#include <string.h>
//#define YY_DECL int yylex(void)

int row = 1;
int col = 1;

extern char *identToken;
extern int numberToken;

%}

NUMBER [0-9]
IDENTIFIER [a-z]("_"*?[a-zA-Z0-9])*
LINE_COMMENT "\/\/".*"\n"

%%

"+"                 {col++;return PLUS;}
"-"                 {col++;return MINUS;}
"*"                 {col++;return MULT;}
"/"                 {col++;return DIV;}
"%"                 {col++;return MOD;}
"("                 {col++;return L_PAREN;}
")"                 {col++;return R_PAREN;}
"="                 {col++;return EQUAL;}
"<"                 {col++;return LESS_THAN;}
">"                 {col++;return GREATER_THAN;}
"!"                 {col++;return NOT;}
"!="                {col+=2;return NOT_EQUAL;}
">="                {col+=2;return GTE;}
"<="                {col+=2;return LTE;}
"=="                {col+=2;return EQUAL_TO;}
"&&"                {col+=2;return AND;}
"||"                {col+=2;return OR;}
"{"                 {col++;return L_BRACE;}
"}"                 {col++;return R_BRACE;}
";"                 {col++;return SEMICOLON;}
","                 {col++;return COMMA;}
"["                 {col++;return L_BRACK;}
"]"                 {col++;return R_BRACK;}
if                  {col+=2;return IF;}
else                {col+=4;return ELSE;}
elif                {col+=4;return ELIF;}
int                 {col+=3;return INTEGER;}
while               {col+=5;return WHILE;}
whileo              {col+=6;return WHILEO;}
break               {col+=5;return BREAK;}
read                {col+=4;return READ;}
write               {col+=5;return WRITE;}
func                {col+=4;return FUNCTION;}
return              {col+= 6;return RETURN;}
arr                 {col+=3;return ARRAY;}
main                {col+=4;return MAIN;}
{NUMBER}+           {
    col += yyleng;
    char * token = new char[yyleng];
    strcpy(token, yytext);
    yylval.op_val = token;
    numberToken = atoi(yytext);
    return NUMBER;
}
{IDENTIFIER}     {
    col += yyleng;
    char * token = new char[yyleng];
    strcpy(token, yytext);
    yylval.op_val = token;
    identToken = yytext;
    return IDENTIFIER;
}

TRUE                {col+=4;return TRUE;}
FALSE               {col+=5;return FALSE;}
" "                 {col++;}
"\t"                {col+=2;}
"\n"                {row++;col = 1;}
{LINE_COMMENT}      {}
"/*"(.|\n)*"*/"     {}
[0-9]{IDENTIFIER}   {printf("Invalid Identifier: cannot start with a number\n");col+=yyleng+1;}
"_"{IDENTIFIER}     {printf("Invalid Identifier: cannot start with an underscore\n");col+=yyleng+1;}
[A-Z]{IDENTIFIER}   {printf("Invalid Identifier: cannot start with a captital letter\n");col+=yyleng+1;}
{IDENTIFIER}"_"     {printf("Invalid Identifier: cannot end in an underscore\n");col+=yyleng+1;}
.                   {printf("Invalid input: %s at row %d col %d\n", yytext, row, col);}

%%

