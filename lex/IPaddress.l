IPnum   [0-9]|[1-9][0-9]|[1][0-9][0-9]|[2][0-4][0-9]|[2][5][0-5]
IPAddress   ^({IPnum}\.){3}{IPnum}

%%
{IPAddress} {ECHO;}
.    ;
%%
int main(void){
    yylex();
    return(0);
}
