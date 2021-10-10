%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *message);
int top=0;
int topinfun=0;
int i=0;
int j=0;
int t=0;
int count=0;
void defvar(char *v,int vn);
int findvar(char *v);
int findvarinfun(char *v);
void checktype(int iorb,int what );
void printfun(int whichindex, int intorbool);
void treetriverse(int start,int end,int intorbool,int prin);
%}
%code requires{
      struct num {
             int i;
             int b;
             int index;
      };
      typedef struct tree{
            int inum;
            int bnum;
            int ope;
            char* varn;
            int left;
            int right;
            };
      struct tree T[8000];
      int tmp[5];
      char* varname[500];
      int   varnum[500];
      char* varnameinfun[500];
      int   varnuminfun[500];

}
%union {
int ival;
char* value;
struct {
             int i;
             int b;
             int index;
      }num;
}
%token <value> MOD
%token <value> AND
%token <value> OR
%token <value> NOT
%token <value> DEFINE
%token <value> FUN
%token <value> IF
%token <value> PRIN
%token <value> PRIB
%token <ival> INUMBER
%token <value> ID
%token <value> BOOL
%type <num> stmt
%type <num> stmts
%type <num> exp
%type <num> expplus
%type <num> expmul
%type <num> expequ
%type <num> expand
%type <num> expor
%type <num> defstmt
%type <num> printstmt
%type <num> numop
%type <num> logicalop
%type <num> funexp
%type <num> funcall
%type <num> ifexp
%type <num> funids
%type <num> funbody
%type <num> lastexp
%type <num> ids
%type <num> params
%type <num> funname
%type <num> testexp
%type <num> thenexp
%type <num> elseexp
%left '+''-'
%left '*''/'
%nonassoc LandR
%%
line      : stmts
          ;

stmts     : stmt stmts
          |                                {}
          ;
stmt      : exp
          | defstmt
          | printstmt
          ;
printstmt : '(' PRIN { count=t;} exp ')'                      { if($4.b==-3)  printfun($4.index, 0);
                                                               else  treetriverse(count,$4.index,0,1);}
          | '(' PRIB { count=t;} exp ')'                      { if( $4.b == -3) printfun($4.index, 1);
                                                               else treetriverse(count,$4.index,1,1);}
          ;
exp       : BOOL                                  { if(strcmp ("#t", $1) == 0)
                                                    {
                                                          $$.b = 1;
                                                          T[t].bnum = 1;
                                                    }else
                                                    {
                                                          $$.b = 0;
                                                          T[t].bnum = 0;
                                                    }
                                                    T[t].inum = 0 ;
                                                    $$.i = 0;
                                                    T[t].ope = -1;
                                                    T[t].varn= NULL;
                                                    T[t].left = -1;
                                                    T[t].right = -1;
                                                    $$.index=t;
                                                    t++;
                                                  }
          | INUMBER                               { $$.i = $1; $$.b = -1;
                                                    T[t].inum = $1 ;
                                                    T[t].bnum = -1 ;
                                                    T[t].ope = -1;
                                                    T[t].varn= NULL;
                                                    T[t].left = -1;
                                                    T[t].right = -1;
                                                    $$.index=t;
                                                    t++;}
          | ID                                    { $$.i = findvar($1);$$.b=-1;
                                                    T[t].inum = findvar($1) ;
                                                    T[t].bnum = -1 ;
                                                    T[t].ope = -1;
                                                    T[t].varn= $1;
                                                    T[t].left = -1;
                                                    T[t].right = -1;
                                                    $$.index=t;
                                                    t++;}
          | numop                                 { $$=$1;}
          | logicalop                             { $$=$1;}
          | funexp
          | funcall
          | ifexp                                 { $$=$1;}
          ;
numop     : '(' '+' exp exp expplus ')'           { checktype(0,$3.b) ;checktype(0,$4.b) ;
                                                    T[t].inum = $4.i + $5.i ;
                                                    T[t].bnum = -1;
                                                    T[t].ope = 0;
                                                    T[t].varn= NULL;
                                                    T[t].left = $4.index;
                                                    T[t].right = $5.index;
                                                    t++;
                                                    T[t].inum = $3.i + $4.i + $5.i;
                                                    T[t].bnum = -1;
                                                    T[t].ope = 0;
                                                    T[t].varn= NULL;
                                                    T[t].left = $3.index;
                                                    T[t].right = t-1;
                                                    $$.index=t;
                                                    t++;
                                                    $$.i = $3.i + $4.i + $5.i; $$.b = -1;}
          | '(' '-' exp exp ')'                   { checktype(0,$3.b) ; checktype(0,$4.b) ;
                                                    T[t].inum = $3.i - $4.i ;
                                                    T[t].bnum = -1;
                                                    T[t].ope = 1;
                                                    T[t].varn= NULL;
                                                    T[t].left = $3.index;
                                                    T[t].right = $4.index;
                                                    $$.index=t;
                                                    t++;
                                                    $$.i = $3.i - $4.i; $$.b = -1;}
          | '(' '*' exp exp expmul ')'           { checktype(0,$3.b) ;checktype(0,$4.b) ;
                                                    T[t].inum = $4.i * $5.i ;
                                                    T[t].bnum = -1;
                                                    T[t].ope = 2;
                                                    T[t].varn= NULL;
                                                    T[t].left = $4.index;
                                                    T[t].right = $5.index;
                                                    t++;
                                                    T[t].inum = $3.i * $4.i * $5.i;
                                                    T[t].bnum = -1;
                                                    T[t].ope = 2;
                                                    T[t].varn= NULL;
                                                    T[t].left = $3.index;
                                                    T[t].right = t-1;
                                                    $$.index=t;
                                                    t++;
                                                    $$.i = $3.i * $4.i*$5.i; $$.b = -1;}
          | '(' '/' exp exp ')'            { checktype(0,$3.b) ;checktype(0,$4.b) ;
                                             T[t].inum = $3.i / $4.i ;
                                             T[t].bnum = -1;
                                             T[t].ope = 3;
                                             T[t].varn= NULL;
                                             T[t].left = $3.index;
                                             T[t].right = $4.index;
                                             $$.index=t;
                                             t++;
                                             $$.i = $3.i / $4.i; $$.b = -1;}
          | '(' MOD exp exp ')'            { checktype(0,$3.b) ;checktype(0,$4.b) ;
                                             T[t].inum = $3.i % $4.i ;
                                             T[t].bnum = -1;
                                             T[t].ope = 4;
                                             T[t].varn= NULL;
                                             T[t].left = $3.index;
                                             T[t].right = $4.index;
                                             $$.index=t;
                                             t++;
                                             $$.i = $3.i % $4.i; $$.b = -1;}
          | '(' '>' exp exp ')'            { checktype(0,$3.b) ;checktype(0,$4.b) ;
                                             if($3.i > $4.i)
                                             {
                                                  T[t].bnum =1;
                                                  $$.b = 1;
                                             }else
                                             {
                                                  T[t].bnum =0;
                                                  $$.b=0;
                                             }
                                             $$.i=0;
                                             T[t].inum = 0 ;
                                             T[t].ope = 5;
                                             T[t].varn= NULL;
                                             T[t].left = $3.index;
                                             T[t].right = $4.index;
                                             $$.index=t;
                                             t++;
                                           }
          | '(' '<' exp exp ')'            { checktype(0,$3.b) ;checktype(0,$4.b) ;
                                             if($3.i < $4.i)
                                             {
                                                  T[t].bnum =1;
                                                  $$.b = 1;
                                             }else
                                             {
                                                  T[t].bnum =0;
                                                  $$.b=0;
                                             }
                                             $$.i=0;
                                             T[t].inum = 0 ;
                                             T[t].ope = 6;
                                             T[t].varn= NULL;
                                             T[t].left = $3.index;
                                             T[t].right = $4.index;
                                             $$.index=t;
                                             t++;
                                           }
          | '(' '=' exp exp expequ ')'     { checktype(0,$3.b) ;checktype(0,$4.b) ;
                                             if($5.b == 1 || $5.b == 3 )
                                             {
                                                  if($4.i == $5.i || $5.b == 3 )
                                                  {
                                                       T[t].bnum =1;
                                                       $$.b = 1;
                                                  }else
                                                  {
                                                       T[t].bnum =0;
                                                       $$.b=0;
                                                  }
                                             }else
                                             {
                                                  T[t].bnum =0;
                                                  $$.b=0;
                                             }
                                             T[t].inum = $4.i ;
                                             $$.i=$4.i;
                                             T[t].ope = 7;
                                             T[t].varn= NULL;
                                             T[t].left = $4.index;
                                             T[t].right = $5.index;
                                             $$.index=t;
                                             t++;
                                             if(($5.b == 1 || $5.b == 3) && $3.i == $4.i )
                                             {
                                                  if($3.i == $5.i || $5.b == 3)
                                                  {
                                                       T[t].bnum =1;
                                                       $$.b = 1;
                                                  }else
                                                  {
                                                       T[t].bnum =0;
                                                       $$.b=0;
                                                  }
                                             }else
                                             {
                                                  T[t].bnum =0;
                                                  $$.b=0;
                                             }
                                             T[t].inum = $3.i ;
                                             $$.i=$3.i;
                                             T[t].ope = 7;
                                             T[t].varn= NULL;
                                             T[t].left = $3.index;
                                             T[t].right =t-1;
                                             $$.index=t;
                                             t++;
                                           }
          ;
expplus   : exp expplus             { checktype(0,$1.b) ;
                                      T[t].inum = $1.i + $2.i;
                                      T[t].bnum = -1;
                                      T[t].ope = 0;
                                      T[t]varname= NULL;
                                      T[t].left = $1.index;
                                      T[t].right = $2.index;
                                      $$.index=t;
                                      t++;
                                      $$.i = $1.i + $2.i ;$$.b = -1;}
          |                         { T[t].inum = 0;
                                      T[t].bnum = -1;
                                      T[t].ope = -1;
                                      T[t].varn= NULL;
                                      T[t].left = -1;
                                      T[t].right = -1;
                                      $$.index=t;
                                      t++;
                                      $$.i =0; $$.b = -1;}
          ;
expmul   : exp expmul               { checktype(0,$1.b) ;
                                      T[t].inum = $1.i * $2.i;
                                      T[t].bnum = -1;
                                      T[t].ope = 2;
                                      T[t].varn= NULL;
                                      T[t].left = $1.index;
                                      T[t].right = $2.index;
                                      $$.index=t;
                                      t++;
                                      $$.i = $1.i * $2.i ;$$.b = -1;}
          |                         { T[t].inum = 1;
                                      T[t].bnum = -1;
                                      T[t].ope = -1;
                                      T[t].varn= NULL;
                                      T[t].left = -1;
                                      T[t].right = -1;
                                      $$.index=t;
                                      t++;
                                      $$.i = 1; $$.b = -1;}
          ;
expequ    : exp expequ                   { checktype(0,$1.b) ;
                                           if($2.b == 1 || $2.b == 3 )
                                           {
                                                if($1.i == $2.i || $2.b == 3 )
                                                {
                                                     T[t].bnum =1;
                                                     $$.b = 1;
                                                }else
                                                {
                                                     T[t].bnum =0;
                                                     $$.b=0;
                                                }
                                           }else
                                           {
                                                T[t].bnum =0;
                                                $$.b=0;
                                           }
                                           T[t].inum = $1.i ;
                                           $$.i=$1.i;
                                           T[t].ope = 7;
                                           T[t].varn= NULL;
                                           T[t].left = $1.index;
                                           T[t].right = $2.index;
                                           $$.index=t;
                                           t++;
                                         }
          |                              { T[t].inum = 0;
                                           T[t].bnum = 3;
                                           T[t].ope = -1;
                                           T[t].varn= NULL;
                                           T[t].left = -1;
                                           T[t].right = -1;
                                           $$.index=t;
                                           t++;
                                           $$.i=0;$$.b=3;}
          ;
logicalop : '(' AND exp exp expand ')'    { checktype(1,$3.b) ;checktype(1,$4.b) ;
                                            T[t].inum = 0 ;
                                            T[t].bnum = $4.b && $5.b;
                                            T[t].ope = 8;
                                            T[t].varn= NULL;
                                            T[t].left = $4.index;
                                            T[t].right =$5.index;
                                            t++;
                                            T[t].inum = 0;
                                            T[t].bnum = $3.b && $4.b && $5.b;
                                            T[t].ope = 8;
                                            T[t].varn= NULL;
                                            T[t].left = $3.index;
                                            T[t].right = t-1;
                                            $$.index=t;
                                            t++;
                                            $$.b = $3.b && $4.b && $5.b;$$.i=0;}
          | '(' OR exp exp expor ')'      { checktype(1,$3.b) ;checktype(1,$4.b) ;
                                            T[t].inum = 0 ;
                                            T[t].bnum = $4.b || $5.b;
                                            T[t].ope = 9;
                                            T[t].varn= NULL;
                                            T[t].left = $4.index;
                                            T[t].right = $5.index;
                                            t++;
                                            T[t].inum = 0;
                                            T[t].bnum = $3.b || $4.b || $5.b;
                                            T[t].ope = 9;
                                            T[t].varn= NULL;
                                            T[t].left = $3.index;
                                            T[t].right = t-1;
                                            $$.index=t;
                                            t++;
                                            $$.b = $3.b || $4.b|| $5.b;$$.i=0;}
          | '(' NOT exp ')'               { checktype(1,$3.b) ;
                                            T[t].inum = 0 ;
                                            T[t].bnum = !$3.b;
                                            T[t].ope = 10;
                                            T[t].varn= NULL;
                                            T[t].left = $3.index;
                                            T[t].right = -1;
                                            $$.index=t;
                                            t++;
                                            $$.b = !$3.b ;$$.i=0;}
          ;
expand    : exp expand                    { checktype(1,$1.b) ;
                                            T[t].inum = 0 ;
                                            T[t].bnum = $1.b && $2.b;
                                            T[t].ope = 8;
                                            T[t].varn= NULL;
                                            T[t].left = $1.index;
                                            T[t].right = $2.index;
                                            $$.index=t;
                                            t++;
                                            $$.b = $1.b && $2.b;$$.i=0;}
          |                               { T[t].inum = 0 ;
                                            T[t].bnum = 1;
                                            T[t].ope = -1;
                                            T[t].varn= NULL;
                                            T[t].left = -1;
                                            T[t].right = -1;
                                            $$.index=t;
                                            t++;
                                            $$.b = 1 ;$$.i=0;}
          ;
expor     : exp expor                     { checktype(1,$1.b) ;
                                            T[t].inum = 0 ;
                                            T[t].bnum = $1.b || $2.b;
                                            T[t].ope = 9;
                                            T[t].varn= NULL;
                                            T[t].left = $1.index;
                                            T[t].right = $2.index;
                                            $$.index=t;
                                            t++;
                                            $$.b = $1.b || $2.b;$$.i=0;}
          |                               { T[t].inum = 0 ;
                                            T[t].bnum = 0;
                                            T[t].ope = -1;
                                            T[t].varn= NULL;
                                            T[t].left = -1;
                                            T[t].right = -1;
                                            $$.index=t;
                                            t++;
                                            $$.b = 0 ;$$.i=0;}
          ;
defstmt   : '(' DEFINE ID exp ')'         { defvar($3,$4.i);}
          ;
funexp    : '(' FUN funids funbody ')'    { T[t].inum = 0 ;
                                            T[t].bnum = -3;
                                            T[t].ope = 14;
                                            T[t].varn= NULL;
                                            T[t].left = $3.index;
                                            T[t].right = $4.index;
                                            $$.index=t;
                                            t++;
                                            $$.b = -3 ;$$.i=0;
                                          }
          ;
funids    : '(' ids ')'                   { T[t].inum = 0 ;
                                            T[t].bnum = -3;
                                            T[t].ope = 16 ;
                                            T[t].varn= NULL;
                                            T[t].left = $2.index;
                                            T[t].right = -1;
                                            $$.index=t;
                                            t++;
                                            $$.b = -3 ;$$.i=0;
                                          }
          ;
funbody   : exp                          { $$=$1;}
          ;
funcall   : '(' funexp params ')'        { T[t].inum = 0 ;
                                            T[t].bnum = -3;
                                            T[t].ope = 13;
                                            T[t].varn= NULL;
                                            T[t].left = $2.index;
                                            T[t].right = $3.index;
                                            $$.index=t;
                                            t++;
                                            $$.b = -3 ;$$.i=0;}
          | '(' funname params ')'
          ;
lastexp   : exp                           { $$=$1;}
          ;
ids       : ID ids                        { T[t].inum = 0 ;
                                            T[t].bnum = -3;
                                            T[t].ope = 18;
                                            T[t].varn= $1;
                                            T[t].left = $2.index;
                                            T[t].right = -1;
                                            $$.index=t;
                                            t++;
                                            $$.b = -3 ;$$.i=0;
                                          }
          |                               { T[t].inum = 0 ;
                                            T[t].bnum = -3;
                                            T[t].ope = 19;
                                            T[t].varn= NULL;
                                            T[t].left = -1;
                                            T[t].right = -1;
                                            $$.index=t;
                                            t++;
                                            $$.b = -3 ;$$.i=0;
                                          }
          ;
params    : exp params                    { T[t].inum = $1.i ;
                                            T[t].bnum = $1.b;
                                            T[t].ope = 15;
                                            T[t].varn= NULL;
                                            T[t].left = $1.index;
                                            T[t].right = $2.index;
                                            $$.index=t;
                                            t++;
                                            $$.b = $1.b ;$$.i=$1.i ;
                                          }
          |                               { T[t].inum = 0 ;
                                            T[t].bnum = -3;
                                            T[t].ope = 19;
                                            T[t].varn= NULL;
                                            T[t].left = -1;
                                            T[t].right = -1;
                                            $$.index=t;
                                            t++;
                                            $$.b = -3 ;$$.i=0 ;}
          ;
funname   : ID
          ;
ifexp     : '(' IF testexp thenexp elseexp ')'  { if( $3.b == 1)
                                                  {
                                                      $$.i = $4.i;
                                                      $$.b = $4.b;
                                                      T[t].inum = $4.i;
                                                      T[t].bnum = $4.b;
                                                  }else
                                                  {   $$.i = $5.i;
                                                      $$.b = $5.b;
                                                      T[t].inum = $5.i;
                                                      T[t].bnum = $5.b;
                                                  }
                                                  T[t].ope = 11;
                                                  T[t].varn= NULL;
                                                  T[t].left = $4.index;
                                                  T[t].right = $5.index;
                                                  $$.index=t;
                                                  t++;
                                                  T[t].inum = T[t-1].inum;
                                                  T[t].bnum = T[t-1].bnum;
                                                  T[t].ope = 12;
                                                  T[t].varn= NULL;
                                                  T[t].left =  $3.index;
                                                  T[t].right = t-1;
                                                  $$.index=t;
                                                  t++;
                                               }
          ;
testexp   : exp                                { checktype(1,$1.b) ;$$=$1;}
          ;
thenexp   : exp                                { $$=$1;}
          ;
elseexp   : exp                                { $$=$1;}
          ;
%%
void defvar(char *v,int vn)
{
        for(i=0;i<top;i++)
        {
             if(strcmp (varname[i], v) == 0)
             {
                   printf("Redefine\n");
                   exit (0);
             }
        }
        varname[top] = v;
        varnum[top] = vn;
        top++;
}
int findvar(char *v)
{

        for(i=0;i<top;i++)
        {
             if(strcmp (varname[i], v) == 0)
             {
                   return varnum[i];
             }
        }
        return 0;
        

}
int findvarinfun(char *v)
{

        for(j=0;j<topinfun;j++)
        {
             if(strcmp (varnameinfun[j], v) == 0)
             {
                   return varnuminfun[j];
             }
        }
        for(j=0;j<top;j++)
        {
             if(strcmp (varname[j], v) == 0)
             {
                   return varnum[j];
             }
        }
        printf("Not defined\n");
        exit (0);

}
void checktype(int iorb,int what )
{
        if(iorb == 0)
        {
             if(what!=-1)
             {
                   printf("Type Error\n");
                   exit (0);
             }
        }else
        {
             if(what==-1)
             {
                   printf("Type Error\n");
                   exit (0);
             }
        }

}
void printfun(int whichindex, int intorbool)
{
        if(T[whichindex].ope == 13)
        {
               tmp[0] = T[whichindex].left;
               tmp[2] = T[tmp[0]].right;
               tmp[3] = T[tmp[0]].left;
               tmp[0] = T[tmp[0]].left;

               tmp[0] = T[tmp[0]].left;
               tmp[1] = T[whichindex].right;
               while(T[tmp[0]].ope != 19)
               {
                    varnameinfun[topinfun]=T[tmp[0]].varn;
                    varnuminfun[topinfun]=T[T[tmp[1]].left].inum;
                    topinfun++;
                    tmp[0] = T[tmp[0]].left;
                    tmp[1] = T[tmp[1]].right;
               }
               treetriverse(tmp[3]+1,tmp[2],intorbool,1);
               topinfun=0;
        }

}
void treetriverse(int start,int end,int intorbool,int prin)
{
        for(i=start;i<=end;i++)
        {
              if(T[i].ope==-1)
              {
                    if(T[i].varn)
                    {
                          T[i].inum = findvarinfun(T[i].varn);
                    }
              }else if(T[i].ope==0)
              {
                    T[i].inum=T[T[i].left].inum + T[T[i].right].inum;
              }else if(T[i].ope==1)
              {
                    T[i].inum=T[T[i].left].inum - T[T[i].right].inum;
              }else if(T[i].ope==2)
              {
                    T[i].inum=T[T[i].left].inum * T[T[i].right].inum;
              }else if(T[i].ope==3)
              {
                    T[i].inum=T[T[i].left].inum / T[T[i].right].inum;
              }else if(T[i].ope==4)
              {
                    T[i].inum=T[T[i].left].inum % T[T[i].right].inum;
              }else if(T[i].ope==5)
              {
                    if(T[T[i].left].inum>T[T[i].right].inum)
                       T[i].bnum=1;
                    else
                       T[i].bnum=0;
              }else if(T[i].ope==6)
              {
                    if(T[T[i].left].inum<T[T[i].right].inum)
                       T[i].bnum=1;
                    else
                       T[i].bnum=0;
              }else if(T[i].ope==7)
              {
                    if(T[T[i].left].inum==T[T[i].right].inum && T[T[i].right].bnum!=0)
                    {
                           T[i].bnum=1;
                           T[i].inum=T[T[i].left].inum;
                    }else
                    {
                           T[i].bnum=0;
                    }
              }else if(T[i].ope==8)
              {
                    T[i].bnum=T[T[i].left].bnum && T[T[i].right].bnum;
              }else if(T[i].ope==9)
              {
                    T[i].bnum=T[T[i].left].bnum || T[T[i].right].bnum;
              }else if(T[i].ope==10)
              {
                    T[i].bnum=!T[T[i].left].bnum ;
              }else if(T[i].ope==11)
              {
                    if(T[T[i].left].bnum ==1 )
                    {
                           T[i].bnum=T[T[T[i].right].left].bnum;
                           T[i].inum=T[T[T[i].right].left].inum;
                    }else
                    {
                           T[i].bnum=T[T[T[i].right].right].bnum;
                           T[i].inum=T[T[T[i].right].right].inum;
                    }
              }
        }
        if(prin==1)
        {
              if(intorbool==0 )
              {
                    printf("%d\n",T[end].inum);
              }else
              {
                    if(T[end].bnum == 0) printf("#f\n");
                    else printf("#t\n");
              }
        }

}
void yyerror (const char *message)
{
        fprintf (stderr, "%s\n",message);
}
int main(int argc, char *argv[])
{
        yyparse();
        return(0);
}
