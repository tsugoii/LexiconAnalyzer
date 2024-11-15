// Compiler Theory and Design
// Origially by: Dr. Duane J. Jarc
// Modified by: Lily Forry

// This file contains the bodies of the functions that produces the compilation
// listing

#include <cstdio>
#include <string>
#include <vector>
#include <iostream>

using namespace std;

#include "listing.h"

static int lineNumber;
static string error = "";
static int totalErrors = 0;
static int lexicalErrors;
static int syntaxErrors;
static int semanticErrors;

void firstLine()
{
	lineNumber = 1;
	printf("\n%4d  ",lineNumber);
}

void nextLine()
{
	displayErrors();
	lineNumber++;
	printf("%4d  ",lineNumber);
}

int lastLine()
{
	printf("\r");
	displayErrors();
	printf("\n");
	if (totalErrors != 0) {
		printf("\nLexical Errors: %d", lexicalErrors);
		printf("\nSyntax Errors: %d", syntaxErrors);
		printf("\nSemantic Errors: %d", semanticErrors);
		printf("\nTotal Errors: %d", totalErrors); }
	else if (totalErrors == 0)
		printf("Compiled Successfully");
	else
		printf("You shouldn't hit this");
	printf("\n");
	return totalErrors;
}
    
void appendError(ErrorCategories errorCategory, string message)
{
	string messages[] = {"Lexical Error, Invalid Character ", "Syntax Error",
		"Semantic Error, Here", "Semantic Error, Duplicate Identifier: ",
		"Semantic Error, Undeclared "};

	error += messages[errorCategory] + message;
	if (errorCategory == 0)
		lexicalErrors++;
	else if (errorCategory == 1)
		syntaxErrors++;
	else if (errorCategory < 2 && errorCategory < 4)
		semanticErrors++;
	else
		printf("You shouldn't of hit this");
	totalErrors++;
}

void displayErrors()
{
	if (error != "")
		printf("%s\n", error.c_str());
	error = "";
}