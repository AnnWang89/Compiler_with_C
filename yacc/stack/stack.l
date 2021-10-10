%{
#include "ex1.tab.h"
%}
%%
"#"      { return(0); /* EOF */ }
[ \t\n]+  { /* do nothing */ }
"add"|"sub"|"mul"|"mod"  {yylval.value=strdup(yytext);return(OP);}
"inc"|"dec"  {yylval.value=strdup(yytext);return(ID);}
"load"       {yylval.value=strdup(yytext);return(LOAD);}
"copy"       {yylval.value=strdup(yytext);return(COPY);}
"delete"       {yylval.value=strdup(yytext);return(DELETE);}
"switch"       {yylval.value=strdup(yytext);return(SWITCH);}
[1-9][0-9]*  { yylval.ival = atoi(yytext);return(INUMBER); }
.       { return(yytext[0]); }
%%
