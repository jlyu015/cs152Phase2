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
  string strVal;
  int iVal;
}

%error-verbose
%locations

/* %start program */

%% 

  /* write your rules here */

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
    /* implement your error handling */
}