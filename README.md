# CS152Lab-Group14
## SmortLanguage-S Language Specifications
This experimental programming language is called SmortLanguage-S. The extension for the program written in the this defined language is .smort (e.g., hello.smort). The name of the compiler for SmortLanguage-S is SMORT-COMPILER.

The SmortLanguage-S language provides the following program features:
  1. Integer scalar variables
  2. One-dimensional arrays of integers
  3. Assignment statements
  4. While and Do-While loops
  5. Continue statement
  6. Break statement
  7. If-then-else statements
  8. Read and write statements
  9. Commments
  10. Functions

Examples of the above listed features are in the table below:

| Language Feature | Code Example |
| --- | --- |
| Integer Scalar Variables | int a;<br>int b;|
| One-Dimensional Arrays of Integers | arr[1,2,3,4,5,6,7,8,9]; |
| Assignment Statements | int a = 5;<br>int b = 3;<br>int c = [4,5,6,4];|
| Arithmetic Operators (e.g., "+", "-", "*", "/") | a = x + y;<br>b = x - y;<br>c = x * y;<br>d = x/y; |
| Comparison Operators (e.g., “<”, “==”, “>”, “!=”) | a == y;<br>a < y;<br>a > y;<br>a != y; |
| While Loops | while (x < 100 &&) {<br>//code<br>} |
| If-then-else statements | if x < 4 {<br> //statement<br>}<br><br>elif {<br>  //statement<br>}<br><br>else {<br> //statement<br>} |
| Read and Write Statements | read(x)<br>write(y)<br> |
| Comments | // this is a comment<br><br>/* <br>and this is a comment block<br> */ |
| Functions (that can take multiple scalar arguments and return a single scalar result) | func int sqrt(int x) {<br><br>} |

Here are some additional details about this language:
  - A comment is initiated by "//" and extends to the end of the current line. A comment can also be a block and is created by initiating it with " /* " and ends until " */ " is encountered.
  - A vaild identifier in SmortLanguage-S must begin with a letter, followed by any number of letters, numbers, or underscores. The identifies must contains no whitespaces and must end in either a letter or a number.
  - SmortLanguage-S is case sensitive. 
  - A whitespace in SmortLanguage-S occurs when a blank space, tab, or newline is encountered. 

Table for the symbols in our language and their token name:
|  Symbol in Language 	|  Token Name 	|
|---	|---	|
| integer number (e.g., "0", "12", "1719")  	| NUMBER XXXX [where XXXX is the number itself]  	|
| +  	| PLUS  	|
| -  	| MINUS  	|
| * 	| MULT  	|
| /  	| DIV  	|
| (  	| L_PAREN  	|
| )  	| R_PAREN  	|
| =  	| EQUAL  	|
| <  	| LESS  	|
| >  	| GREATER  	|
| !  	| NOT  	|
| {  	| L_BRACE  	|
| }  	| R_BRACE  	|
| ;  	| SEMICOLON  	|
| [  	| L_BRACK  	|
| ]  	| R_BRACK  	|
| if  	| IF  	|
| int  	| INTEGER  	|
| ,  	| COMMA  	|
| while  	| WHILE  	|
| whileo  	| WHILEO  	|
| break  	| BREAK  	|
| read  	| READ  	|
| write  	| WRITE  	|
| /  	| FORWARD_SLASH  	|
