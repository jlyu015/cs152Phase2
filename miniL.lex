   /* cs152-miniL phase1 */
   
%{   
   /* write your C code here for definitions of variables and including headers */
   int currLine = 1, currPos = 1;
%}

   /* some common rules */

LETTER   [a-zA-Z]
DIGIT    [0-9]
ID       {LETTER}(({LETTER}|{DIGIT}|"_")*({LETTER}|{DIGIT})+)*
ERROR_START_ID   ({DIGIT}|"_")({ID}|{DIGIT}|"_")*
ERROR_END_ID   {ID}"_"+
/* COMP     [==|<>|<|>|<=|>=] */

%%
   /* specific lexer rules in regex */

   /* RESERVED WORDS */
function          {printf("FUNCTION\n"); currPos += yyleng;}
beginparams	         {printf("BEGIN_PARAMS\n"); currPos += yyleng;}
endparams	         {printf("END_PARAMS\n"); currPos += yyleng;}
beginlocals	         {printf("BEGIN_LOCALS\n"); currPos += yyleng;}
endlocals         	{printf("END_LOCALS\n"); currPos += yyleng;}
beginbody	         {printf("BEGIN_BODY\n"); currPos += yyleng;}
endbody           	{printf("END_BODY\n"); currPos += yyleng;}
integer           	{printf("INTEGER\n"); currPos += yyleng;}
array	               {printf("ARRAY\n"); currPos += yyleng;}
enum	               {printf("ENUM\n"); currPos += yyleng;}        
of	                  {printf("OF\n"); currPos += yyleng;}
if	                  {printf("IF\n"); currPos += yyleng;}
then                	{printf("THEN\n"); currPos += yyleng;}
endif                {printf("ENDIF\n"); currPos += yyleng;}
else                 {printf("ELSE\n"); currPos += yyleng;}
for	               {printf("FOR\n"); currPos += yyleng;}
while               	{printf("WHILE\n"); currPos += yyleng;}
do	                  {printf("DO\n"); currPos += yyleng;}
beginloop	         {printf("BEGINLOOP\n"); currPos += yyleng;}
endloop	            {printf("ENDLOOP\n"); currPos += yyleng;}
continue	            {printf("CONTINUE\n"); currPos += yyleng;}
read                	{printf("READ\n"); currPos += yyleng;}
write                {printf("WRITE\n"); currPos += yyleng;}
and	               {printf("AND\n"); currPos += yyleng;}
or                	{printf("OR\n"); currPos += yyleng;}
not                	{printf("NOT\n"); currPos += yyleng;}
true                	{printf("TRUE\n"); currPos += yyleng;}
false                {printf("FALSE\n"); currPos += yyleng;}
return	            {printf("RETURN\n"); currPos += yyleng;}

         /*    ARITHMETIC OPERATORS    */
"-"                    {printf("SUB\n"); currPos += yyleng;}
"+"                  {printf("ADD\n"); currPos += yyleng;}
"*"                  {printf("MULT\n"); currPos += yyleng;}
"/"                  {printf("DIV\n"); currPos += yyleng;}
"%"                  {printf("MOD\n"); currPos += yyleng;}


         /*    COMPARISON OPERATORS    */
"=="                 {printf("EQ\n"); currPos += yyleng;}
"<>"	               {printf("NEQ\n"); currPos += yyleng;}
"<"	               {printf("LT\n"); currPos += yyleng;}
">"	               {printf("GT\n"); currPos += yyleng;}
"<="	               {printf("LTE\n"); currPos += yyleng;}
">="                 {printf("GTE\n"); currPos += yyleng;}


          /*    IDENTIFIERS AND NUMBERS    */
{ID}+                 {printf("IDENT %s\n", yytext); currPos += yyleng;}
{DIGIT}+             {printf("NUMBER %s\n", yytext); currPos += yyleng;}


         /*    OTHER SPECIAL SYMBOLS    */
";"	                  {printf("SEMICOLON\n"); currPos += yyleng;}
":"	                  {printf("COLON\n"); currPos += yyleng;}
","	                  {printf("COMMA\n"); currPos += yyleng;}
"("	                  {printf("L_PAREN\n"); currPos += yyleng;}
")"	                  {printf("R_PAREN\n"); currPos += yyleng;}
"["	                  {printf("L_SQUARE_BRACKET\n"); currPos += yyleng;}
"]"	                  {printf("R_SQUARE_BRACKET\n"); currPos += yyleng;}
":="	                  {printf("ASSIGN\n"); currPos += yyleng;}



[ \t]+         {/* ignores spaces */ currPos += yyleng;}
"\n"           {/* ignores newlines */ currLine++; currPos = 1;}
##.*         {/*ignores comments*/ currLine++; currPos = 1;}


         /*    ERROR CATCHES    */
{ERROR_START_ID}       { printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter\n", currLine, currPos-1, yytext); exit(0); }
{ERROR_END_ID}       { printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n", currLine, currPos-1, yytext); exit(0); }


.              {printf("Error at line %d, column %d: unrecognized symbol \"\%s\"\n", currLine, currPos-1, yytext); exit(0);}

%%


	/* C functions used in lexer */

int main(int argc, char ** argv)
{
   if(argc >= 2) {
      yyin = fopen(argv[1], "r");
      if(yyin == NULL) {
         yyin = stdin;
      }
   }
   else{
      yyin = stdin;
   }
   yylex();
}
