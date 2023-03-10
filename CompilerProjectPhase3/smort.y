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
struct Variable{
  std::string name;
  Type type;
};
struct Function {
  std::string name;
  std::vector<Variable> declarations;
};

std::vector <Function> symbol_table;

bool foundInVec(std::vector<Variable> vec, std::string& value) {
  for (int i = 0; i < vec.size(); i++) {
    if (vec.at(i).name == value) {
      return true;
    }
  }
  return false;
}

Function *get_function(){
  int final = symbol_table.size()-1;
  return &symbol_table[final];
}

bool find(const std::string &value){
  Function *f = get_function();
  for(int i = 0; i < f->declarations.size(); i++) {
    Variable *v = &f->declarations[i];
    if(v->name == value){
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
  Variable v;
  v.name = value;
  v.type = t;
  Function *f = get_function();
  f->declarations.push_back(v);
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

void checkVarDuplicate(const std::string val) {
  if (find(val)) {
    std::string msg = "Error: duplicate declaration of variable '" + val + "'";
    yyerror(msg.c_str());
  }
}

void checkFuncDef(const std::string val){
  for (int i = 0; i < symbol_table.size(); i++){
    if (symbol_table.at(i).name == val){
      return;
    }
  }
  std::string msg = "Error: function '" + val + "' undefined";
  yyerror(msg.c_str());
}

std::string temp_var_incrementer(){
   std::stringstream new_temp_var;
   new_temp_var << std::string("_temp") << count_names;
   ++count_names;
   return new_temp_var.str();
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

%type <node> functions function main statements term expression variable_declaration statement sign var_assignment
%type <node> input_output read_write array_assignment array_declaration operation arr_access arguments argument args mlt_args


%start prog_start
%token PLUS MINUS MULT DIV L_PAREN R_PAREN EQUAL LESS_THAN GREATER_THAN NOT NOT_EQUAL GTE LTE EQUAL_TO AND OR TRUE FALSE L_BRACE R_BRACE SEMICOLON COMMA L_BRACK R_BRACK IF ELSE ELIF
%token <op_val> NUMBER IDENTIFIER
%token INTEGER WHILE WHILEO BREAK READ WRITE FUNCTION RETURN ARRAY MAIN

%%


prog_start: functions 
{
  std::string main_name = "main";
  add_function_to_symbol_table(main_name);
  CodeNode *node = new CodeNode;
  node->code = $1->code;
  printf("%s", node->code.c_str());
} main {
  CodeNode *node = new CodeNode();
  node->code = $3->code;
  printf("%s", node->code.c_str());
}

;

functions: %empty{
          
          CodeNode *node = new CodeNode;
          $$ = node;
}
         |function functions{

          CodeNode *node1 = $1;
          CodeNode *node2 = $2;
          CodeNode *node = new CodeNode;
          node->code = node1->code + node2->code;
          $$ = node;
}
         ;
//{add_function_to_symbol_table($3)}
function: FUNCTION INTEGER IDENTIFIER L_PAREN arguments R_PAREN L_BRACE statements RETURN expression SEMICOLON R_BRACE {
        
         CodeNode *node = new CodeNode;
         std::string func_name = $3;
         node->code = "";
          //add the "func func_name
         node->code +=  std::string("func ") + func_name + std::string("\n");
         //printf("%s\n", node->code.c_str());
          //add the argument code
          CodeNode *arguments = $5;
          node->code += arguments->code;

          //add the local declarations/statements
          CodeNode *statements = $8;
          node->code += statements->code;

         //add the return statement
         CodeNode *returns = new CodeNode;
         std::string expression = $10->name;
         returns->code = std::string("ret ") + expression.c_str() + std::string("\n");
         node->code += returns->code;

         node->code += std::string("endfunc\n") + std::string("\n");
         $$ = node;
}
          ;

arguments: argument{
          
          CodeNode *node = $1;
          $$ = node;
}
         |argument COMMA arguments {
          CodeNode *node = $1;
          CodeNode *node2 = $3;
          node->code += node2->code;
          $$ = node;
}
         ;

argument:%empty{

         CodeNode *node = new CodeNode;
         $$ = node;
        }
        |INTEGER IDENTIFIER{
         CodeNode *node = new CodeNode;
         node->code = "";
         std::string id = $2;
         node->code += std::string(". ") + id + std::string("\n");
         $$ = node;
        }
        ;

main:MAIN L_BRACE statements R_BRACE 
  {
    //printf("%s\n", "func main");
    CodeNode* node = new CodeNode;
    node->code = "";
    node->code += std::string("func main\n");
    node->code += $3->code;
    //node->name = "";
    node->code += std::string("endfunc\n");
    //printf("%s\n", "endfunc");
    //$$ = node;
    //printf("%s", $3.code);
    // printf("%s", $3.place);
    //node->code = $3->code;
    //delete $3;
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
  $$ = new CodeNode();
  $$->code = std::string(".[] ") + arr_name + std::string(", ") + arr_size + std::string("\n");
}
;

array_assignment: IDENTIFIER L_BRACK term R_BRACK EQUAL expression SEMICOLON {
  std::string arr_name = $1;
  std::string arr_index = $3->name;
  std::string value = $6->name;
  //check if it exists need helper functions
  $$ = new CodeNode();
  $$->code = $6->code;
  $$->code += std::string("[]= ") + arr_name + std::string(", ") + arr_index + std::string(", ") + value + std::string("\n");
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
  checkVarDuplicate(var_name);
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

input_output: read_write L_PAREN expression R_PAREN SEMICOLON {
  std::string variable = $3->name;
  $$ = new CodeNode();
  std::string rw = $1->name;
  $$->code = $3->code;
  $$->code += rw + std::string(" ") + variable + std::string("\n");
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


expression: term operation expression {
  std::string last = $1->name;
  std::string first = $3->name;
  std::string temp = temp_var_incrementer();


  $$ = new CodeNode();
  $$->name = temp;
  $$->code += $1->code;
  $$->code += $3->code;
  $$->code += std::string(". ") + temp + std::string("\n");
  $$->code += std::string($2->name) + std::string(" ") + temp + std::string(", ") + last + std::string(", ") + first + std::string("\n");
}
|term
;

operation: PLUS {
  $$ = new CodeNode();
  char e[] = "+";
  $$->name = e;
}
|MINUS {
  $$ = new CodeNode();
  char e[] = "-";
  $$->name = e;
}
|MULT {
  $$ = new CodeNode();
  char e[] = "*";
  $$->name = e;
}
|DIV {
  $$ = new CodeNode();
  char e[] = "/";
  $$->name = e;
}
;


term: sign NUMBER {
    $$ = new CodeNode();
    $$->name = $2;
}
|IDENTIFIER {
    $$ = new CodeNode();
    $$->name = $1;
}
|arr_access
|L_PAREN expression R_PAREN 
|IDENTIFIER L_PAREN args R_PAREN {//*********Function Call
    CodeNode *node = new CodeNode;
    std::string name = $1;
    std::string temp = temp_var_incrementer();//temporary variable for the function call destination
    node->code += $3->code;//add paramaters to beginning of node 
    node->code += std::string(". ") + temp + std::string("\n");//next add the temporary variable declaration to the node
    node->code += std::string("call ") + name + std::string(", ") + temp + std::string("\n");//actual function call 
    node->name = temp;
    $$ = node;
    }
    ;

arr_access: IDENTIFIER L_BRACK term R_BRACK {
  std::string variable = $1;
  std::string index = $3->name;
  std::string temp = temp_var_incrementer();

  $$ = new CodeNode();
  $$->name = temp;
  $$->code = std::string(". ") + temp + std::string("\n");
 // printf("=[] %s, %s, %s\n", temp.c_str(), variable.c_str(), index.c_str());
  $$->code += std::string("=[] ") + temp + std::string(", ") + variable + std::string(", ") + index + std::string("\n");
}

args:%empty {
    CodeNode *node = new CodeNode;
    $$ = node;
}
    |mlt_args {
    CodeNode *node = $1; //new line added
    $$ = node; //new line added
    }
    ;

mlt_args:expression {
        CodeNode *node = new CodeNode; //new line added
        std::string param = $1->name; 
        node->code = "";
        node->code += std::string("param ") + param + std::string("\n");
        //printf("%s\n", node->code.c_str());
        $$ = node; //new line added*/
        }
        |expression COMMA mlt_args {
        CodeNode *node1 = new CodeNode;
        std::string param = $1->name;
        node1->code = "";
        node1->code += std::string("param ") + param + std::string("\n");
        CodeNode *node2 = $3;
        CodeNode *node = new CodeNode;
        node->code = node1->code + node2->code;
        $$ = node;
        }
        ;

sign: %empty{
      CodeNode *node = new CodeNode;
      $$ = node;
    }
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
}
