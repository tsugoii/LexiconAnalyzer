/* Compiler Theory and Design
   Duane J. Jarc */

/* This file contains flex input file */

%{
#include <string>

using namespace std;

#include "types.h"
#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws		[ \t\r]+
comment		\-\-.*\n
real		{int}.{int}([+-][{eE}{int}])?
line		[\n]
id		[A-Za-z][A-Za-z0-9]*
digit		[0-9]
int		{digit}+
punc		[\(\),:;]
%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine();}
{line}		{ ECHO; nextLine();}
{real}	{ ECHO; yylval.type = REAL_TYPE; if(print) printf(" (REAL_LITERAL) "); return(REAL_LITERAL);}
"=>"     { ECHO; return(ARROW);}
"<"		{ ECHO; return(RELOP); }
"<="		{ ECHO; return(RELOP); }
"="		{ ECHO; return(RELOP); }
">="		{ ECHO; return(RELOP); }
">"		{ ECHO; return(RELOP); }
"!="		{ ECHO; return(RELOP); }
"+"		{ ECHO; return(ADDOP); }
"*"		{ ECHO; return(MULOP); }
"**"     { ECHO; return(EXPOP);}
"-"      { ECHO; return(SUBOP); }
"/"      { ECHO; return(DIVOP); }
"true"   { ECHO; yylval.type = BOOL_TYPE; if(print) printf(" (BOOL_LITERAL) "); return(BOOL_LITERAL);}
"false"  { ECHO; yylval.type = BOOL_TYPE; if(print) printf(" (BOOL_LITERAL) "); return(BOOL_LITERAL);}
rem      { ECHO; return(REMOP);}
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
real     { ECHO; return(REAL);}
reduce		{ ECHO; return(REDUCE); }
returns		{ ECHO; return(RETURNS); }
and		{ ECHO; return(ANDOP); }
or		{ ECHO; return(OROP); }
others      { ECHO; return(OTHERS);}
not		{ ECHO; return(NOTOP); }
then     { ECHO; return(THEN);}
when     { ECHO; return(WHEN);}
{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{int}		{ ECHO; yylval.type = INT_TYPE; if(print) printf(" (INT_LITERAL) "); return(INT_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
.		{ ECHO; appendError(LEXICAL, yytext); }

%%
