%{
#include <stdio.h>
#include <string.h>
void yyerror(const char *message);
void show(int ans);
int trueorfalse(char* v);
%}
%code requires{
      struct typ {
             int or;
             int and;
      };
}
%union {
char* value;
struct {
             int or;
             int and;
             
      }typ;
}
%token <value> TF
%token <value> AND
%token <value> OR
%token <value> NOT
%token <value> ANDE
%token <value> ORE
%token <value> NOTE
%type <typ> expr
%type <typ> andornot
%nonassoc TandF
%%
line    : expr                  { show($1.and); printf("\n");}
         ;
expr    : andornot expr       { $$.and =  $1.and && $2.and;  $$.or = $1.or||$2.or ; }
        | TF expr                {$$.and = trueorfalse($1) && $2.and;  $$.or =trueorfalse($1) || $2.or;}
        | expr TF                {$$.and = trueorfalse($2) && $1.and;  $$.or =trueorfalse($2) || $1.or;}
        |                           {$$.and = 1 ;$$.or = 0; }
        ;
andornot :AND expr ANDE       { $$.and =  $2.and ;  $$.or = $2.and  ;}
        | OR expr ORE         { $$.and =  $2.or ;  $$.or = $2.or ; }
        | NOT expr NOTE         { $$.and = !$2.and;  $$.or = !$2.or ;} 
        ;

%%

void yyerror (const char *message)
{
        fprintf (stderr, "%s\n",message);
}
void show(int ans)
{
       if(ans == 0)
            printf("false");
        else if(ans == 1)
            printf("true");
        else
            printf("why");
}
int trueorfalse(char* v)
{
        if(strcmp ("<false/>", v) == 0 )
           return 0;
        else if(strcmp ("<true/>", v) == 0 )
           return 1;
        else
           return 2;
}

int main(int argc, char *argv[]) {
        yyparse();
        return(0);
}
