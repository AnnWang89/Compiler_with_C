%{
#include "exB2.tab.h"
%}
%%
\n      { return(0); /* EOF */ }
[ \t]+  { /* do nothing */ }
[A-Z]  {yylval.value=strdup(yytext);return(ELEMENT);}
[1-9][0-9]*  { yylval.ival = atoi(yytext);return(INUMBER); }
"("|")"|"-"|">"|"+"    {return(yytext[0]);}
.       { return(yytext[0]); }
%%
