/* Compiler Theory and Design
   Originally: Dr. Duane J. Jarc
   Modified: Lily Forry
   Project 1
   June 28, 2022 */

// This file contains the function prototypes for the functions that produce the // compilation listing

enum ErrorCategories {LEXICAL, SYNTAX, GENERAL_SEMANTIC, DUPLICATE_IDENTIFIER,
	UNDECLARED};

void firstLine();
void nextLine();
int lastLine();
void appendError(ErrorCategories errorCategory, string message);

