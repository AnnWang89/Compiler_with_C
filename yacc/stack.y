%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void yyerror(const char *message);
void insop(char *op);
void insid(char *id);
void check(int use);
int top=-1;
%}
%code requires{
      int S[1000];
}
%union {
int ival;
char* value;
}
%token <ival> INUMBER
%token <value> OP
%token <value> ID
%token <value> LOAD
%token <value> COPY
%token <value> DELETE
%token <value> SWITCH
%type <ival> expr
%%
line    : expr                  { check(0);printf("%d\n",S[top]); }
         ;
expr    : OP { check(1);insop($1); } expr               
        | ID { check(0);insid($1); }expr               
        | LOAD INUMBER { top++;S[top] = $2;} expr     
        | COPY { check(0);S[++top] = S[top-1];}expr                 
        | DELETE { check(0);top--; } expr           
        | SWITCH { check(1);S[top+1] = S[top];S[top] = S[top-1];S[top-1] = S[top+1]; } expr           
        |                       {  }
        ;
%%
void yyerror (const char *message)
{./ex1
        fprintf (stderr, "%s\n",message);
}
void insop(char *op)
{
        if(strcmp ("add", op) == 0 )
        {
            S[top+1]=S[top]+S[top-1];
            
        }else if(strcmp ("sub", op) == 0 )
        {
            S[top+1]=S[top]-S[top-1];
        }else if(strcmp ("mul", op) == 0 )
        {
            S[top+1]=S[top]*S[top-1];
        }else if(strcmp ("mod", op) == 0 )
        {
            S[top+1]=S[top]%S[top-1];
        }
        S[top-1]=S[top+1];
        top--;
        
}
void insid(char *id)
{
        if(strcmp ("inc", id) == 0 )
        {
            S[top]=S[top]+1;
            
        }else if(strcmp ("dec", id) == 0 )
        {
            S[top]=S[top]-1;
        }
}
void check(int use)
{
      if(top<use)
      {
          printf("Invalid format\n");
          exit(0);
      }
}
int main(int argc, char *argv[]) {
        yyparse();
        return(0);
}