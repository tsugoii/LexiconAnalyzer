/* Compiler Theory and Design
   Dr. Duane J. Jarc */

/* This file contains flex input file */

%{
#include <stdio.h>
#include <string.h>

#include "listing.h"
#include "tokens.h"

int COMMENT=0;
int cnt=0;

%}

%option noyywrap

ws		[ \t\r]+
comment		\-\-.*\n
line		[\n]
id		[A-Za-z][A-Za-z0-9]*
digit		[0-9]
int		{digit}+
real		{int}.{int}[+-][{eE}{int}]
punc		[\(\),:;]
comment2	[//].*\n
opr		[+*-/]
bool		[true|false]
sem1		{int}={int}{opr}{int}
sem2		{real}={real}{opr}{real}

%%
#.* { printf("\n%s is a PREPROCESSOR DIRECTIVE",yytext);}
{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine();}
{line}		{ ECHO; nextLine();}
"<"		{ ECHO; return(RELOP); }
"<="		{ ECHO; return(RELOP); }
">"		{ ECHO; return(RELOP); }
">="		{ ECHO; return(RELOP); }
"="		{ ECHO; return(RELOP); }
"/="		{ ECHO; return(RELOP); }
"!"		{ ECHO; return(NOTOP); }
"+"		{ ECHO; return(ADDOP); }
"*"		{ ECHO; return(MULOP); }
"/"		{ ECHO; return(MULOP); }
"=>"		{ ECHO; return(ARROW); }
"**"		{ ECHO; return(EXPOP); }
rem		{ ECHO; return(REMOP); }
begin		{ ECHO; return(BEGIN_); }
boolean		{ ECHO; return(BOOLEAN); }
end		{ ECHO; return(END); }
endreduce	{ ECHO; return(ENDREDUCE); }
function	{ ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
is		{ ECHO; return(IS); }
reduce		{ ECHO; return(REDUCE); }
returns		{ ECHO; return(RETURNS); }
and		{ ECHO; return(ANDOP); }
case		{ ECHO; return(CASE); }
endcase		{ ECHO; return(ENDCASE); }
if		{ ECHO; return(IF); }
else		{ ECHO; return(ELSE); }
endif		{ ECHO; appendError(SYNTAX, yytext); }
endif;		{ ECHO; return(ENDIF); }
others		{ ECHO; return(OTHERS); }
real		{ ECHO; return(REAL); }
then		{ ECHO; return(THEN); }
when		{ ECHO; return(WHEN);  }
{id}		{ ECHO; return(IDENTIFIER);  }
{int}		{ ECHO; return(INT_LITERAL); }
{bool}		{ ECHO; return(BOOL_LITERAL); }
{real}		{ ECHO; return(REAL_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
{sem1} 		{ ECHO; appendError(GENERAL_SEMANTIC, yytext); }
{sem2} 		{ ECHO; appendError(GENERAL_SEMANTIC, yytext); }
{comment2}	{ ECHO; printf("Single Line Comment"); }
.		{ ECHO; appendError(LEXICAL, yytext); }
%%



int main()
{
	firstLine();
	
	FILE *file = fopen("d:\templ\lexemes.txt", "wa"); 
	int token = yylex();
	while (token!=END)
	{
	 
		fprintf(file, "%d %s\n", token, yytext);
		
		//printf( "token printed %d %s\n", token, yytext);
		token = yylex();
	}
	lastLine();
	fclose(file);
	getch();
	return 0;
}
