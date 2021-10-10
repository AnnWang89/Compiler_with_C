%{
#include "exB2.tab.h"
%}
%%
[ \t\n]+  { /* do nothing */ }
"<and>"  {yylval.value=strdup(yytext);return(AND);}
"<or>"  {yylval.value=strdup(yytext);return(OR);}
"<not>"  {yylval.value=strdup(yytext);return(NOT);}
"</and>"  {yylval.value=strdup(yytext);return(ANDE);}
"</or>"  {yylval.value=strdup(yytext);return(ORE);}
"</not>"  {yylval.value=strdup(yytext);return(NOTE);}
"<true/>"|"<false/>"    {yylval.value=strdup(yytext);return(TF);}
.       { return(yytext[0]); }
%%
