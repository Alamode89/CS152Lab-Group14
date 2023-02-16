%{
  #include <stdio.h>
  extern FILE* yyin;
%}

%start prog_start
%token NUMBER PLUS MINUS MULT DIV L_PAREN R_PAREN EQUAL LESS_THAN GREATER_THAN NOT NOT_EQUAL GTE LTE EQUAL_TO AND OR L_BRACE R_BRACE SEMICOLON COMMA L_BRACK R_BRACK IF ELSE ELIF
%token INTEGER WHILE WHILEO BREAK READ WRITE FUNCTION RETURN ARRAY IDENTIFIER


%%

prog_start:functions main {printf("prog_start -> functions main\n");}
          ;

functions:%empty {printf("functions -> empty\n");}
         |function functions {printf("functions -> function functions\n");}

function: FUNCTION INTEGER IDENTIFIER L_PAREN arguments R_PAREN L_BRACE statements RETURN expression SEMICOLON R_BRACE
          {printf("FUNCTION INTEGER IDENTIFIER L_PAREN arguments R_PAREN L_BRACE statements RETURN expression SEMICOLON R_BRACE\n");}
        ;

arguments:argument {printf("arguments -> argument\n");}
         |argument COMMA arguments {printf("arguments -> argument COMMA arguments\n");}
         ;

argument: %empty {printf("argument -> empty\n");}
        |INTEGER IDENTIFIER {printf("argument -> INTEGER IDENTIFIER\n");}
        ;

main:statements {printf("main -> statements\n");}
    ;

statements:%empty {printf("statements -> empty\n");}
          |statement SEMICOLON statements {printf("statements -> statement SEMICOLON statements\n");}
          ;

statement:variable_declaration {printf("statement -> variable_declaration\n");}
         |read {printf("statement -> read\n");}
         |write {printf("statement -> write\n");}
         ;

variable_declaration: prefix IDENTIFIER initialization {printf("variable_declaration -> prefix IDENTIFIER initialization\n");}
                    ;

prefix: %empty {printf("prefix -> empty\n");}
      |INTEGER {printf("prefix -> INTEGER\n");}
      ;

initialization:%empty {printf("initialization -> empty\n");}
              |EQUAL r_of_equals {printf("initialization -> EQUAL r_of_equals\n");}
              ;

r_of_equals: expression {printf("r_of_equals -> expression\n");}
           |function_call {printf("r_of_equals -> function_call\n");}
           ;

function_call:IDENTIFIER L_PAREN args R_PAREN {printf("function_call -> IDENTIFIER L_PAREN args R_PAREN\n");}
             ;

args: %empty {printf("args -> empty\n");}
    |IDENTIFIER mlt_args {printf("args -> IDENTIFIER mlt_args\n");}
    ;

mlt_args:%empty {printf("mlt_args -> empty\n");}
        |COMMA IDENTIFIER mlt_args {printf("mlt_args -> COMMA IDENTIFIER mlt_args\n");}
        ;

read:READ L_PAREN IDENTIFIER R_PAREN {printf("read -> READ L_PAREN IDENTIFIER R_PAREN\n");}
    ;

write:WRITE L_PAREN IDENTIFIER R_PAREN {printf("write -> WRITE L_PAREN IDENTIFIER R_PAREN\n");}
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
    |IDENTIFIER {printf("term -> IDENTIFIER\n");}
    |L_PAREN expression R_PAREN {printf("term -> L_PAREN expression R_PAREN\n");}
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
