%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
%}
%%
[0-9]+              yylval.string=strdup(yytext);return NUMERO;
b|d                 yylval.number=!strcmp(yytext,"b");return BASE;
[+\-*/]             yylval.string=strdup(yytext);return OP;
O|o		    return OPERAR;
\n                  /* ignorar salto de linea */;
[ \t]+              /* ignorar espacios en blanco */;
%%
