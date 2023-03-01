%{
  #include <stdio.h>
  extern FILE* yyin;
%}

%start prog_start
%token NUMBER PLUS MINUS MULT DIV L_PAREN R_PAREN EQUAL LESS_THAN GREATER_THAN NOT NOT_EQUAL GTE LTE EQUAL_TO AND OR TRUE FALSE L_BRACE R_BRACE SEMICOLON COMMA L_BRACK R_BRACK IF ELSE ELIF
%token INTEGER WHILE WHILEO BREAK READ WRITE FUNCTION RETURN ARRAY IDENTIFIER MAIN


%%

prog_start:functions main {printf("prog_start -> functions main\n");}
          ;

functions: %empty {printf("functions -> empty\n");}
         |function functions {printf("functions -> function functions\n");}
         ;

function: FUNCTION INTEGER IDENTIFIER L_PAREN arguments R_PAREN L_BRACE statements RETURN expression SEMICOLON R_BRACE
            {printf("function -> FUNCTION INTEGER IDENTIFIER L_PAREN arguments R_PAREN L_BRACE statements RETURN returns SEMICOLON R_BRACE\n");}
          ;

arguments: argument {printf("arguments -> argument\n");}
         |argument COMMA arguments {printf("arguents -> argument COMMA arguments\n");}
         ;

argument:%empty {printf("argument -> empty\n");}
        |INTEGER IDENTIFIER {printf("argument -> INTEGER IDENTIFIER\n");}
        ;

main:MAIN L_BRACE statements R_BRACE {printf("main -> MAIN L_BRACE statements R_BRACE\n");}
    ;

statements:%empty {printf("statements -> empty\n");}
          |statement statements {printf("statemetns -> statement statements\n");}
          ;

statement:variable_declaration SEMICOLON{printf("statement -> variable_declaration SEMICOLON\n");}
         |read SEMICOLON {printf("statement -> read SEMICOLON\n");}
         |write SEMICOLON {printf("statement -> write SEMICOLON\n");}
         |WHILE L_PAREN conditions R_PAREN L_BRACE statements R_BRACE {printf("statement WHILE L_PAREN conditions R_PAREN L_BRACE statements R_BRACE\n");}
         |IF L_PAREN conditions R_PAREN L_BRACE statements R_BRACE branch {printf("statement -> IF L_PAREN conditions R_PAREN L_BRACE statements R_BRACE branch\n");}
         |WHILEO L_BRACE statements R_BRACE WHILE L_PAREN conditions R_PAREN {printf("statement -> WHILEO L_BRACE statements R_BRACE WHILE L_PAREN conditions R_PAREN\n");}
         |ARRAY L_BRACK array_terms R_BRACK initialization SEMICOLON {printf("statement -> ARRAY L_BRACK array_terms R_BRACK initialization SEMICOLON\n");}
         ;

branch: %empty {printf("branch -> empty\n");}
      |ELIF L_PAREN conditions R_PAREN L_BRACE statements R_BRACE branch {printf("branch -> ELIF L_PAREN conditions R_PAREN L_BRACE statements R_BRACE branch\n");}
      |ELSE L_BRACE statements R_BRACE {printf("branch -> ELSE L_BRACE statements R_BRACE\n");}
      ;

variable_declaration: prefix IDENTIFIER initialization {printf("variable_declaration -> prefix IDENTIFIER initialization\n");}
                    ;

prefix: %empty {printf("prefix -> empty\n");}
      |INTEGER {printf("prefix -> INTEGER\n");}
      ;

initialization:%empty {printf("initialization -> empty\n");}
              |EQUAL expression {printf("initialization -> EQUAL expression\n");}
              ;

read:READ L_PAREN IDENTIFIER R_PAREN {printf("read -> READ L_PAREN IDENTIFIER R_PAREN\n");}
    ;

write:WRITE L_PAREN expression R_PAREN {printf("write -> WRITE L_PAREN expression R_PAREN\n");}
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

term: sign NUMBER {printf("term -> NUMBER\n");}
    |IDENTIFIER {printf("term -> IDENTIFIER\n");}
    |L_PAREN expression R_PAREN {printf("term -> L_PAREN expression R_PAREN\n");}
    |ARRAY L_BRACK NUMBER R_BRACK {printf("term -> ARRAY L_BRACK NUMBER R_BRACK\n");}
    |IDENTIFIER L_PAREN args R_PAREN {printf("term -> IDENTIFIER L_PAREN args R_PAREN\n");}
    ;

args:%empty {printf("args -> empty\n");}
    |mlt_args {printf("args -> mlt_args\n");}
    ;

mlt_args:expression {printf("mlt_args -> expression\n");}
        |expression COMMA mlt_args {printf("mlt_args -> expression COMMA mlt_args\n");}
        ;

sign: %empty {printf("sign -> empty\n");}
    |MINUS {printf("sign -> MINUS\n");}
    ;

conditions: condition {printf("conditions -> condition\n");}
          |condition AND conditions {printf("conditions -> condition AND conditions\n");}
          |condition OR conditions {printf("conditions -> condition OR conditions\n");}
          ;

condition: bool_statement {printf("condition -> bool_statement\n");}
         ;

bool_statement: term bool_operation term {printf("bool_statement -> term bool_operation term\n");}
              |TRUE {printf("bool_statement -> TRUE\n");}
              |FALSE {printf("bool_statement -> FALSE\n");}
              ;

bool_operation: GREATER_THAN {printf("bool_operation -> GREATER_THAN\n");}
              |LESS_THAN {printf("bool_operation -> LESS_THAN\n");}
              |GTE {printf("bool_operation -> GTE\n");}
              |LTE {printf("bool_operation -> LTE\n");}
              |EQUAL_TO {printf("bool_opertaion -> EQUAL_TO\n");}
              |NOT_EQUAL {printf("bool_operation -> NOT_EQUAL\n");}
              ;

array_terms: NUMBER {printf("array_terms -> NUMBER\n");}
           | NUMBER COMMA array_terms {printf("array_terms -> NUMBER COMMA array_terms\n");}
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
