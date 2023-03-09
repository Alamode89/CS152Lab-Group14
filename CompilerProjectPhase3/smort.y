%{
  #include "CodeNode.h"
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include <sstream>
  #include <vector>
  #include <string>
  #include "y.tab.h"
  extern FILE* yyin;
  //Below code is from practice lab 3
  extern int yylex(void); //new line
  void yyerror(const char *msg); //new line
  extern int row; //get the row variable from smort.lex
  extern int col; //get the col variable from smort.lex

char *identToken;
int numberToken;
int count_names = 0;


enum Type {Integer, Array};
struct Symbol{
  std::string name;
  Type type;
};
struct Function {
  std::string name;
  std::vector<Symbol> declarations;
};

std::vector <Function> symbol_table;


Function *get_function(){
  int last = symbol_table.size()-1;
  return &symbol_table[last];
}

bool find(std::string &value){
  Function *f = get_function();
  for(int i = 0; i < f->declarations.size(); i++) {
    Symbol *s = &f->declarations[i];
    if(s->name == value){
      return true;
    }
  }
  return false;
}

void add_function_to_symbol_table(std::string &value) {
  Function f;
  f.name = value;
  symbol_table.push_back(f);
}

void add_variable_to_symbol_table(std::string &value, Type t) {
  Symbol s;
  s.name = value;
  s.type = t;
  Function *f = get_function();
  f->declarations.push_back(s);
}

void print_symbol_table(void){
  printf("symbol table:\n");
  printf("--------------------\n");
  for(int i =0; i < symbol_table.size();i++) {
    printf("function: %s\n", symbol_table[i].name.c_str());
    for(int j = 0; j <symbol_table[i].declarations.size();j++) {
      printf("  locals: %s\n", symbol_table[i].declarations[j].name.c_str());
    }
  }
  printf("--------------------\n");
}

%}

%union{
  char *op_val;
  int int_val;

  struct CodeNode *node;

  struct S{
    char *code;
  } statement;

  struct E{
    char *place;
    char *code;
  } expression;
}

%type <node> functions main statements term expression multerm initialization variable_declaration statement sign var_assignment
%type <node> input_output read_write array_assignment array_declaration array_terms

%start prog_start
%token PLUS MINUS MULT DIV L_PAREN R_PAREN EQUAL LESS_THAN GREATER_THAN NOT NOT_EQUAL GTE LTE EQUAL_TO AND OR TRUE FALSE L_BRACE R_BRACE SEMICOLON COMMA L_BRACK R_BRACK IF ELSE ELIF
%token <op_val>NUMBER IDENTIFIER
%token INTEGER WHILE WHILEO BREAK READ WRITE FUNCTION RETURN ARRAY MAIN

%%

prog_start: functions 
{
  std::string main_name = "main";
  add_function_to_symbol_table(main_name);
} main {
  printf("%s", $3->code.c_str());
  printf("%s\n", "endfunc");
}
;

functions: %empty{
          
         /* CodeNode *node = new CodeNode;
          $$ = node;*/
}
         |function functions{

         /* CodeNode *code_node1 = $1;
          CodeNode *code_node2 = $2;
          CodeNode *node = new CodeNode;
          node->code = code_node1->code + code_node2->code;
          $$ = node;*/
}
         ;
//{add_function_to_symbol_table($3)}
function: FUNCTION INTEGER IDENTIFIER L_PAREN arguments R_PAREN L_BRACE statements RETURN expression SEMICOLON R_BRACE {
        
          /*CodeNode *node = new CodeNode;
          std::string func_name = $3;
          node->code = "";
          //add the "func func_name
          node->code +=  std::string("func ") + func_name + std::string("\n");
          
          //add the argument code
          CodeNode *arguments = $5;
          node->code += arguments->code;

          //add the local declarations/statements
          CodeNode *statements = $8;
          node->code += statements->code;


    
          $$ = node;*/
}
          ;

arguments: argument
         |argument COMMA arguments 
         ;

argument:%empty
        |INTEGER IDENTIFIER
        ;
//leaves of the trees or anything to combine
main:MAIN L_BRACE statements R_BRACE 
  {
    printf("%s\n", "func main");
    CodeNode* node = new CodeNode;
    node->code = $3->code;
    delete $3;
    $$ = node;
  }
;

statements: %empty { CodeNode *node = new CodeNode(); node->code = ""; $$ = node;}
          |statement statements {
            CodeNode* node = new CodeNode;
            node->code = $1->code + $2->code;
            delete $1;
            delete $2;
            $$ = node;
          }
          ;

statement:variable_declaration
         |var_assignment
         |input_output
         |WHILE L_PAREN conditions R_PAREN L_BRACE statements R_BRACE 
         |IF L_PAREN conditions R_PAREN L_BRACE statements R_BRACE branch 
         |WHILEO L_BRACE statements R_BRACE WHILE L_PAREN conditions R_PAREN
         |array_declaration
         |array_assignment
         ;

array_declaration: INTEGER IDENTIFIER EQUAL ARRAY L_BRACK expression R_BRACK SEMICOLON {
  Type t = Integer;
  std::string arr_name = $2;
  add_variable_to_symbol_table(arr_name, t);
  std::string arr_size = $6->name;
  CodeNode* node = new CodeNode();
  node->code = std::string(".[] ") + arr_name + std::string(", ") + arr_size + std::string("\n");
  $$ = node;
}
;

array_assignment: IDENTIFIER L_BRACK expression R_BRACK EQUAL expression SEMICOLON {
  std::string arr_name = $1;
  //check if it exists
  CodeNode* node = new CodeNode();

}
;

branch: %empty
      |ELIF L_PAREN conditions R_PAREN L_BRACE statements R_BRACE branch 
      |ELSE L_BRACE statements R_BRACE
      ;

variable_declaration: INTEGER IDENTIFIER SEMICOLON
{
  Type t = Integer;
  std::string var_name = $2;
  add_variable_to_symbol_table(var_name, t);
  CodeNode* node = new CodeNode;
  node->code = std::string(". ") + var_name + std::string("\n");
  $$ = node;
  delete $2;
}
;

var_assignment: IDENTIFIER EQUAL expression SEMICOLON{
  std::string variable = $1;
  std::string value = $3->name;
  $$ = new CodeNode;
  $$->code = $3->code;
  $$->code += std::string("= ") + variable + std::string(", ") + value + std::string("\n");
  //$$ = node;
}
;
initialization: NUMBER 
;

input_output: read_write L_PAREN IDENTIFIER R_PAREN SEMICOLON {
  std::string variable = $3;
  $$ = new CodeNode();
  std::string rw = $1->name;
  $$->code = rw + std::string(" ") + variable + std::string("\n");
}

read_write: READ {
  $$ = new CodeNode();
  char e[] = ".<";
  $$->name = e;
}

|WRITE {
  $$ = new CodeNode();
  char e[] = ".>";
  $$->name = e;
}


expression: expression addop multerm 
          |multerm {
            CodeNode* node = new CodeNode;
            node->code = $1->code;
            node->name = $1->name;
            $$ = node;
           // delete $1;
          }
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

term: sign NUMBER {
    $$ = new CodeNode();
    $$->name = $2;
}
|IDENTIFIER {
    $$ = new CodeNode();
    $$->name = $1;
}
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

array_terms: term
           | NUMBER COMMA array_terms
           ;

%%

int main (int argc, char** argv) {
  yyin = stdin;

  do {
    yyparse();
  } while(!feof(yyin));
  return 0;
}

void yyerror(const char *msg) {
  printf("**  Line %d: %s\n", row, msg);
  exit(1);
}
