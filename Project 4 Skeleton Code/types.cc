// Compiler Theory and Design
// Duane J. Jarc

// This file contains the bodies of the type checking functions

#include <string>
#include <vector>

using namespace std;

#include "types.h"
#include "listing.h"

void checkAssignment(Types lValue, Types rValue, string message)
{
	if(lValue == REAL_TYPE && rValue == INT_TYPE)
		return;
	if (lValue != MISMATCH && rValue != MISMATCH && lValue != rValue)
		appendError(GENERAL_SEMANTIC, "Type Mismatch on " + message);
}

Types checkArithmetic(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left == BOOL_TYPE || right == BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Integer Type Required");
		return MISMATCH;
	}
	if (left == REAL_TYPE || right == REAL_TYPE)
		return REAL_TYPE;
	return INT_TYPE;
}

Types checkSameType(Types left, Types right, string message)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if(left == REAL_TYPE && right == INT_TYPE)
		return REAL_TYPE;
	if (left == right)
		return left;

	appendError(GENERAL_SEMANTIC, message);
	return MISMATCH;
}

Types checkNarrowing(Types left, Types right, string origin)
{
	if (left == REAL_TYPE && right == INT_TYPE)
		return REAL_TYPE;
	if (left == INT_TYPE && right == REAL_TYPE){
		appendError(GENERAL_SEMANTIC, "Narrowing " + origin);
		return MISMATCH;
	}
	return checkSameType(left, right, "Type mismatch at " + origin);
}

Types checkLogical(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left != BOOL_TYPE || right != BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Boolean Type Required");
		return MISMATCH;
	}
	return BOOL_TYPE;
}

Types checkRelational(Types left, Types right)
{
	if (checkArithmetic(left, right) == MISMATCH)
		return MISMATCH;
	return BOOL_TYPE;
}
