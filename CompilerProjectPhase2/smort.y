%{
  #include <stdio.h>
  extern FILE* yyin;
%}

%start prog_start
%token NUMBER PLUS MINUS MULT DIV L_PAREN R_PAREN EQUAL LESS_THAN GREATER_THAN NOT NOT_EQUAL GTE LTE EQUAL_TO AND OR TRUE FALSE L_BRACE R_BRACE SEMICOLON COMMA L_BRACK R_BRACK IF ELSE ELIF
%token INTEGER WHILE WHILEO BREAK READ WRITE FUNCTION RETURN ARRAY IDENTIFIER


%%

prog_start:functions main {printf("prog_start -> functions main\n");}
          ;

functions:%empty {printf("functions -> empty\n");}
         |function functions {printf("functions -> function functions\n");}
         ;

function: FUNCTION INTEGER IDENTIFIER L_PAREN arguments R_PAREN L_BRACE statements RETURN returns SEMICOLON R_BRACE
          {printf("function -> FUNCTION INTEGER IDENTIFIER L_PAREN arguments R_PAREN L_BRACE statements RETURN returns SEMICOLON R_BRACE\n");}
        ;

returns: return returns {printf("returns -> return returns\n");}
        |return addop returns {printf("returns -> return addop returns\n");}
        |return mulop returns {printf("returns -> return mulop returns\n");}
        |%empty {printf("returns -> empty\n");}
        ;

return:term {printf("return -> term\n");}
      |function_call {printf("return -> function_call\n");}
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
          |statement statements {printf("statements -> statement statements\n");}
          ;

statement:variable_declaration SEMICOLON {printf("statement -> variable_declaration SEMICOLON\n");}
         |read SEMICOLON{printf("statement -> read SEMICOLON\n");}
         |write SEMICOLON {printf("statement -> write SEMICOLON\n");}
         |WHILE condition L_BRACE statements R_BRACE {printf("statement -> WHILE condition L_BRACE statements R_BRACE\n");}
         |IF condition L_BRACE statements R_BRACE branch {printf("statement -> IF condition L_BRACE statements R_BRACE branch\n");}
         |WHILEO L_BRACE statements R_BRACE WHILE condition {printf("statement -> WHILEO conditions L_BRACE statements R_BRACE WHILE condition\n");}
         |ARRAY L_BRACK terms R_BRACK initialization {printf("statement -> ARRAY L_BRACK terms R_BRACK initialization\n");}
         ;

numbers: NUMBER {printf("numbers -> NUMBER\n");}
       |NUMBER SEMICOLON numbers {printf("numbers -> NUMBER SEMICOLON numbers\n");}
       ;

branch: %empty {printf("branch -> empty\n");}
        |ELIF condition L_BRACE statements R_BRACE branch {printf("branch -> ELIF condition L_BRACE statements R_BRACE\n");}
        |ELSE L_BRACE statements R_BRACE {printf("branch -> ELSE L_BRACE statements R_BRACE\n");}
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
           |ARRAY L_BRACK NUMBER R_BRACK {printf("r_of_equals -> ARRAY L_BRACK NUMBER r_BRACK\n");}
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

write:WRITE L_PAREN identifier_or_array R_PAREN {printf("write -> WRITE L_PAREN identifier_or_array R_PAREN\n");}
     ;

identifier_or_array:IDENTIFIER {printf("identifier_or_array -> IDENTIFIER\n");}
                   |ARRAY L_BRACK terms R_BRACK {printf("idenetifier_or_array -> ARRAY L_BRACK terms R_BRACK\n");}
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

terms: %empty {printf("terms -> empty\n");}
     |term {printf("terms -> term\n");}
     |term COMMA {printf("terms -> term\n");}
     ;

term: sign NUMBER {printf("term -> NUMBER\n");}
    |IDENTIFIER {printf("term -> IDENTIFIER\n");}
    |L_PAREN expression R_PAREN {printf("term -> L_PAREN expression R_PAREN\n");}
    ;

sign: %empty
    |MINUS
    ;

conditions: condition conditions {printf("conditions -> condition conditions\n");}
          |%empty {printf("conditions -> empty\n");}
          ;
          
condition: L_PAREN bool_statement R_PAREN {printf("condition -> L_PAREN bool_statement R_PAREN\n");};

bool_statement: term bool_operation term {printf("bool_statement -> term bool_operation term\n");}
              | TRUE {printf("bool_statement -> TRUE\n");}
              | FALSE {printf("bool_statement -> FALSE\n");}
              ;

bool_operation: GREATER_THAN {printf("bool_operation -> GREATER_THAN\n");}
              |LESS_THAN {printf("bool_operation -> LESS_THAN\n");}
              |GTE {printf("bool_operation -> GTE\n");}
              |LTE {printf("bool_operation -> LTE\n");}
              |EQUAL_TO {printf("bool_operation -> EQUAL_TO\n");}
              |NOT_EQUAL {printf("bool_operation -> NOT_EQUAL\n");}
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
