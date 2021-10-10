%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void yyerror(const char *message);
void checksame(int row1,int col1,int row2,int col2);
void checksamemul(int col1,int row2);
int x=0;
%}
%code requires{
     struct matrix {
             int row;
             int col;
      };
}
%union {
int ival;
struct {
             int row;
             int col;
      }matrix;
}
%token <ival> INUMBER
%token <ival> TRANS
%type <matrix> expr
%left '+''-'
%left '*''/'
%left '('
%right ')'
%nonassoc LandR
%%
line    : expr                  { printf("%d %d\n",$1.row,$1.col); }
         ;
expr    : expr '+' {x=x+1;} expr         { checksame($1.row,$1.col,$4.row,$4.col); $$.row=$1.row;$$.col=$1.col;}
        | expr '-' {x=x+1;} expr         { checksame($1.row,$1.col,$4.row,$4.col); $$.row=$1.row;$$.col=$1.col;} 
        | expr '*' {x=x+1;} expr         { checksamemul($1.col,$4.row); $$.row=$1.row;$$.col=$4.col; }    
        | '(' {x=x+1;} expr ')'          %prec LandR  { $$ = $3;x=x+1; } 
        | expr  TRANS           {  $$.row=$1.col;$$.col=$1.row;x=x+2;}
        | '[' INUMBER ',' INUMBER ']'   { $$.row=$2;$$.col=$4; x=x+5;}
        ;
%%
void yyerror (const char *message)
{
        fprintf (stderr, "%s",message);
}
void checksame(int row1,int col1,int row2,int col2)
{
        if(row1!=row2)
        {
             x=x-4;
             yyerror ("Semantic error on col ");
             printf ("%d\n",x);
             exit(0);
        }else if(col1!=col2)
        {     x=x-2;
             yyerror ("Semantic error on col ");
             printf ("%d\n",x);
             exit(0);
        }
             
}
void checksamemul(int col1,int row2)
{
        if(col1!=row2)
        {
              x=x-4;
             yyerror ("Semantic error on col ");
             printf ("%d\n",x);
             exit(0);
        }
}
int main(int argc, char *argv[]) {
        yyparse();
        return(0);
}