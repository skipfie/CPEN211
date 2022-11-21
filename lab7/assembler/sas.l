%option nounput
%option noyywrap
%option yylineno
%x incl

%{
#include <iostream>
using namespace std;
#include "y.tab.h"

#define BUFF_SIZE 1024
char g_linebuf[BUFF_SIZE];
unsigned g_col = 0;
unsigned ntokens = 0;
unsigned g_line = 1;
#define TCW snprintf(g_linebuf+g_col,BUFF_SIZE-g_col,"%s",yytext); g_col+=strlen(yytext); 
#define TC TCW ntokens++;
int yyerror( const char *s );

#define MAX_INCLUDE_DEPTH 10
YY_BUFFER_STATE include_stack[MAX_INCLUDE_DEPTH];
int include_stack_ptr = 0;
%}

/*Regular expressions*/
alpha   [a-zA-Z]
numeric   [0-9]
hexalpha  [A-Fa-f]
alphanum  ({alpha}|{numeric})
hexdigit  ({numeric}|{hexalpha})
whitespaces [ \t]+

label ({alpha}({alphanum}|["_"])*)|([_]({alphanum}|["_"])+)
hexliteral  0x{hexdigit}+
binliteral  0b[01]+
decliteral  [-]?[0-9]+


%s IN_COMMENT

%%

{whitespaces}     {TCW; /*ignore whitespaces*/}
"//"[^\n]*        {TCW; /*commented line*/}
";"[^\n]*         {TCW; /*commented line*/}

%{/* Labels */%}
{label}[ \t]*[:]  {TC; yylval.string_value = strdup(yytext); return LABEL_DEF;}

%{/* Special Signs*/%}
".org"            {TC; return DOT_ORG;}
".section"        {TC; return DOT_SECTION;}
".text"           {TC; return DOT_TEXT;}
".data"           {TC; return DOT_DATA;}
".word"           {TC; return DOT_WORD;}
".globl"          {TC; return DOT_GLOBAL;}
".equ"            {TC; return DOT_EQU;}

".include"        BEGIN(incl) /* code for include from https://perso.esiee.fr/~najmanl/compil/Flex/flex_2.html --> */;
<incl>[\" \t]*      /* eat the whitespace and quote chars */
<incl>[^ \"\t\n]+   { /* got the include file name */
        if ( include_stack_ptr >= MAX_INCLUDE_DEPTH ) {
            fprintf( stderr, "Includes nested too deeply" );
            exit( 1 );
        }
        include_stack[include_stack_ptr++] = YY_CURRENT_BUFFER;
        if ( !yyin ) {
            printf( "ERROR ** could not open include file %s.", yytext );
            exit(1);
        }
        yy_switch_to_buffer( yy_create_buffer( yyin, YY_BUF_SIZE ) );
        BEGIN(INITIAL);
}

<<EOF>> {
        if ( --include_stack_ptr < 0 )
            {
            yyterminate();
            }

        else
            yy_switch_to_buffer(
                 include_stack[include_stack_ptr] );
        } /* <--- */

","               {TC; return ',';}
"["               {TC; return '[';}
"]"               {TC; return ']';}
"="               {TC; return '=';}
"#"               {TC; return '#';}


%{/* Control Flow Instructions */%}
B|b               {TC; return B;}
BEQ|beq           {TC; return BEQ;}
BNE|bne           {TC; return BNE;}
BLT|blt           {TC; return BLT;}
BLE|ble           {TC; return BLE;}
BLX|blx           {TC; return BLX;}
BL|bl             {TC; return BL;}
BX|bx             {TC; return BX;}
HALT|halt         {TC; return HALT;}

%{/* Move Instructions */%}
LDR|ldr           {TC; return LDR;}
STR|str           {TC; return STR;}

%{/* ALU Instructions */%}
ADD|add           {TC; return ADD;}
AND|and           {TC; return AND;}
CMP|cmp           {TC; return CMP;}

%{/* Move Instructions */%}
MOV|mov           {TC; return MOV;}
MVN|mvn           {TC; return MVN;}

%{/* nop Instructions */%}
NOP|nop           {TC; return NOP;}

%{/* shift operators */%}
LSL|lsl           {TC; return LSL;}
LSR|lsr           {TC; return LSR;}
ASR|asr           {TC; return ASR;}

%{/* Registers */%}
(r|R)[0-7]        {TC; yylval.string_value = strdup(yytext); return REGISTER;}
LR|lr             {TC; yylval.string_value = strdup(yytext); return REG_LR;}

{decliteral}      {TC; yylval.string_value = strdup(yytext); return DEC_NUMBER; }
{hexliteral}      {TC; yylval.string_value = strdup(yytext); return HEX_NUMBER; }
{binliteral}      {TC; yylval.string_value = strdup(yytext); return BIN_NUMBER; }
{label}           {TC; yylval.string_value = strdup(yytext); return LABEL;}

<INITIAL>{
"/*"  BEGIN(IN_COMMENT);
}
<IN_COMMENT>{
"*/"      BEGIN(INITIAL);
[^*\n]+   TCW; // eat comment in chunks
"*"       TCW; // eat the lone star
}

\n  {g_col=0; g_line++; return NEW_LINE;}

%%

extern char *g_filename;

int yyerror( const char *s )
{
  int i;
  fflush(stdout);
  if( s != NULL )
    printf("%s:%u: Syntax error:\n\n", g_filename, yylineno );
  printf("   %s\n", g_linebuf );
  printf("   ");
  unsigned error_col = g_col==0? (unsigned)strlen(g_linebuf) : g_col;

  for( i=0; i < error_col-1; i++ ) {
    if( g_linebuf[i] == '\t' ) printf("\t");
    else printf(" ");
  }
      
  printf("^\n\n");
  fflush(stdout);
  exit(1);
}
