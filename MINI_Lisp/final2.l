%{
#include "ex1.tab.h"
%}
%%
\n      { return(0); /* EOF */ }
"+"|"-"|"*"|"/"|"("|")"|"<"|">"|"=" { return(yytext[0]); }
[ \t]+  { /* do nothing */ }
"mod" {yylval.value=strdup(yytext);return(MOD);}
"and" {yylval.value=strdup(yytext);return(AND);}
"or" {yylval.value=strdup(yytext);return(OR);}
"not" {yylval.value=strdup(yytext);return(NOT);}
"define" {yylval.value=strdup(yytext);return(DEFINE);}
"fun" {yylval.value=strdup(yytext);return(FUN);}
"if" {yylval.value=strdup(yytext);return(IF);}
"print-num" {yylval.value=strdup(yytext);return(PRIN);}
"print-bool" {yylval.value=strdup(yytext);return(PRIB);}
[0]|([1-9][0-9]*)|(-[1-9][0-9]*)  { yylval.ival = atoi(yytext);return(INUMBER); }
[a-z][a-z|0-9|-]* { yylval.value=strdup(yytext);return(ID); }
"#t"|"#f" { yylval.value=strdup(yytext);return(BOOL); }
.       { return(yytext[0]); }
%%

