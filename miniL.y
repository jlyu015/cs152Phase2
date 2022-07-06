    /* cs152-miniL phase2 */
%{
 #include <stdio.h>
 #include <stdlib.h>
 void yyerror(const char *msg);
 extern int currLine;
 extern int currPos;
 FILE * yyin;
%}

%union{
  /* put your types here */
  char* strVal;
  int iVal;
}

%error-verbose
%locations
%start prog_start
%token FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY INTEGER ARRAY ENUM OF IF THEN ENDIF ELSE FOR WHILE DO BEGINLOOP ENDLOOP CONTINUE READ WRITE AND OR NOT TRUE FALSE RETURN SUB ADD MULT DIV MOD EQ NEQ LT GT LTE GTE SEMICOLON COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET ASSIGN
%token <strVal> IDENT
%token <iVal> NUMBER

%right ASSIGN //9
%left OR 
%left AND 
%right NOT 
%left EQ NEQ LT GT LTE GTE 
%left SUB ADD 
%left DIV MOD MULT //3

/*NOTE:associativity (%left or %right) and precedent (bottom most is highest precedence)
   dont have to write the first 3 precedences (0-2) */
/* %start program */

%% 

  /* write your rules here */

prog_start: /*empty (epsilon)*/ {printf("prog_start -> epsilon\n");}
            | prog_start function {printf("prog_start -> function");}
            ;

function:
         ;


%% 

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
   yyparse();
   
   return 0;
}

void yyerror(const char *msg) {
   printf("Error: Line %d, position %d: %s \n", currLine, currPos, msg);
    /* implement your error handling */
}