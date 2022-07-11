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
   /* {printf("\n");} */

prog_start: functions {printf("prog_start -> functions\n");}
            ;

functions: /*epsilon*/ {printf("functions -> epsilon\n");}
         | function functions {printf("functions -> function functions\n");}
         ;

function: FUNCTION IDENT SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements_plus END_BODY {printf("function -> FUNCTION IDENT %s SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements_plus END_BODY/n", $2);}
      ; 

/* ident: IDENT {printf("ident -> IDENT\n")}
   ; not sure if this should be a grammar */
 
declarations: /*epsilon*/ {printf("declarations -> epsilon\n");} 
            | declaration SEMICOLON declarations {printf("declarations -> declaration SEMICOLON declarations\n");}
 ;
 
declaration: idents_plus COLON INTEGER {printf("declaration -> idents_plus COLON INTEGER\n");}
	          | idents_plus COLON ENUM L_PAREN idents_plus R_PAREN {printf("declaration -> idents_plus COLON ENUM L_PAREN idents_plus R_PAREN\n");}
	          | idents_plus COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER {printf("declaration -> idents_plus COLON ARRAY L_SQUARE_BRACKET %d R_SQUARE_BRACKET OF INTEGER\n", $5);}
;

idents_plus: IDENT {printf("ident_plus -> IDENT %s\n"), $1;}
            | IDENT COMMA idents_plus {printf("ident_plus -> IDENT %s COMMA idents_plus \n", $1);}
;
statements_plus:  statement SEMICOLON {printf("statement_plus -> statement SEMICOLON\n");}
                | statement SEMICOLON statements_plus {printf("statement_plus -> statement SEMICOLON statements_plus\n");}
;
statement: var ASSIGN expression {printf("statement -> var ASSIGN expression\n");}
         | IF bool_expr THEN statements_plus ENDIF {printf("statement -> IF bool_expr THEN statements_plus ENDIF\n");}
         | IF bool_expr THEN statements_plus ELSE statements_plus ENDIF {printf("statement -> IF bool_expr THEN statements_plus ELSE statements_plus ENDIF\n");}
	      | WHILE bool_expr BEGINLOOP statements_plus ENDLOOP {printf("statement -> WHILE bool_expr BEGINLOOP statements_plus ENDLOOP\n");}
	      | DO BEGINLOOP statements_plus ENDLOOP WHILE bool_expr {printf("statement -> DO BEGINLOOP statements_plus ENDLOOP\n");}
	      | FOR vars_plus ASSIGN NUMBER SEMICOLON bool_expr SEMICOLON vars_plus ASSIGN expression BEGINLOOP statements_plus ENDLOOP {printf("statement -> FOR vars_plus ASSIGN %d SEMICOLON bool_expr SEMICOLON vars_plus ASSIGN expression BEGINLOOP statements_plus ENDLOOP\n", $4);}
	      | READ vars_plus {printf("statement -> READ vars_plus\n");}
      	| WRITE vars_plus {printf("statement -> WRITE vars_plus\n");}
      	| CONTINUE  {printf("statement -> CONTINUE\n");}
      	| RETURN expression {printf("statement -> RETURN expression\n");}
;

var: IDENT {printf("var -> IDNET %s\n", $1);}
   | IDENT L_SQUARE_BRACKET expression R_SQUARE_BRACKET {printf("var -> IDNET %s R_SQUARE_BRACKET expression L_SQUARE_BRACKET\n", $1);}
;

expression: mult_expr {printf("expression -> mult_expr\n");}
	         | expression ADD mult_expr {printf("expression -> expression ADD mult_expr\n");}
	         | expression SUB mult_expr {printf("expression -> expression SUB mult_expr\n");}

;

bool_expr: relation_and_expr {printf("bool_expr -> relation_and_expr\n");}
         | bool_expr OR relation_and_expr {printf("bool_expr -> bool_expr OR relation_and_expr\n");}
;

vars_plus: var COMMA vars_plus {printf("vars_plus -> var COMMA vars_plus\n");}
         | var {printf("vars_plus -> var\n");}
;

mult_expr: term {printf("mult_expr -> term\n");}
	      | mult_expr MULT term {printf("mult_expr -> mult_expr MULT term\n");}
	      | mult_expr DIV term {printf("mult_expr -> mult_expr DIV term\n");}
	      | mult_expr MOD term {printf("mult_expr -> mult_expr MOD term\n");}

;

relation_and_expr: relation_expr {printf("relation_and_expr -> relation_expr\n");}
                  | relation_and_expr AND relation_expr {printf("relation_and_expr -> relation_and_expr AND relation_expr\n");}

;

term: var {printf("term -> var\n");}
    | SUB var {printf("term -> SUB var\n");}
	 | NUMBER {printf("term -> NUMBER %d\n", $1);}
	 | SUB NUMBER {printf("term -> SUB NUMBER %d\n", $2);}
	 | L_PAREN expression R_PAREN {printf("term -> L_PAREN expression R_PAREN\n");}
    | IDENT L_PAREN expression R_PAREN {printf("term -> IDENT %s L_PAREN expression R_PAREN\n", $1);}
    | IDENT L_PAREN R_PAREN {printf("term -> IDENT %s L_PAREN R_PAREN\n", $1);}
;

relation_expr: expression comp expression {printf("relation_expr -> expression comp expression\n");}
		       | NOT expression comp expression {printf("relation_expr -> NOT expression comp expression\n");}
		       | TRUE {printf("relation_expr -> TRUE\n");}
      		 | NOT TRUE {printf("relation_expr -> NOT TRUE\n");}
      		 | FALSE {printf("relation_expr -> FALSE\n");}
	      	 | NOT FALSE {printf("relation_expr -> NOT FALSE\n");}
	      	 | L_PAREN bool_expr R_PAREN {printf("relation_expr -> L_PAREN bool_expr R_PAREN\n");}
		       | NOT L_PAREN bool_expr R_PAREN {printf("relation_expr -> NOT L_PAREN bool_expr R_PAREN\n");}
;  

comp: EQ {printf("comp -> EQ\n");}
	 | NEQ {printf("comp -> NEQ\n");}
	 | LT {printf("comp -> LT\n");}
	 | GT {printf("comp -> GT\n");}
	 | LTE {printf("comp -> LTE\n");}
	 | GTE {printf("comp -> GTE\n");}
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