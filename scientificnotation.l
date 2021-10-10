Word    ^[+|-]?[1-9]\.[0-9]*[E][+|-]?[1-9][0-9]*$
%%
{Word}  {ECHO;printf("\n");}
.    ;
%%
int main(void){
    yylex();
    return(0);
}
