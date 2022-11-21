// Copyright (c) 2013, Ayub Gubran, Tor M. Aamodt,
// The University of British Columbia
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
// Redistributions in binary form must reproduce the above copyright notice, this
// list of conditions and the following disclaimer in the documentation and/or
// other materials provided with the distribution.
// Neither the name of The University of British Columbia nor the names of its
// contributors may be used to endorse or promote products derived from this
// software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#include <stdlib.h>
#include <stdio.h>
#include <string>
#include <vector>
#include <map>
#include <iostream>
#include <cstdarg>
#include <limits>

#define PC_INCREMENT 1
#define WORD_SIZE 2
#define WORD_SIZE_BITS (WORD_SIZE * 8)
#define ROM_SIZE 256
#define SMIN -128
#define SMAX 127
#define UMIN 0
#define UMAX 255
#define REGS_COUNT 3
#define VERILOG_E 1
#define VHDL_E 0
extern unsigned g_line;
extern char g_linebuf[1024];

struct assembley_t
{
	assembley_t(){};
	assembley_t(char* oc, char* first, ...){
		opcode = oc;
		
		va_list vl;
		char* str=first;

		va_start(vl,first);

		while (str!=NULL){
			params.push_back(str);
			str=va_arg(vl,char*);
		}
	}

	std::string opcode;
	std::vector<std::string> params;
};


struct inst_t
{
	inst_t(){
		imm_type="";
		has_error = false;
    	shift_code=0;
    	imm_value=0;
    	imm_max=-1;
    	imm_min=-1;
    	inst_text="<not initialized>";
	}
	std::string inst;
	std::string reg[REGS_COUNT];
	std::string immediate;
	std::string imm_type;
  int shift_code;
	long int imm_value;
	long int imm_min;
	long int imm_max;
	int line;
	int pc;
	std::string binary;
	bool has_error;
	std::string inst_text;
};

struct binary_list_t
{
	binary_list_t(int i, std::string s){
		pc=i;
		binary = s;
	}
	int pc;
	std::string binary;
};

struct data_t{
	data_t(int v, unsigned a){
		value = v;
		addr = a;
	}
	long long int value;
	unsigned addr;
};

class utils
{
public:
	static bool is_whitespacecolon(char c){
		if(c==' ' or c=='\t' or c=='\r' or c=='\n' or c==':') return true;
		return false;
	}
	static std::string dec_to_binary(unsigned number)
	{
		if ( number == 0 ) return "0";
		if ( number == 1 ) return "1";

		if ( number % 2 == 0 )
			return dec_to_binary(number / 2) + "0";
		else
			return dec_to_binary(number / 2) + "1";
	}

	static bool is_valid_hex(std::string hex){
		unsigned i=0;
		if(hex[i]=='-') i=1;
		for(; i<hex.size(); i++)
			if(!isxdigit(hex[i])) return false;
		return true;
	}

	static bool is_valid_digit(std::string digit){
		unsigned i=0;
		if(digit[i]=='-') i=1;
		for(; i<digit.size(); i++)
			if(!isdigit(digit[i])) return false;
		return true;
	}

	static bool is_valid_binary(std::string bin){
		unsigned i=0;
		if(bin[i]=='-') i=1;
		for(; i<bin.size(); i++)
			if(bin[i]!='0' and bin[i]!='1') return false;
		return true;
	}

	static std::string trim_or_padd_zeros(std::string num, int size){
		if(num.size()==size) return num;

		if(num.size()>size) return num.substr(num.size()-size, size);

		std::string leading_zeros = "";
		for(int i=0; i<(size-num.size()); i++)
			leading_zeros+= "0";
		return leading_zeros + num;
	}

	static std::string get_register_strting(std::string reg){
		return trim_or_padd_zeros(dec_to_binary(atol(&reg[1])),3);
	}
	
	static std::string replace_char(std::string str, char ch1, char ch2) {
		for (int i = 0; i < str.length(); ++i) {
			if (str[i] == ch1)
				str[i] = ch2;
		}

	return str;
	}
};

class assembler
{
public:
	assembler(){
		m_addr = 0;
		m_line_counter = 1;
		initalize_instructions();
		m_file_name = "program";
	}
	~assembler(){}

    void set_addr_width(unsigned);
    void set_addr(unsigned);
    void set_word(int value);
    void set_section(std::string);
	void set_shift(std::string);
	void set_inst(std::string);
	void reset_inst(std::string);
	void set_dec(std::string);
	void set_hex(std::string);
	void set_bin(std::string);
	void set_label(std::string);
	void define_label(std::string);

	void set_reg(int);
	void set_reg(std::string);
	void end_inst();

	void new_line();
	void end_of_file();

	int get_line_number(){return m_line_counter;}

	void set_file_name(std::string file){m_file_name = file;}

  void set_entry(std::string label) { printf("entry point is %s\n", label.c_str()); }
  void add_constant(std::string label, unsigned number) { printf("%s -> 0x%x\n", label.c_str(), number); }

	/* data */
private: 

	void resolve_symbols();
	void generate_output();
	void generate_list();
	void generate_files(std::vector<binary_list_t> * v_binaries);
	void get_instruction_list(std::vector<binary_list_t> * v_binaries, std::map<unsigned, std::string>* bin_output);
	void generate_verilog_bin(std::map<unsigned, std::string>* bin_list);
	void generate_vhdl_mif_bin(std::map<unsigned, std::string>* bin_list);
	std::string get_mif_header();
	std::string get_mif_footer();
	void initalize_instructions();
	std::string m_reg_name;
	unsigned m_addr;
	unsigned m_line_counter;
	std::vector<inst_t> m_instructions;
	std::vector<data_t> m_data;
	std::map<std::string, unsigned> m_labels;
	std::map<unsigned, std::string> m_pc_of_labels;
	std::map<std::string,assembley_t> m_insts_def;
	inst_t m_curr_inst;
	std::string m_file_name;
    unsigned m_addr_width;
    void check_addr(unsigned addr);

};
