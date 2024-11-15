/* Compiler Theory and Design
   Duane J. Jarc */

/* This file contains flex input file */

%{
#include <string>

using namespace std;

#include "values.h"
#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws		[ \t\r]+
comment		\-\-.*\n
real		{int}.{int}[+-][{eE}{int}]
bool		[true|false]
line		[\n]
id		[A-Za-z][A-Za-z0-9]*
digit		[0-9]
int		{digit}+
punc		[\(\),:;]
%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine();}
{line}		{ ECHO; nextLine();}
{bool}		{ ECHO; return(BOOL_LITERAL);}
{real}	{ ECHO; return(REAL_LITERAL);}
"=>"     { ECHO; return(ARROW);}
"<"		{ ECHO; yylval.oper = LESS; return(RELOP); }
"<="		{ ECHO; yylval.oper = LESSOREQUAL; return(RELOP); }
"="		{ ECHO; yylval.oper = EQUAL; return(RELOP); }
">="		{ ECHO; yylval.oper = GREATEROREQUAL; return(RELOP); }
">"		{ ECHO; yylval.oper = GREATER; return(RELOP); }
"!="		{ ECHO; yylval.oper = NOTEQUAL; return(RELOP); }
"+"		{ ECHO; yylval.oper = ADD; return(ADDOP); }
"*"		{ ECHO; yylval.oper = MULTIPLY; return(MULOP); }
"**"     { ECHO; yylval.oper = EXPONENT; return(EXPOP);}
"-"      { ECHO; yylval.oper = SUBTRACT; return(SUBOP); }
"/"      { ECHO; yylval.oper = DIVIDE; return(DIVOP); }
rem      { ECHO; yylval.oper = REMAINDER; return(REMOP);}
begin		{ ECHO; return(BEGIN_); }
boolean		{ ECHO; return(BOOLEAN); }
case     { ECHO; return(CASE);}
end		{ ECHO; return(END); }
endcase     { ECHO; return(ENDCASE);}
endif    { ECHO; return(ENDIF);}
endreduce	{ ECHO; return(ENDREDUCE); }
else     { ECHO; return(ELSE);}
function	{ ECHO; return(FUNCTION); }
if    { ECHO; return(IF);}
is    { ECHO; return(IS);}
integer		{ ECHO; return(INTEGER); }
reduce		{ ECHO; return(REDUCE); }
returns		{ ECHO; return(RETURNS); }
and		{ ECHO; return(ANDOP); }
or		{ ECHO; return(OROP); }
others      { ECHO; return(OTHERS);}
not		{ ECHO; return(NOTOP); }
then     { ECHO; return(THEN);}
when     { ECHO; return(WHEN);}
{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); 
			strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{int}		{ ECHO; yylval.value = atoi(yytext); return(INT_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
.		{ ECHO; appendError(LEXICAL, yytext); }

%%
