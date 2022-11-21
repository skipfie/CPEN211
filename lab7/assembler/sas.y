%{
#include <stdio.h>
#include <string.h>
#include <assert.h>
#include "sas.h"

using namespace std;
    
// lex functions/global variables that are accessed from parser (this file)
extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int yydebug;
extern int yy_flex_debug;
extern int linenum;
extern int yyerror( const char *s );

extern assembler asmblr_obj; // parser object
%}

%union {
  int   integer_value;
  float float_value;
  char *string_value;
}

%token DOT_ORG DOT_SECTION DOT_TEXT DOT_DATA DOT_WORD DOT_EQU DOT_TEXT DOT_GLOBAL
%token B BEQ BNE BLT BLE BL BLX BX
%token LDR STR
%token ADD AND CMP MVN
%token MOV
%token LSL LSR ASR
%token NOP HALT DLLR NUMB PERC NEW_LINE
%token <string_value> REGISTER REG_LR LABEL LABEL_DEF 
%token <string_value> DEC_NUMBER BIN_NUMBER HEX_NUMBER

%type <integer_value> number

%%

assembly_program:     directive assembly_program 
                    | instruction assembly_program 
                    | NEW_LINE assembly_program
                    | /* empty */
                    ;

directive:            DOT_ORG number           { asmblr_obj.set_addr($2); }
                    | DOT_SECTION DOT_TEXT     { asmblr_obj.set_section(".text"); }
                    | DOT_SECTION DOT_DATA     { asmblr_obj.set_section(".data"); }
                    | DOT_WORD number          { asmblr_obj.set_word($2); }
                    | DOT_TEXT                 { asmblr_obj.set_section(".text"); }
                    | DOT_GLOBAL LABEL         { asmblr_obj.set_entry($2); }
                    | DOT_EQU LABEL ',' number { asmblr_obj.add_constant($2,$4); }
                    ;

instruction:          assembly_instruction {asmblr_obj.end_inst();} 
                    | label_stmt 
                    ;           

assembly_instruction: control_flow_inst 
                    | alu_inst 
                    | memory_inst 
                    | NOP  {asmblr_obj.set_inst("NOP");}
                    | HALT {asmblr_obj.set_inst("HALT");}
                    ;

control_flow_inst:    pcrel_branch immediate 
                    | indirect_branch reg0
                    ;

pcrel_branch        : BEQ {asmblr_obj.set_inst("BEQ");}
                    | BNE {asmblr_obj.set_inst("BNE");}
                    | BLT {asmblr_obj.set_inst("BLT");}
                    | BLE {asmblr_obj.set_inst("BLE");}
                    | BL  {asmblr_obj.set_inst("BL");}
                    | B   {asmblr_obj.set_inst("B");}
                    ;

indirect_branch:      BX  {asmblr_obj.set_inst("BX");}
                    | BLX {asmblr_obj.set_inst("BLX");}
                    ;

alu_inst:             three_operand_opcode reg0 ',' reg1 ',' reg2 ',' shift_op immediate
                    | three_operand_opcode reg0 ',' reg1 ',' reg2
                    | two_operand_opcode reg0 ',' reg1 ',' shift_op immediate
                    | two_operand_opcode reg0 ',' reg1
                    | MOV {asmblr_obj.set_inst("MOV");} mov_params 
                    ;

three_operand_opcode: ADD {asmblr_obj.set_inst("ADD");}
                    | AND {asmblr_obj.set_inst("AND");}
                    ;

two_operand_opcode:   CMP {asmblr_obj.set_inst("CMP");}
                    | MVN {asmblr_obj.set_inst("MVN");}
                    ;

memory_inst:          mem_op reg0 ',' '[' reg1 ']'
                    | mem_op reg0 ',' '[' reg1 ',' immediate ']'
                    ;

mem_op:               LDR {asmblr_obj.set_inst("LDR");}
                    | STR {asmblr_obj.set_inst("STR");}
                    ;

shift_op:             LSL {asmblr_obj.set_shift("LSL"); }
                    | LSR {asmblr_obj.set_shift("LSR"); }
                    | ASR {asmblr_obj.set_shift("ASR"); }
                    ;

mov_params:           reg0 ',' reg1 ',' shift_op immediate
                    | reg0 ',' reg1 
                    | reg0 ',' immediate {asmblr_obj.reset_inst("MOVI");}
                    ;

immediate:            '#' number
                    | '#' LABEL {asmblr_obj.set_label($2);}  
                    | '=' LABEL {asmblr_obj.set_label($2);}  
                    | LABEL {asmblr_obj.set_label($1);}
                    ;

number:               DEC_NUMBER { 
  int result;
  asmblr_obj.set_dec($1);
  sscanf($1,"%d", &result); 
  $$ = result;
} 
                    | HEX_NUMBER {
  unsigned result;
  asmblr_obj.set_hex($1); 
  sscanf($1,"%x", &result);
  $$ = result;
}
                    | BIN_NUMBER { 
  int mask = 1;
  unsigned length = strlen($1);
  int result=0;
  asmblr_obj.set_bin($1); 
  for( int i=0; i < length-2; i++) {
    if( $1[length-1-i] == '1' ) 
      result += mask;
    mask <<= 1;
  }
  $$ = result;
}
                    ;

reg0:                 reg {asmblr_obj.set_reg(0);}
                    ;

reg1:                 reg {asmblr_obj.set_reg(1);}  
                    ;

reg2:                 reg {asmblr_obj.set_reg(2);}  
                    ;

reg:                  REGISTER {asmblr_obj.set_reg($1);} 
                    | REG_LR   {asmblr_obj.set_reg("R7");} 
                    ;

label_stmt:           LABEL_DEF {asmblr_obj.define_label($1);}

%%

void handle_arg(string arg, string value)
{
  if(arg=="-v"){
    asmblr_obj.set_file_name(value);
  } else {
    cerr<<"Invalid command argument: "<<arg<<endl;
    exit(-1);
  }
}

char *g_filename;

int main(int argc, char *argv[]) 
{
  yydebug = 0;
  yy_flex_debug = 1;
  if(argc<2){
            printf("USAGE: %s <.s file>\n",argv[0]);
            exit(1);
  }
  g_filename = strdup(argv[1]);
  printf("Input file: %s\n",argv[1]);
  FILE *myfile = fopen(argv[1], "r");
  char *tmp = strdup(argv[1]);
  char *base = strtok(tmp,".");
  asmblr_obj.set_file_name(base);
  asmblr_obj.set_addr_width(8);
  
  if(!myfile) {
    printf("Error: cannot open file %s \n",argv[1]);
    exit(1);
  }
  
  // set lex to read from file 
  yyin = myfile;

  if(argc==3 or argc>4){
    cerr<<"Invalid number of arguments \n"<<endl;
    exit(-1);
    }
    
  if(argc==4)
    handle_arg(argv[2],argv[3]);
  
  
  do {
    yyparse();
  } while (!feof(yyin));
  
  asmblr_obj.end_of_file();
  
  fclose(myfile);
}

