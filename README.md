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
| One-Dimensional Arrays of Integers | int a = arr[8]; |
| Assignment Statements | a = 5;<br>b = 3;<br>c = b;|
| Arithmetic Operators (e.g., "+", "-", "*", "/") | a = x + y;<br>b = x - y;<br>c = x * y;<br>d = x/y; |
| Comparison Operators (e.g., “<”, “==”, “>”, “!=”) | a == y;<br>a < y;<br>a > y;<br>a != y; |
| While Loops | while (x < 100 &&) {<br>//code<br>} |
| If-then-else statements | if (x < 4) {<br> //statement<br>}<br><br>elif (y > 2){<br>  //statement<br>}<br><br>else {<br> //statement<br>} |
| Read and Write Statements | read(x)<br>write(y)<br> |
| Comments | // this is a comment<br><br>/* <br>and this is a comment block<br> */ |
| Functions (that can take multiple scalar arguments and return a single scalar result) | func int sqrt(int x) {<br> return x;<br>} |

Here are some additional details about this language:
  - A comment is initiated by "//" and extends to the end of the current line. A comment can also be a block and is created by initiating it with " /* " and ends until " */ " is encountered.
  - A vaild identifier in SmortLanguage-S must begin with a lowercase letter, followed by any number of upper or lowercase letters, numbers, or underscores. The identifier must contains no whitespaces and must end in either a lower or uppercase letter or a number.
  - SmortLanguage-S is case sensitive. 
  - A whitespace in SmortLanguage-S occurs when a blank space, tab, or newline is encountered. 

Table for the symbols in our language and their token name:
|  Symbol in Language 	|  Token Name 	|
|---	|---	|
| integer number (e.g., "0", "12", "1719")  	| NUMBER XXXX [where XXXX is the number itself]  	|
| identifiers (e.g, "a", "val", "NUM_1")  	| IDENTIFIER XYZ [where XYZ is the name of an identifier]  	|
| +  	| PLUS  	|
| -  	| MINUS  	|
| * 	| MULT  	|
| /  	| DIV  	|
| (  	| L_PAREN  	|
| )  	| R_PAREN  	|
| =  	| EQUAL  	|
| <  	| LESS_THAN  	|
| >  	| GREATER_THAN  	|
| !  	| NOT  	|
| !=  	| NOT_EQUAL  	|
| >=  	| GTE  	|
| <=  	| LTE  	|
| ==  	| EQUAL_TO |
| &&  	| AND |
| \|\|  	| OR |
| {  	| L_BRACE  	|
| }  	| R_BRACE  	|
| ;  	| SEMICOLON  	|
| ,  	| COMMA  	|
| [  	| L_BRACK  	|
| ]  	| R_BRACK  	|
| if  	| IF  	|
| else  	| ELSE  	|
| elif  	| ELIF  	|
| int  	| INTEGER  	|
| while  	| WHILE  	|
| whileo  	| WHILEO  	|
| break  	| BREAK  	|
| read  	| READ  	|
| write  	| WRITE  	|
| func  	| FUNCTION  |
| return  	| RETURN  	|
| main  	| MAIN  	|

