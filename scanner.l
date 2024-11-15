/* Compiler Theory and Design
Originally by: Dr. Duane J. Jarc
Modified by: Lily Forry */

/* This file contains flex input file */

%{
#include <cstdio>
#include <string>

using namespace std;

#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws			[ \t\r]+
comment		\-\-.*\n
comment2	[//].*\n
real		{int}.{int}[+-][{eE}{int}]
bool		[true|false]
line		[\n]
digit		[0-9]
relop       ((\/?=|[><]?=<?)|([><]))
id			[A-Za-z_][A-Za-z0-9]*
int			{digit}+
punc		[\(\),:;]
%%

{ws}	{ ECHO;}
{comment}	{ ECHO; nextLine();}
{comment2}	{ ECHO; nextLine();}
{bool}		{ ECHO; return(BOOL_LITERAL);}
{real}	{ ECHO; return(REAL_LITERAL);}
{line}	{ ECHO; nextLine();}
{relop}     { ECHO; return(RELOP); }
"+"		{ ECHO; return(ADDOP); }
"-"		{ ECHO; return(ADDOP); }
"*"		{ ECHO; return(MULOP); }
"/"		{ ECHO; return(MULOP); }
rem		{ ECHO; return(REMOP); }
"**"	{ ECHO; return(EXPOP); }
"=>"	{ ECHO; return(ARROW); }
and		{ ECHO; return(ANDOP); }
begin	{ ECHO; return(BEGIN_); }
boolean	{ ECHO; return(BOOLEAN); }
case	{ ECHO; return(CASE); }
else 	{ ECHO; return(ELSE); }
end		{ ECHO; return(END); }
endcase	{ ECHO; return(ENDCASE); }
endif	{ ECHO; return(ENDIF); }
endreduce	{ ECHO; return(ENDREDUCE); }
function	{ ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
if		{ ECHO; return(IF); }
is		{ ECHO; return(IS); }
not		{ ECHO; return(NOTOP); }
or		{ ECHO; return(OROP); }
others	{ ECHO; return(OTHERS); }
real 	{ ECHO; return(REAL); }
reduce	{ ECHO; return (REDUCE); }
returns	{ ECHO; return(RETURNS); }
then	{ ECHO; return(THEN); }
when	{ ECHO; return(WHEN);}
{id}	{ ECHO; return(IDENTIFIER);}
{int}	{ ECHO; return(INT_LITERAL);}
{punc}	{ ECHO; return(yytext[0]);}
.		{ ECHO; appendError(LEXICAL, yytext); }
%%