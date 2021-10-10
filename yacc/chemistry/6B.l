%{
    #include "y.tab.h"
    #include <string.h>
    void yyerror(const char *);
%}

%%
[0-9]+ {
    yylval.ival = atoi(yytext);
    return INTEGER;
}

[A-Z][a-z]? {
    yylval.elem = strdup(yytext);
    return ELEM;
}

"->" {
    return ARROW;
}

\n|"+"|"("|")" {
    return yytext[0];
}

[ \t]+ {
    ;
}

. {
    yyerror("invalid input");
}

%%