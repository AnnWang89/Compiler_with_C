%{
#include <stdio.h>
#include <string.h>
void yyerror(const char *message);
void show(int ans);
int trueorfalse(char* v);
int index=0;
%}
%code requires{
 
      int countleft[30];
      int countright[30];
}
%union {
char value;
int ival;
}
%token <value> ELEMENT
%token <ival> INUMBER
%type <ival> expr
%type <ival> fun
%type <ival> chemical
%nonassoc num
%%
line    : expr                 { show($1.and); printf("\n");}
         ;
expr    : fun  '-' '>' fun       { $$.and =  $1.and && $2.and;  $$.or = $1.or||$2.or ; }
        ;
fun     : INUMBER chemical '+' fun       { $$.and =  $2.and ;  $$.or = $2.and  ;}
        | INUMBER chemical         { $$.and =  $2.or ;  $$.or = $2.or ; }
        | chemical '+' fun       { $$.and =  $2.and ;  $$.or = $2.and  ;}
        | chemical         { $$.and =  $2.or ;  $$.or = $2.or ; }
        ;
chemical: ELEMENT chemical
        | ELEMENT INUMBER chemical %prec num
        | '(' chemical ')' INUMBER chemical
        | '(' chemical ')' chemical
        ;
%%

void yyerror (const char *message)
{
        fprintf (stderr, "%s\n",message);
}
void show(int ans)
{
       
}
int trueorfalse(char* v)
{
        
}

int main(int argc, char *argv[]) {
        yyparse();
        return(0);
}
