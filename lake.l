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

bool {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 260);
    charNum = charNum + 4;
    return 260;
}

int {
   this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 261);
   charNum = charNum + 3;
   return 261;
}

void {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 262);
  charNum = charNum + 4;
  return 262;
}

true {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 263);
  charNum = charNum + 4;
  return 263;
}

false {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 264);
  charNum = charNum + 5;
  return 264;
}

read {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 266);
  charNum = charNum + 4;
  return 266;
}

write {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 267);
  charNum = charNum + 5;
  return 267;
}

if {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 268);
  charNum = charNum + 2;
  return 268;
}

else {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 269);
  charNum = charNum + 4;
  return 269;
}

while {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 270);
  charNum = charNum + 5;
  return 270;
}

return {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 271);
  charNum = charNum + 6;
  return 271;
}


//identifier
ID | _ . (ID | DIGIT | _)* {}

//string literal
"*" {}

"{" {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 275);
  charNum++;
  return 275;
}

"}" {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 276);
  charNum++;
  return 276;
}

"(" {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 277);
  charNum++;
  return 277;
}

")" {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 278);
  charNum++;
  return 278;
}

"[" {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 279);
  charNum++;
  return 279;
}

"]" {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 280);
  charNum++;
  return 280;
}

";" {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 281);
  charNum++;
  return 281;
}

"," {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 282);
  charNum++;
  return 282;
}

"." {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 283);
  charNum++;
  return 283;
}

"++" {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 284);
  charNum++;
  return 284;
}

"--" {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 285);
  charNum++;
  return 285;
}

"*" {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 288);
  charNum++;
  return 288;
}

"/" {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 289);
  charNum++;
  return 289;
}

"!" {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 290);
  charNum++;
  return 290;
}

"==" {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 293);
  charNum = charNum + 2;
  return 293;
}

"!=" {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 294);
  charNum = charNum + 2;
  return 294;
}

"<" {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 295);
  charNum++;
  return 295;
}

">" {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 296);
  charNum++;
  return 296;
}

"<=" {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 297);
  charNum = charNum + 2;
  return 297;
}

">=" {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 298);
  charNum = charNum + 2;
  return 298;
}

"=" {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 299);
  charNum++;
  return 299;
}

"&&" {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 291);
  charNum = charNum + 2;
  return 291;
}

"||" {
  this->yylval->tokenValue = new NoArgToken(lineNum, charNum, 292);
  charNum = charNum + 2;
  return 292;
}

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
