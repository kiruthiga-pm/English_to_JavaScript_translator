%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void yyerror(const char *s);
int yylex(void);
%}

%union {
    char *str;
}

%token CREATE VAR FUNC ASSIGN REPEAT UNTIL SET SWITCH CASE DEFAULT WHEN WHILE DIVC DID COLOR DO CLASS TAG FULLSTOP BUTTON TEXT END LOOP IF THEN OUTPUT HTML CONSOLE ALERT THROUGH ELSE CONST STEP RETURN BREAK CONTINUE LT GT LE GE EQ NE ELIF LIST OF COMMA PARAM BLBODY ONMOUSEOVER ONCLICK
%token <str> ID NUM STRING BOOL
%token PLUS SUB MUL DIV
%type <str> program DOM statement statements declaration expression switch_statement mouse_event case_blocks case_block default_block for_loop assignment attribute print_stmt elements content if_statement a1 a2 a3 list list_ele value key_value key_value_list condition function_decleration param_list block do_while while_loop
%left PLUS SUB
%left MUL DIV
%left LT GT LE GE EQ NE

%%


program: statements { printf("***JAVASCRIPT CODE***\n<script>\n%s\n</script>\n", $1); };

statements: statement statements { 
                $$ = (char *)malloc(strlen($1) + strlen($2) + 1);
                sprintf($$, "%s%s", $1, $2);
            }
          | statement { 
                $$ = (char *)malloc(strlen($1) + 1);
                sprintf($$, "%s", $1); 
            };

statement: declaration FULLSTOP
         | assignment FULLSTOP
         | function_decleration END
         | do_while END
         | while_loop END
		 | if_statement END
		 | for_loop END
		 | print_stmt FULLSTOP
		 | switch_statement END
		 | DOM FULLSTOP
		 | mouse_event FULLSTOP
;

declaration: CREATE VAR key_value_list { 
                $$ = (char *)malloc(strlen($3) + 10);
                sprintf($$, "let %s;\n", $3); 
            }
          | CREATE CONST VAR key_value_list { 
                $$ = (char *)malloc(strlen($4) + 10);
                sprintf($$, "const %s;\n", $4); 
            }
;

key_value_list: key_value { 
                $$ = strdup($1); 
            }
            | key_value_list COMMA key_value { 
                $$ = (char *)malloc(strlen($1) + strlen($3) + 2);
                sprintf($$, "%s, %s", $1, $3); 
            }
;

key_value: ID ASSIGN value { 
                $$ = (char *)malloc(strlen($1) + strlen($3) + 2);
                sprintf($$, "%s=%s", $1, $3); 
            }
          | ID { 
                $$ = strdup($1); 
            }
;

assignment: ID ASSIGN expression {
                $$ = (char *)malloc(strlen($3) + strlen($1) + 10);
                sprintf($$, "%s = %s;\n", $1, $3);
            };
print_stmt: OUTPUT content HTML { $$=malloc(strlen($2)+15); sprintf($$,"document.write(%s);\n",$2); }
| OUTPUT content CONSOLE { $$=malloc(strlen($2)+15); sprintf($$,"console.log(%s);\n",$2); }
| OUTPUT content ALERT { $$=malloc(strlen($2)+15); sprintf($$,"alert(%s);\n",$2); }
;
content: expression { $$=malloc(strlen($1)+10); sprintf($$,"%s",$1); }
| STRING { $$=strdup($1);}
;

value: expression { $$ = strdup($1); }
     | STRING { $$ = strdup($1); }
     | BOOL { $$ = strdup($1); }
     | list;
switch_statement: SWITCH ID case_blocks { 
                    $$ = (char*)malloc(strlen($2) + strlen($3) + 20);
                    sprintf($$, "switch(%s) {\n%s\n}\n", $2, $3);
                }
;

case_blocks: case_block case_blocks {
                    $$ = (char*)malloc(strlen($1) + strlen($2) + 1);
                    sprintf($$, "%s%s", $1, $2);
                }
           | default_block { 
                    $$ = strdup($1); 
                }
;

case_block: WHEN expression statements { 
                    $$ = (char*)malloc(strlen($2) + strlen($3) + 20);
                    sprintf($$, "case %s:\n%sbreak;\n", $2, $3);
                }
;

default_block: DEFAULT statements { 
                    $$ = (char*)malloc(strlen($2) + 20);
                    sprintf($$, "default:\n%sbreak;\n", $2);
                }
;


list: LIST OF list_ele { 
                $$ = (char *)malloc(strlen($3) + 10);
                sprintf($$, "[%s]", $3);
            };

list_ele: list_ele NUM { 
                $$ = (char *)malloc(12 + strlen($2)+strlen($1));  // NUM max length considered
                sprintf($$, "%s,%d", $1, atoi($2)); 
            }
        | NUM { 
                $$ = (char *)malloc(12);
                sprintf($$, "%d", atoi($1)); 
            };

expression: expression PLUS expression { 
                $$ = (char *)malloc(strlen($1) + strlen($3) + 4);
                sprintf($$, "%s + %s", $1, $3); 
            }
          | expression SUB expression { 
                $$ = (char *)malloc(strlen($1) + strlen($3) + 4);
                sprintf($$, "%s - %s", $1, $3); 
            }
          | expression MUL expression { 
                $$ = (char *)malloc(strlen($1) + strlen($3) + 4);
                sprintf($$, "%s * %s", $1, $3); 
            }
          | expression DIV expression { 
                $$ = (char *)malloc(strlen($1) + strlen($3) + 4);
                sprintf($$, "%s / %s", $1, $3); 
            }
          | NUM { 
                $$ = (char *)malloc(12);
                sprintf($$, "%d", atoi($1)); 
            }
          | ID { 
                $$ = strdup($1); 
            }
		 ;

function_decleration: CREATE FUNC ID { 
                $$ = (char *)malloc(strlen($3) + 15);
                sprintf($$, "function %s();\n", $3);
            }
          | CREATE FUNC ID PARAM param_list BLBODY block { 
                $$ = (char *)malloc(strlen($3) + strlen($5) + strlen($7) + 20);
                sprintf($$, "function %s(%s) {\n%s}\n", $3, $5, $7);
            }
          | CREATE FUNC ID PARAM param_list { 
                $$ = (char *)malloc(strlen($3) + strlen($5) + 20);
                sprintf($$, "function %s(%s) {}\n", $3, $5);
            }
          | CREATE FUNC ID BLBODY block { 
                $$ = (char *)malloc(strlen($3) + strlen($5) + 20);
                sprintf($$, "function %s() {\n%s}\n", $3, $5);
            }
;

param_list: ID { 
                $$ = strdup($1); 
            }
          | ID COMMA param_list { 
                $$ = (char *)malloc(strlen($1) + strlen($3) + 5);
                sprintf($$, "%s, %s", $1, $3); 
            }
;

block: statements { 
                $$ = strdup($1); 
            }
       | statements RETURN expression { 
                $$ = (char *)malloc(strlen($1) + strlen($3) + 10);
                sprintf($$, "%sreturn %s;\n", $1, $3); 
            };

do_while: REPEAT statements UNTIL condition { 
                $$ = (char *)malloc(strlen($2) + strlen($4) + 15);
                sprintf($$, "do {\n%s\n} while(%s);\n", $2, $4);
            };

while_loop: WHILE condition statements {  // Removed the comma here
                $$ = (char *)malloc(strlen($2) + strlen($3) + 15);
                sprintf($$, "while(%s){\n%s\n}\n", $2, $3);
            };
for_loop: CREATE LOOP ID ASSIGN NUM UNTIL condition STEP expression BLBODY block {$$=malloc(strlen($5)+strlen($7)+strlen($9)+strlen($11)+15); sprintf($$,"for(%s=%s;%s;%s=%s){\n%s\n}\n",$3,$5,$7,$3,$9,$11);};


condition: expression LT expression { 
                $$ = (char *)malloc(strlen($1) + strlen($3) + 5);
                sprintf($$, "%s < %s", $1, $3); 
            }
         | expression GT expression { 
                $$ = (char *)malloc(strlen($1) + strlen($3) + 5);
                sprintf($$, "%s > %s", $1, $3); 
            }
         | expression LE expression { 
                $$ = (char *)malloc(strlen($1) + strlen($3) + 5);
                sprintf($$, "%s <= %s", $1, $3); 
            }
         | expression GE expression { 
                $$ = (char *)malloc(strlen($1) + strlen($3) + 5);
                sprintf($$, "%s >= %s", $1, $3); 
            }
         | expression EQ expression { 
                $$ = (char *)malloc(strlen($1) + strlen($3) + 5);
                sprintf($$, "%s == %s", $1, $3); 
            }
         | expression NE expression { 
                $$ = (char *)malloc(strlen($1) + strlen($3) + 5);
                sprintf($$, "%s != %s", $1, $3); 
            }
         | expression {$$=strdup($1);}
;
if_statement: a1 a2 a3 { $$=malloc(strlen($1)+strlen($2)+strlen($3)); sprintf($$,"%s%s%s",$1,$2,$3);};
a1: IF condition THEN block {$$=malloc(strlen($2)+strlen($4)+15); sprintf($$,"if(%s){\n%s\n}\n",$2,$4);};
a2: ELIF condition THEN block a2 {$$=malloc(strlen($2)+strlen($4)+15); sprintf($$,"else if(%s){\n%s\n}\n%s",$2,$4,$5);}
| {$$=strdup("");}
;
a3: ELSE block {$$=malloc(strlen($2)+15); sprintf($$,"else{\n%s\n}\n",$2);}
| {$$=strdup("");}
;

DOM: CREATE BUTTON TEXT STRING { 
    $$ = (char*)malloc(strlen($4) + 100);
    sprintf($$, "document.body.appendChild(document.createElement('button').innerHTML=%s);\n", $4);
}
| CREATE DIVC DID STRING TEXT STRING {
    $$ = (char*)malloc(strlen($4)+strlen($6)+ 100);
    sprintf($$, "document.body.appendChild((document.createElement('div').id=%s).innerHTML=%s);\n", $4,$6);}
| CREATE CLASS STRING ID  {
    $$ = (char *)malloc(strlen($3) + strlen($4) + 50); // Adjust memory allocation size if needed
    sprintf($$, "document.getElementById('%s').classList.add(%s);", $4, $3);
}
| SET attribute elements ID STRING {
    $$ = (char *)malloc(strlen($3) + strlen($5) + 100);
    sprintf($$, "document.%s('%s').%s = %s;\n", $3,$4,$2,$5);
}
;
attribute: HTML { $$=(char *)malloc(20); sprintf($$,"innerHTML"); }
| COLOR { $$=(char *)malloc(20); sprintf($$,"style.color"); }
;
elements: DID { $$=(char *) malloc(20); sprintf($$,"getElementById"); }
| CLASS { $$=(char *) malloc(20); sprintf($$,"getElementByClassName"); }
| TAG  { $$=(char *) malloc(20); sprintf($$,"getElementByTagName"); }
;
mouse_event: DO statements WHEN ONMOUSEOVER ID {
    $$ = (char *)malloc(strlen($2) + strlen($5) +100);
    sprintf($$, "document.querySelector('#%s').addEventListener('mouseover', function() {\n%s});\n", $5, $2);
}
| DO statements WHEN ONCLICK ID {
    $$ = (char *)malloc(strlen($2) + strlen($5) + 50);
    sprintf($$, "document.querySelector('%s').onclick = function() {\n%s};\n", $5, $2);
}
;

%%
void yyerror(const char *s) {
    printf("Error: %s\n", s);
}

int main() {
    yyparse();
}
