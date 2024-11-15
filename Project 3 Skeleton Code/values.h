// CMSC 430
// Duane J. Jarc

// This file contains function definitions for the evaluation functions

typedef char* CharPtr;
enum Operators {LESS, LESSOREQUAL, EQUAL, GREATEROREQUAL, 
    GREATER, NOTEQUAL, ADD, MULTIPLY, DIVIDE, SUBTRACT, EXPONENT, REMAINDER};

int evaluateReduction(Operators operator_, int head, int tail);
int evaluateRelational(int left, Operators operator_, int right);
int evaluateArithmetic(int left, Operators operator_, int right);

