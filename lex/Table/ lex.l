Word    ^[A-Z][A-Z|a-z]*$
IPnum   [0-9]|[1-9][0-9]|[1][0-9][0-9]|[2][0-4][0-9]|[2][5][0-5]
IPAddress   ^({IPnum}\.){3}{IPnum}$
Eword   [a-z|A-Z|0-9]+
EmailAddress    ^{Eword}[@]({Eword}\.)+{Eword}$
%%
{Word}  {ECHO;printf(" is a word\n");}
{IPAddress} {ECHO;printf(" is an IP address\n");}
{EmailAddress} {ECHO;printf(" is an email address\n");}
.    ;
%%
int main(void){
    yylex();
    return(0);
}
