%{
  #include <stdio.h>
  extern FILE* yyin;
%}

%start prog_start
%token NUMBER PLUS MINUS MULT DIV L_PAREN R_PAREN EQUAL LESS_THAN GREATER_THAN NOT NOT_EQUAL GTE LTE EQUAL_TO AND OR TRUE FALSE L_BRACE R_BRACE SEMICOLON COMMA L_BRACK R_BRACK IF ELSE ELIF
%token INTEGER WHILE WHILEO BREAK READ WRITE FUNCTION RETURN ARRAY IDENTIFIER MAIN


%%

prog_start:functions main
          ;

functions: %empty
         |function functions
         ;

function: FUNCTION INTEGER IDENTIFIER L_PAREN arguments R_PAREN L_BRACE statements RETURN expression SEMICOLON R_BRACE
          ;

arguments: argument
         |argument COMMA arguments 
         ;

argument:%empty
        |INTEGER IDENTIFIER
        ;

main:MAIN L_BRACE statements R_BRACE 
    ;

statements:%empty
          |statement statements
          ;

statement:variable_declaration SEMICOLON
         |read SEMICOLON 
         |write SEMICOLON 
         |WHILE L_PAREN conditions R_PAREN L_BRACE statements R_BRACE 
         |IF L_PAREN conditions R_PAREN L_BRACE statements R_BRACE branch 
         |WHILEO L_BRACE statements R_BRACE WHILE L_PAREN conditions R_PAREN
         |ARRAY L_BRACK array_terms R_BRACK initialization SEMICOLON
         ;

branch: %empty
      |ELIF L_PAREN conditions R_PAREN L_BRACE statements R_BRACE branch 
      |ELSE L_BRACE statements R_BRACE
      ;

variable_declaration: prefix IDENTIFIER initialization
                    ;

prefix: %empty
      |INTEGER
      ;

initialization:%empty
              |EQUAL expression 
              ;

read:READ L_PAREN IDENTIFIER R_PAREN 
    ;

write:WRITE L_PAREN expression R_PAREN
     ;

expression: expression addop multerm 
          |multerm 
          ;

addop: PLUS 
     |MINUS 
     ;

multerm: multerm mulop term 
       |term 
       ;

mulop: MULT 
     |DIV 
     ;

term: sign NUMBER 
    |IDENTIFIER 
    |L_PAREN expression R_PAREN 
    |ARRAY L_BRACK NUMBER R_BRACK 
    |IDENTIFIER L_PAREN args R_PAREN
    ;

args:%empty 
    |mlt_args 
    ;

mlt_args:expression 
        |expression COMMA mlt_args 
        ;

sign: %empty 
    |MINUS 
    ;

conditions: condition 
          |condition AND conditions 
          |condition OR conditions 
          ;

condition: bool_statement 
         ;

bool_statement: term bool_operation term 
              |TRUE 
              |FALSE 
              ;

bool_operation: GREATER_THAN 
              |LESS_THAN 
              |GTE 
              |LTE 
              |EQUAL_TO 
              |NOT_EQUAL 
              ;

array_terms: NUMBER 
           | NUMBER COMMA array_terms
           ;

%%

void main (int argc, char** argv)
{
  if(argc >= 2)
  {
    yyin = fopen(argv[1], "r");
    if(yyin == NULL)
      yyin = stdin;
  }
  else
  {
    yyin = stdin;
  }
  yyparse();
}
int yyerror()
{
  fprintf(stderr, "INVALID SYNTAX\n");
}
