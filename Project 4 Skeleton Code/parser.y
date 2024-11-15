/* Compiler Theory and Design
   Duane J. Jarc */

%{

#include <string>
#include <vector>
#include <map>

using namespace std;

#include "types.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);

Symbols<Types> symbols;
int expressionValue;
int caseValue;
bool caseFound;

%}

%define parse.error verbose

%union
{
	CharPtr iden;
	Types type;
	int value;
}

%token <iden> IDENTIFIER
%token <type> INT_LITERAL BOOL_LITERAL REAL_LITERAL FUNCTION

%token <oper> NOTOP ADDOP MULOP RELOP SUBOP DIVOP EXPOP REMOP
%token OROP ANDOP
%token BEGIN_ BOOLEAN END ENDREDUCE  INTEGER IS REDUCE RETURNS REAL
%token <type> IF THEN ELSE ENDIF WHEN
%token <type> CASE OTHERS ARROW ENDCASE

%type <type> type body statement_ statement reductions expression relation term
	factor primary variable case optional_case parameter function function_header
%type <oper> operator

%%

function:	
	function_header optional_variable body {$$ = checkNarrowing($1,$3,"function return");};
	
function_header:
	FUNCTION IDENTIFIER parameter RETURNS type ';' {$$ = $5;}| 
	FUNCTION IDENTIFIER RETURNS type ';' {$$ = $4;};
	
parameter:	
	IDENTIFIER ':' type {symbols.insert($1,$3); $$ = $3;};

optional_variable:
	optional_variable variable |
	;

variable:	
	IDENTIFIER ':' type IS statement_ 
		{if (symbols.find($1, $$)) {
			appendError(DUPLICATE_IDENTIFIER, $1);
		}
		else {
			checkAssignment($3, $5, "Variable Initialization");
			symbols.insert($1, $3);
			$$ = checkNarrowing($3,$5,"variable assignment");
		}};

type:
	INTEGER {$$ = INT_TYPE;} |
	REAL {$$ = REAL_TYPE;} |
	BOOLEAN {$$ = BOOL_TYPE;} ;

body:
	BEGIN_ statement_ END ';' {$$ = $2;};
    
statement_:
	statement ';' {$$ = $1;} |
	error ';' {$$ = MISMATCH;} ;
	
statement:
	expression {$$ = $1;} |
	IF expression THEN statement_ ELSE statement_ ENDIF {$$ = checkSameType($2,BOOL_TYPE, "If expression must be a boolean"); if($$ != MISMATCH) $$ = checkSameType($4,$6, "If statements have different types");} |
	CASE expression IS optional_case OTHERS ARROW statement_ ENDCASE {$$ = checkSameType($2, INT_TYPE, "Case expression not an integer.");}|
	REDUCE operator reductions ENDREDUCE {$$ = $3;};

operator:
	ADDOP | SUBOP |
	MULOP | DIVOP |
	REMOP | EXPOP;

case:
	WHEN INT_LITERAL ARROW statement_ {$$ = $4;};

optional_case:
	case optional_case {$$ = checkSameType($1, $2, "Case statements type mismatch.");}| 
	case {$$ = $1;};

reductions:
	reductions statement_ {$$ = checkArithmetic($1, $2);} |
	{$$ = INT_TYPE;} ;
		    
expression:
	expression ANDOP relation {$$ = checkLogical($1, $3);} |
	expression OROP relation {$$ = checkLogical($1, $3);} |
	NOTOP expression {$$ = checkLogical($2, $2);} |
	relation {$$ = $1;} ;

relation:
	relation RELOP term {$$ = checkRelational($1, $3);}|
	term {$$ = $1;} ;

term:
	term ADDOP factor {$$ = checkArithmetic($1, $3);} |
	term SUBOP factor {$$ = checkArithmetic($1, $3);} |
	factor {$$ = $1;} ;
      
factor:
	factor MULOP primary  {$$ = checkArithmetic($1, $3);} |
	factor DIVOP primary  {$$ = checkArithmetic($1, $3);} |
	factor EXPOP primary  {$$ = checkArithmetic($1, $3);} |
	factor REMOP primary  {$$ = checkSameType(INT_TYPE,$1, "rem operands must be integers"); $$ = checkSameType(INT_TYPE, $3, "rem operands must be integers");} |
	primary {$$ = $1;} ;
	
primary:
	'(' expression ')' {$$ = $2;} |
	INT_LITERAL {$$ = INT_TYPE;} |
	REAL_LITERAL {$$ = REAL_TYPE;} | 
	BOOL_LITERAL {$$ = BOOL_TYPE;} |
	IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;
    
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
