/* Compiler Theory and Design
   Duane J. Jarc */

%{

#include <iostream>
#include <string>
#include <vector>
#include <map>

using namespace std;

#include "values.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);

Symbols<int> symbols;

int result;
int expressionValue;
int caseValue;
bool caseFound;
int *argPtr;

%}

%define parse.error verbose

%union
{
	CharPtr iden;
	Operators oper;
	int value;
}

%token <iden> IDENTIFIER
%token <value> INT_LITERAL BOOL_LITERAL REAL_LITERAL

%token <oper> NOTOP ADDOP MULOP RELOP SUBOP DIVOP EXPOP REMOP
%token ANDOP OROP

%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS
%token <value> IF THEN ELSE ENDIF WHEN
%token <value> CASE OTHERS ARROW ENDCASE

%type <value> body statement_ statement reductions expression relation term
	factor primary variable case optional_case
%type <oper> operator

%%

function:	
	function_header optional_variable body {result = $3;} ;
	
function_header:	
	FUNCTION IDENTIFIER optional_parameter RETURNS type ';' ;

optional_parameter:
	optional_parameter ',' parameter |
	parameter |
	;
	
parameter:	
	IDENTIFIER ':' type {argPtr++;printf("%d",*argPtr);symbols.insert($1,*argPtr);};

optional_variable:
	optional_variable variable |
	;

variable:	
	IDENTIFIER ':' type IS statement_ {symbols.insert($1, $5);} ;

type:
	INTEGER |
	BOOLEAN ;

body:
	BEGIN_ statement_ END ';' {$$ = $2;} ;
    
statement_:
	statement ';' {$$ = $1;}|
	error ';' {$$ = 0;} ;
	
statement:
	expression |
	IF expression THEN statement_ ELSE statement_ ENDIF {$$ = $2 ? $4 : $6;}|
	CASE expression {expressionValue = $2;} IS optional_case OTHERS ARROW statement_ ENDCASE { $$ = caseFound ? caseValue : $8; } |
	REDUCE operator reductions ENDREDUCE {$$ = $3;};

operator:
	ADDOP | SUBOP |
	MULOP | DIVOP |
	REMOP | EXPOP;

case:
	WHEN INT_LITERAL ARROW statement_ {if(expressionValue == $2 && !caseFound){ caseValue = $4; caseFound = true;}};

optional_case:
	case optional_case | case;

reductions:
	reductions statement_ {$$ = evaluateReduction($<oper>0, $1, $2);}|
	{$$ = $<oper>0 == ADD ? 0 : 1;}

expression:
	expression ANDOP relation {$$ = $1 && $3;} |
	expression OROP relation {$$ = $1 || $3;} |
	NOTOP expression {$$ = $2 == 0;} |
 	relation ;

relation:
	relation RELOP term {$$ = evaluateRelational($1, $2, $3);} |
	term ;

term:
	term ADDOP factor {$$ = evaluateArithmetic($1, $2, $3);} |
	term SUBOP factor {$$ = evaluateArithmetic($1, $2, $3);} |
	factor ;
      
factor:
	factor MULOP primary {$$ = evaluateArithmetic($1, $2, $3);} |
	factor DIVOP primary {$$ = evaluateArithmetic($1, $2, $3);} |
	factor EXPOP primary {$$ = evaluateArithmetic($1, $2, $3);} |
	factor REMOP primary {$$ = evaluateArithmetic($1, $2, $3);} |
	primary ;

primary:
	'(' expression ')' {$$ = $2;} |
	INT_LITERAL | REAL_LITERAL | BOOL_LITERAL |
	IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;

%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char* argv[])    
{
	int args[argc-1];
	for(int i = 1 ; i < argc ; ++ i ) 
	{
		args[i] = atoi(argv[i]);
	}

	argPtr = args;

	firstLine();
	yyparse();
	if (lastLine() == 0)
		cout << "Result = " << result << endl;
	return 0;
} 
