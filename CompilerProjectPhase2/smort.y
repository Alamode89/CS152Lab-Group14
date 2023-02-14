%{
  #include <stdio.h>
  extern FILE* yyin;
%}

%start prog_start
%token NUMBER PLUS MINUS MULT DIV L_PAREN R_PAREN EQUAL LESS_THAN GREATER_THAN NOT NOT_EQUAL GTE LTE EQUAL_TO AND OR L_BRACE R_BRACE SEMICOLON COMMA L_BRACK R_BRACK IF ELSE ELIF
%token INTEGER WHILE WHILEO BREAK READ WRITE FUNCTION RETURN ARRAY IDENTIFIER


%%

prog_start: %empty  {printf("prog_start -> epsilon\n");}
          |variable_declaration  {printf("prog_start -> variable_declaration\n");}
          ;

variable_declaration: INTEGER IDENTIFIER initialization SEMICOLON {printf("variable_declaration -> INTEGER IDENTIFIER initialization SEMICOLON\n");}
                    ;

initialization:%empty {printf("initialization -> empty\n");}
              |EQUAL r_of_equals {printf("initialization -> EQUAL r_of_equals\n");}
              ;

r_of_equals: expression {printf("r_of_equals -> expression\n");}
           |IDENTIFIER r_of_identifier {printf("r_of_equals -> IDENTIFIER r_of_identifier\n");}
           ;

r_of_identifier: %empty {printf("r_of_identifier -> empty\n");}
               |EQUAL r_of_equals {printf("r_of_identifier -> EQUAL r_of_equals\n");}
               ;
expression: expression addop multerm {printf("expression -> expression addop multerm\n");}
          |multerm {printf("expression -> multerm\n");}
          ;

addop: PLUS {printf("addop -> PLUS\n");}
     |MINUS {printf("addop -> MINUS\n");}
     ;

multerm: multerm mulop term {printf("multerm -> multerm mulop term\n");}
       |term {printf("multerm -> term\n");}
       ;

mulop: MULT {printf("mulop -> MULT\n");} 
     |DIV {printf("mulop -> DIV\n");}
     ;

term: NUMBER {printf("term -> NUMBER\n");}
    |L_PAREN expression R_PAREN {printf("term -> R_PAREN expression L_PAREN\n");}
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
