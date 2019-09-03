%{
#include <string>
#include <limits.h>

/* Provide custom yyFlexScanner subclass and specify the interface */
#include "scanner.hpp"
#undef  YY_DECL
#define YY_DECL int lake::Scanner::yylex( lake::Parser::semantic_type * const lval )

/* define yyterminate as this instead of NULL */
#define yyterminate() return( TokenKind::END )

/* Exclude unistd.h for Visual Studio compatability. */
#define YY_NO_UNISTD_H

/* typedef to make the reference to token kinds shorter */
using TokenKind = lake::Parser::token;

%}

%option debug
%option nodefault
%option yyclass="lake::Scanner"
%option noyywrap
%option c++

DIGIT [0-9]
ID [a-z] | [A-Z]


%%
%{          /** Code executed at the beginning of yylex **/
            yylval = lval;
%}

"+"		{
		// Keep track of the "kind" of token we matched. In this case,
		// it's a CROSS (aka the plus symbol). The full list of token
		// kinds is declared around line 197 of grammar.hh. The testing
		// functionScanner::outputTokens also indicates what each token
		// represents (declared in scanner.cpp line 9)
		int tokenKind = TokenKind::CROSS;

		//Instatiate a token. There are 4 classes of tokens defined based on
		// - a literal string (StringLitToken)
		// - a literal integer (IntLitToken)
		// - an identifier (IDToken)
		// - a NoArg token (any other type)
		// The token object is a handy place to keep information about the
		// token (i.e. token metadata) such as the line and column on which
		// the token character started (which can be used later in debug
		// messages, etc).
		Token * token = new NoArgToken(lineNum, charNum, tokenKind);

		//Assign the token to a instance variable of the scanner.
		// (When Flex processes a .l file in C++ mode, it creates
		// a class called Scanner, which is a subclass of yyFlexScanner)
		// By assigning a value to this field, we put the token
		// metadata in a place where scanner's client program can find it.
		this->yylval->tokenValue = token;

		//Since we consumed 1 character, increase the column number by 1
		charNum++;

		//Let the scanner's client program know that a CROSS token
		// has been matched
		return tokenKind;
		}

"-" {
		//Essentially the same thing as CROSS, but without the verboes
		// comments so it doesn't look so scary.
		int tokenKind = TokenKind::DASH;
		this->yylval->tokenValue = new NoArgToken(lineNum, charNum, tokenKind);
		charNum++;
		return tokenKind;
		}

{DIGIT}+	{
		//TODO: The following computation of the integer
		// value does not check for overflow. It should do so.
		int intVal = atoi(yytext);


		//Note that the IntLitToken does not take a TokenKind argument
		// since it's implicitly known that the token represents an
		// INTLITERAL
		yylval->tokenValue = new IntLitToken(lineNum, charNum, intVal);

		//TODO: update the charNum count according to the number of
		// characters consumed.

		//As before, alert the client program that an INTLITERAL
		// token was matched
		return TokenKind::INTLITERAL;
		}

bool {}

int {}

void {}

true {}

false {}

read {}

write {}

if {}

else {}

while {}

return {}


//identifier
ID | _ . (ID | DIGIT | _)* {}

//string literal
"*" {}

{ {}

} {}

( {}

) {}

[ {}

] {}

; {}

, {}

"." {}

++ {}

-- {}

* {}

/ {}

! {}

== {}

!= {}

< {}

> {}

<= {}

>= {}

= {}

@ {}

&& {}

|| {}

\n		{
		//Update the line number, reset the columnNumber
		lineNum++;
		charNum = 0;
		}


.   {
		//TODO: Add the rest of the rules above this point so that legal characters
		// are properly accounted for.
		std::string msg = "Illegal character ";
		msg += yytext;
		error(lineNum,charNum,msg);
		charNum += yyleng;
    }
%%
