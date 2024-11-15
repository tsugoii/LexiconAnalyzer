/* Compiler Theory and Design */
/* Originally: Dr. Duane J. Jarc */
/* Modified by: Lily Forry */

%{

#include <string>

using namespace std;

#include "listing.h"

int yylex();
void yyerror(const char* message);

%}
%define parse.error verbose

%token IDENTIFIER
%token INT_LITERAL REAL_LITERAL BOOL_LITERAL
%token OROP
%token ANDOP
%token RELOP
%token ADDOP
%token MULOP REMOP
%token EXPOP
%token NOTOP
%token BEGIN_ BOOLEAN END 
%token ENDREDUCE FUNCTION INTEGER 
%token IS IF THEN
%token REAL REDUCE RETURNS 
%token ELSE ENDIF CASE 
%token OTHERS ARROW ENDCASE 
%token WHEN

%%
 
function:	
	function_header optional_variable body ;
	
function_header:	
	FUNCTION IDENTIFIER optional_parameters RETURNS type ';' ;

optional_variable:
	optional_variable variable |
	;

optional_parameters:
	parameter optional_parameter |
	parameter |
	;

variable:
	IDENTIFIER ':' type IS statement_ ;

parameter:
	IDENTIFIER ':' type ;

optional_parameter:
	',' parameter optional_parameter |
	;
	
type:
	INTEGER | REAL |
	BOOLEAN ;

body:
	BEGIN_ statement END ';' ;
    
statement_:
	statement |
	error ';' ;
	
statement:
	expression ';' |
	REDUCE operator reductions ENDREDUCE ';' |
	IF expression THEN statement_ ELSE statement_ ENDIF ';' |
	CASE expression IS optional_case OTHERS ARROW statement_ ENDCASE ';' ;

reductions:
	reductions statement_ |
	;

operator:
	ADDOP |
	MULOP ;

case:
	WHEN INT_LITERAL ARROW statement_ ;

optional_case:
	optional_case case |
	;
		    
expression:
	'(' expression ')' |
	expression binary_operator expression |
	NOTOP expression | INT_LITERAL | REAL_LITERAL | 
	BOOL_LITERAL | IDENTIFIER ;

binary_operator:
	ADDOP | MULOP | REMOP | EXPOP | 
	RELOP | ANDOP | OROP ;
    
%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])    
{
	firstLine();
	yyparse();
	lastLine();
	return 0;
} 
