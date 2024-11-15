// Compiler Theory and Design
// Duane J. Jarc

// This file contains type definitions and the function
// prototypes for the type checking functions

typedef char* CharPtr;

enum Types {MISMATCH, INT_TYPE, BOOL_TYPE, REAL_TYPE};

void checkAssignment(Types lValue, Types rValue, string message);
Types checkNarrowing(Types left, Types right, string origin);
Types checkArithmetic(Types left, Types right);
Types checkSameType(Types left, Types right, string message);
Types checkLogical(Types left, Types right);
Types checkRelational(Types left, Types right);