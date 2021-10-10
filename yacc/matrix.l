%{
#include "ex1.tab.h"
%}
%%
\n      { return(0); /* EOF */ }
[ \t]+  { /* do nothing */ }
"^T"    { yylval.ival = 1;return(TRANS);}
[1-9][0-9]*  { yylval.ival = atoi(yytext);return(INUMBER); }
"+"|"-"|"*"|"("|")"|"["|"]"|"," { return(yytext[0]); }
.       { return(yytext[0]); }
%%
