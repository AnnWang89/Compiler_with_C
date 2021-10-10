Word    [A-F|a-f|0-9]
Hex     ^[0][xX]({Word}|{Word}{2}|{Word}{3}|{Word}{4}|{Word}{5}|{Word}{6}|{Word}{7}|{Word}{8})$
%%
{Hex}  {ECHO;printf("\n");}
.    ;
%%
int main(void){
    yylex();
    return(0);
}
