%{
#include <stdio.h>
#include <string.h>
void yyerror(const char *message);
void topre(int ind);
int x=0;
%}
%code requires{
      struct node {
             int index;
             int number;
      };
      struct tree {
             char n;
             int l;
             int r;
      };
      struct tree T[1000];
}
%union {
int ival;
struct {
             int index;
             int number;
      }node;
}
%token <ival> INUMBER
%type <node> expr
%left '+''-'
%left '*''/'
%left '('
%right ')'
%nonassoc LandR
%%
line    : expr                  { printf("the preorder expression is :");
                                  topre(x-1);
                                  printf("\nthe result is : %d\n",$1.number); }
         ;
expr    : expr '+' expr         { T[x].n='+'; T[x].l = $1.index ; T[x].r = $3.index; $$.index = x++ ; $$.number = $1.number + $3.number; }
        | expr '-' expr         { T[x].n='-'; T[x].l = $1.index ; T[x].r = $3.index; $$.index = x++ ; $$.number = $1.number - $3.number; }
        | expr '*' expr         { T[x].n='*'; T[x].l = $1.index ; T[x].r = $3.index; $$.index = x++ ; $$.number = $1.number * $3.number; }
        | expr '/' expr         { T[x].n='/'; T[x].l = $1.index ; T[x].r = $3.index; $$.index = x++ ; $$.number = $1.number / $3.number; }    
        | '(' expr ')'          %prec LandR  { $$ = $2; } 
        | INUMBER               { T[x].n = '0'+$1 ; T[x].l = -1 ; T[x].r = -1; $$.index = x++ ; $$.number = $1 ; }
        ;
%%
void yyerror (const char *message)
{
        fprintf (stderr, "%s\n",message);
}
void topre(int ind)
{
        if(ind == -1) return;
        if(T[ind].n >= '0')  printf(" %d",T[ind].n-'0');
        else  printf(" %c",T[ind].n);
        topre(T[ind].l);
        topre(T[ind].r);
        
}
int main(int argc, char *argv[]) {
        yyparse();
        return(0);
}