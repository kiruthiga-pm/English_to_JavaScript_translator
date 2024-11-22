%option noyywrap
%{
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
%}
%% 

"create"|"define"|"add" { return CREATE; }
"variable" { return VAR; }
"function" { return FUNC; }
"parameter" { return PARAM;}
"body" { return BLBODY;}
"assigned"|"initialized" { return ASSIGN; }
"repeat" { return REPEAT; }
"until" { return UNTIL; }
"loop" { return LOOP; }
"set" { return SET;}
"while" { return WHILE;}
"through" {return THROUGH;}
"switch" { return SWITCH; }
"case" { return CASE;}
"default" { return DEFAULT;}
"when" { return WHEN;}
"if" { return IF; }
"then" { return THEN; }
"else if" {return ELIF;}
"else" { return ELSE; }
"constant" { return CONST; }
"return" { return RETURN; }
"write"|"output"|"print" { return OUTPUT;}
"html" {return HTML;}
"tag" { return TAG;}
"color" { return COLOR;}
"console" { return CONSOLE;}
"alert box" {return ALERT;} 
"break" { return BREAK; }
"end" { return END;}
"." { return FULLSTOP;}
"button" { return BUTTON;}
"text" { return TEXT;}
"div" { return DIVC;}
"id" { return DID;}
"class" { return CLASS;}
"continue" { return CONTINUE; }
"do" { return DO;}
"addition"|"plus"|"add" {return PLUS;}
"subtract"|"minus"|"subtract from" {return SUB;}
"multiply"|"times"|"multiplied by" {return MUL;}
"divide"|"divided by"|"by" {return DIV;}
"true"|"false"|"True"|"False" {yylval.str=strdup(yytext);return BOOL;}
"list" {return LIST;}
"of" {return OF;}
"step" { return STEP;}
"," { return COMMA;}
"a"|"the"|"with"|"and"|"having"|"in"|"where"|"to" {}
[\"][A-Za-z \t\n0-9\.]+[\"]|[\'][A-Za-z \t\n0-9\.]+[\'] {yylval.str=strdup(yytext);return STRING;}
[ \t\n] { }  // Ignore whitespace
[a-zA-Z_][a-zA-Z_0-9]* { yylval.str = strdup(yytext); return ID; }
[0-9]+ { yylval.str = strdup(yytext); return NUM; }
"less than" { return LT; }
"greater than" { return GT; }
"less than or equal to" { return LE; }
"greater than or equal to" { return GE; }
"equals to"|"equal to" { return EQ; }
"not equal to" { return NE; }
"mouse pointer is over"|"mouse pointer over" { return ONMOUSEOVER;}
"click"|"clicked"|"mouse click"|"mouse clicked" { return ONCLICK;}
. { return yytext[0]; }

%%
