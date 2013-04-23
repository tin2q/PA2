/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */
extern void fatal_error(char*);
char lookup_escape(char c)
{
	switch (c)
	{
		case 'n':
			return '\n';
		case 'b':
			return '\b';
		case 'r':
			return '\r';
		case 'f':
			return '\f';
		default:
			return c;
	}
}
%}

/*
 * Define names for regular expressions here.
 */
QUOTE						\"
DARROW          			=>
DIGIT						[0-9]
OCOMMENT				\(\*
CCOMMENT				\*\)
COMMENT					--
NEWLINE					[\n]
WHITE						[ \t\r\f]
LE								<=
ASSIGN					<-
IDTAIL						[a-zA-Z_0-9]
BRACKET					[\(\)\{\}]
OP							[+\-\*/<\.@~=]
COLA						[;\:,]
ILLEGAL					[^{IDTAIL}{BRACKET}{OP}{WHITE}{NEWLINE}{QUOTE}]
%%
 /*
  *  Nested comments
  */
{COMMENT}.*{NEWLINE}		{  ++curr_lineno;  }
{OCOMMENT} {
	register int c;
	int nesting = 0;	// Zero nesting = just one level of commenting.
	int lookahead = 0;	// To decide whether to nest.
	while("infinity")
	{
		//printf("Nesting's value is %d; c is %c; line is %d; lookahead is %d\n", nesting, c, curr_lineno, lookahead);
		while ((c = yyinput()) != '*' && c != EOF && c != '(' && c != ')')
		{
			//printf("c, dumping: %c\n", c);
			if (c == '\n') ++curr_lineno;
		}
		if (c == '*')
		{
			//printf("Found a star\n");
			while ((c = yyinput()) == '*');
			//printf(" After star-finding: %c; line %d\n", c, curr_lineno);
			if (lookahead)
			{
				//printf("Entered lookahead\n");
				++nesting;
				lookahead = 0;
			}
			if (c == ')')
			{
				//printf("Entered close paren\n");
				--nesting;
				if (nesting < 0)
					break;
				// Level 0 corresponds to no nesting, so less than 0 means we're done with comments.
			}
			else if (c == '\n') ++curr_lineno;
		}
		else if (c == '(')
				lookahead = 1;
		else if (c == ')')
				lookahead = 0;
		else if (c == EOF)
		{
			yylval.error_msg = "EOF in comment";
			return ERROR;
		}
	}
}
{CCOMMENT}		{  yylval.error_msg = "Unmatched *)"; return ERROR; }
	/* For when you find *) just floating there. */

 /*
  *  The multiple-character operators.
  */
{DARROW}		{ return (DARROW); }
{ASSIGN}		{ return (ASSIGN); }
{LE}				{return (LE); }

 /*
  * Keywords are case-insensitive except for the values true and false,
  * which must begin with a lower-case letter. That's why they're written as [cC].
  * Note that we couldn't use flex's -i option because some parts of the language
  * are very case-sensitive, like identifiers.
  */
[cC][lL][aA][sS][sS]							{ return CLASS; } 
[eE][lL][sS][eE]									{ return ELSE; }
f[aA][lL][sS][eE]								{ yylval.boolean = 0; return BOOL_CONST; }
[fF][iI]												{ return FI; }
[iI][fF]												{ return IF; }
[iI][nN]												{ return IN; }
[iI][nN][hH][eE][rR][iI][tT][sS]			{ return INHERITS; }
[iI][sS][vV][oO][iI][dD]						{ return ISVOID; }
[lL][eE][tT]										{ return LET; }
[lL][oO][oO][pP]									{ return LOOP; }
[pP][oO][oO][lL]									{ return POOL; }
[tT][hH][eE][nN]								{ return THEN; }
[wW][hH][iI][lL][eE]							{ return WHILE; }
[cC][aA][sS][eE]									{ return CASE; }
[eE][sS][aA][cC]									{ return ESAC; }
[nN][eE][wW]									{ return NEW; }
[oO][fF]											{ return OF; }
[nN][oO][tT]										{ return NOT; }
t[rR][uU][eE]										{ yylval.boolean = 1; return BOOL_CONST; }

 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for 
  *  \n \t \b \f, the result is c.
  *
  */
{QUOTE} 	{
	register int c;
	int lookahead = 0; int pos;
		// The routine we pass the string to below takes care of the null terminator, so we
		// can go right up to the edge of MAX_STR_CONST.
	for (pos = 0; (c = yyinput()) != '"' && pos <= MAX_STR_CONST; pos++)
	{
		//printf("%c %d\n", c, pos);
		if (c == '\\' && !lookahead)
		{
			//printf("Looking at backslash\n");
			lookahead = 1;
			--pos;	// We didn't add to the string buffer.
		}
		else if (lookahead && c != '\n')
		{
			//printf("Looking at not newline\n");
			char la = lookup_escape(c);
			string_buf[pos] = la;
			lookahead = 0;
		}
		else if (c == '\n')
		{
			//printf("Looking at newline\n");
			--pos;
			++curr_lineno;	// It's a newline, so we still moved ahead either way.
			if (lookahead)
			{
				//printf("Looking ahead\n");
				lookahead = 0;
			}
			else
			{
				while ((c = yyinput()) != '\n');		// Go to next line.
				yylval.error_msg = "Unterminated string constant";
				++curr_lineno;							
					// for the newline we just ate to get to the next uncontaminated line. Actually gets
					// one line ahead of the problem, but retains correct line numbers for everything that
					// comes after.
				return ERROR;
			}
		}
		else if (c == EOF || c == '\0')
		{
			yylval.error_msg = (c == EOF ? "EOF in string constant" : 
				"String contains null character");
			return ERROR;
		}
		else
		{
			//printf("Adding\n");
			string_buf[pos] = c;
		}
	} // End for
	if (pos <= MAX_STR_CONST)
	{
		yylval.symbol = new StringEntry(string_buf, pos, 22);
		return STR_CONST;		
	}
	else
	{
		yylval.error_msg = "String constant too long";
		return ERROR;
	}
}

  /* 0 alone is special-cased because the other rule covers all integer constant cases except for
  	 0 alone, without allowing leading zeros. If leading zeros were allowed, we could encapsulate all
  	 the cases into the first rule.*/
[1-9]{DIGIT}*			{ yylval.symbol = new IntEntry(yytext, yyleng, 22); return INT_CONST; }
0								{ yylval.symbol = new IntEntry(yytext, yyleng, 22); return INT_CONST; }
[a-z]{IDTAIL}*			{yylval.symbol = new IdEntry(yytext, yyleng, 22); return OBJECTID; }
[A-Z]{IDTAIL}*			{yylval.symbol = new IdEntry(yytext, yyleng, 22); return TYPEID; }
{NEWLINE}				{ ++curr_lineno; }
{WHITE}					{ }

	/* Separators and terminators.  */
{BRACKET}			{ return *yytext; }
{COLA}				{ return *yytext; }
	/* Operators */
{OP}					{ return *yytext; }
	/* What to do when something illegal appears. */
{ILLEGAL} 		{ 
	/*char* err_msg = new char[50];
	sprintf(err_msg, "Illegal character %c encountered at line %d; exiting\n", *yytext, curr_lineno);
		I just like this as an example of how to do this sort of thing in C. */
  yylval.error_msg = yytext;
  return ERROR; 	
  //fatal_error((char*)"");
		// Shut up the compiler that wants a non-const char pointer with the cast.
} 
	/* It thinks the comment mark is some regular expression matching zero or more /s, but that can be
		zero-length so it complains. That's why we need the tab before the comment. Similarly,
		it must think that // is a regular expression looking for two forward slashes, and complains. */
%%
