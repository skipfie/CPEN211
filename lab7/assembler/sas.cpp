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

#include <fstream>
#include <algorithm>
#include <iomanip>
#include <sstream>
#include <math.h>
#include <assert.h>
#include <map>
using namespace std;

#include "sas.h"

//global object
assembler asmblr_obj;

void assembler::initalize_instructions(){
	m_insts_def["NOP"] = assembley_t("0000000000000000",NULL);
	m_insts_def["HALT"] = assembley_t("1110000000000000",NULL);

	m_insts_def["B"] = assembley_t("00100000","imm_bra",NULL);
	m_insts_def["BEQ"] = assembley_t("00100001","imm_bra",NULL);
	m_insts_def["BNE"] = assembley_t("00100010","imm_bra",NULL);
	m_insts_def["BLT"] = assembley_t("00100011","imm_bra",NULL);
	m_insts_def["BLE"] = assembley_t("00100100","imm_bra",NULL);
	m_insts_def["BL"]  = assembley_t("01011111","imm_bra",NULL);
	m_insts_def["BLX"] = assembley_t("01010111","reg0","00000",NULL);
	m_insts_def["BX"]  = assembley_t("01000000","reg0","00000",NULL);

	m_insts_def["LDR"] = assembley_t("01100","reg1","reg0","displacement",NULL);
	m_insts_def["STR"] = assembley_t("10000","reg1","reg0","displacement",NULL);

	m_insts_def["ADD"] = assembley_t("10100","reg1","reg0","shift","reg2",NULL);
	m_insts_def["AND"] = assembley_t("10110","reg1","reg0","shift","reg2",NULL);
	m_insts_def["CMP"] = assembley_t("10101","reg0","000","shift","reg1",NULL);
	m_insts_def["MVN"] = assembley_t("10111","000","reg0","shift","reg1",NULL);
	
	m_insts_def["MOV"] = assembley_t("11000","000","reg0","shift","reg1",NULL);
	m_insts_def["MOVI"] = assembley_t("11010","reg0","imm",NULL);
}

void assembler::check_addr(unsigned addr){
	if(addr>=ROM_SIZE){
	 		std::cerr<<"Error: Assigned addressed value larger than memory size"<<std::endl;
	 		std::cerr<<"at line "<<g_line;
	 		exit(1);
	 	}
}

void assembler::set_addr_width(unsigned width)
{
  m_addr_width=width;
}
  
void assembler::set_addr(unsigned addr)
{
	check_addr(addr);
	m_addr = addr;
}

void assembler::set_section(string section )
{
	cerr<<"WARNING: sections are not implemented ";
	cerr<<" on line "<<g_line<<endl;
	//exit(1);
}
  
void assembler::set_word(int value)
{
  if( value >= pow(2,WORD_SIZE*8) or value < -pow(2,WORD_SIZE*8) ) {
    cerr << "Error: data value out of 16-bit range (signed or unsigned)" << value;
    cerr << "   on line " << g_line;
    exit(1);
  }
  check_addr(m_addr);
  m_data.push_back(data_t(value,m_addr++));
}
	
void assembler::set_shift(string shift)
{
  if( shift == "" ) {
    m_curr_inst.shift_code = 0;
  } else if( shift == "LSL" ) {
    m_curr_inst.shift_code = 1;
  } else if( shift == "LSR" ) {
    m_curr_inst.shift_code = 2;
  } else if( shift == "ASR" ) {
    m_curr_inst.shift_code = 3;
  } else {
	  m_curr_inst.has_error = true;
  }
}

void assembler::set_inst(string inst){
	m_curr_inst.inst = inst;
}

void assembler::reset_inst(string inst){
	m_curr_inst.inst = inst;
}

void assembler::set_hex(string hex){
	m_curr_inst.imm_type = "$";
	m_curr_inst.immediate = hex.substr(2,hex.size()-1);
}

void assembler::set_bin(string bin){
	m_curr_inst.imm_type = "%";
	m_curr_inst.immediate = bin.substr(2,bin.size()-1);
}

void assembler::set_dec(string dec){
	m_curr_inst.imm_type = "#";
	m_curr_inst.immediate = dec; 
}


void assembler::set_label(string label){
	m_curr_inst.imm_type = "label";
	m_curr_inst.immediate = label;
}

void assembler::define_label(string label){
	//clearing spaces
	label.erase(remove_if(label.begin(), label.end(), utils::is_whitespacecolon), label.end());
	m_labels[label] = m_addr;
	m_pc_of_labels[m_addr] = label;
}

void assembler::set_reg(int reg_num){
	m_curr_inst.reg[reg_num]= m_reg_name;
}

void assembler::set_reg(string reg){
	m_reg_name = reg;
}

void assembler::end_inst(){
	check_addr(m_addr);
	if(m_addr%PC_INCREMENT){
		cerr<<"Error: Instruction placed on non-PC aligned address"<<endl;
		cerr<<"at line "<<g_line<<endl;
		exit(1);
	}

	m_curr_inst.inst_text = g_linebuf; 
	m_curr_inst.pc = m_addr;
	m_curr_inst.line = g_line; //m_line_counter;
	m_instructions.push_back(m_curr_inst);
	m_curr_inst= inst_t(); //clearing it other state data should be ok
	m_addr+=PC_INCREMENT;
}

void assembler::new_line(){
	m_line_counter++;
}

void assembler::end_of_file(){
	resolve_symbols();
	generate_output();
}

void assembler::resolve_symbols(){
	for(unsigned i=0; i<m_instructions.size(); i++){
		bool bound_error= false;
		if(m_instructions[i].imm_type=="label"){
			if(m_labels.find(m_instructions[i].immediate)==m_labels.end()){
				cerr<<"Undefined label:\""<<m_instructions[i].immediate<<"\", line: "<<m_instructions[i].line<<endl;
				m_instructions[i].has_error = true;
			}
			m_instructions[i].imm_value = m_labels[m_instructions[i].immediate];
			m_instructions[i].imm_min = UMIN;
			m_instructions[i].imm_max = UMAX;
		}
		else if(m_instructions[i].imm_type=="#") {
			if(!utils::is_valid_digit(m_instructions[i].immediate)){
				cerr<<"Error: Invalid immediate decimal value:"<<m_instructions[i].immediate<<", instruction \""<<m_instructions[i].inst<<"\" at line "<<m_instructions[i].line<<endl;
				m_instructions[i].has_error = true;
			}
			m_instructions[i].imm_value =strtol (m_instructions[i].immediate.c_str(), NULL, 10);
			m_instructions[i].imm_min = SMIN;
			m_instructions[i].imm_max = UMAX;
		}
		else if(m_instructions[i].imm_type=="$") {
			if(!utils::is_valid_hex(m_instructions[i].immediate)){
				cerr<<"Error: Invalid immediate hexadecimal value:"<<m_instructions[i].immediate<<", instruction \""<<m_instructions[i].inst<<"\" at line "<<m_instructions[i].line<<endl;
				m_instructions[i].has_error = true;
			}
			m_instructions[i].imm_value =strtol (m_instructions[i].immediate.c_str(), NULL, 16);
			m_instructions[i].imm_min = UMIN;
			m_instructions[i].imm_max = UMAX;
		}
		else if(m_instructions[i].imm_type=="%") {
			if(!utils::is_valid_binary(m_instructions[i].immediate)){
				cerr<<"Error: Invalid immediate binary value:"<<m_instructions[i].immediate<<", instruction \""<<m_instructions[i].inst<<"\" at line "<<m_instructions[i].line<<endl;
				m_instructions[i].has_error = true;
			}
			m_instructions[i].imm_value =strtol (m_instructions[i].immediate.c_str(), NULL, 2);
			m_instructions[i].imm_min = UMIN;
			m_instructions[i].imm_max = UMAX;
		}
	}

}

void assembler::generate_output(){
	generate_list();
}

void assembler::generate_list(){
	ofstream list_file((m_file_name+".lst").c_str());
	if(!list_file.is_open()){
		cerr<<"Error: failed to open list file "<<m_file_name+".lst"<<endl;
		exit(-1);
	}

	vector<binary_list_t> v_binaries;
	bool any_error = false;

	list_file<<setw(m_addr_width/4)<<std::left<<std::setfill(' ')<<"PC"<<setfill(' ')<<setw(8)<<" "
	<<setw(35)<<"Binary"<<setw(40)<<"Instruction"<<endl;

	for(unsigned i=0; i<m_instructions.size(); i++){
		string binary = m_insts_def[m_instructions[i].inst].opcode;
		if(m_pc_of_labels.find(m_instructions[i].pc) != m_pc_of_labels.end())
			list_file<<std::hex<<setw(m_addr_width/4)<<std::right<<std::setfill('0')<<m_instructions[i].pc/PC_INCREMENT<<setfill(' ')<<setw(8)<<" "
		<<std::left<<setw(25)<<" "<<std::left<<setw(40)<<m_pc_of_labels[m_instructions[i].pc]<<endl;
		vector<string> params = m_insts_def[m_instructions[i].inst].params;

		if(!m_instructions[i].has_error)
			for(unsigned p=0; p<params.size(); p++){
				if(params[p]=="reg0") binary+= utils::get_register_strting(m_instructions[i].reg[0]);
				else if(params[p]=="reg1") binary+= utils::get_register_strting(m_instructions[i].reg[1]);
				else if(params[p]=="reg2") binary+= utils::get_register_strting(m_instructions[i].reg[2]);
				else if(params[p]=="imm")  {
					if(m_instructions[i].imm_value<m_instructions[i].imm_min or m_instructions[i].imm_value>m_instructions[i].imm_max){
						cerr<<"Error: immediate value out of range ("<<m_instructions[i].imm_min<<"-"<<m_instructions[i].imm_max<<"): value="
						<<m_instructions[i].immediate<<" at instruction \""<<m_instructions[i].inst<<"\" at line "<<m_instructions[i].line<<endl;
						m_instructions[i].has_error = true;
						break;
					}
					binary+=utils::trim_or_padd_zeros(utils::dec_to_binary((unsigned)m_instructions[i].imm_value),8);
				}
				else if(params[p]=="imm_bra") {
					//check if it is a valid address
					if(0!=(m_instructions[i].imm_value%PC_INCREMENT)){
						cerr<<"Error: Branch address is invalid: address="<<m_instructions[i].imm_value
						<<", instruction \""<<m_instructions[i].inst<<"\" line "<<m_instructions[i].line<<endl;
					}

					int branch_relative_address = m_instructions[i].imm_value - (m_instructions[i].pc+PC_INCREMENT); 
					branch_relative_address/=PC_INCREMENT;

					if(branch_relative_address<SMIN or branch_relative_address>SMAX){
						cerr<<"Error: Branch distance is too far: instruction \""<<m_instructions[i].inst<<"\" at line "<<m_instructions[i].line<<endl;
						m_instructions[i].has_error = true;
						break;
					}

					unsigned char bra_add =  branch_relative_address;
					binary+=utils::trim_or_padd_zeros(utils::dec_to_binary(bra_add),8);
				}
        else if(params[p]=="displacement") {
					if( m_instructions[i].imm_value < -16 || m_instructions[i].imm_value > 15 ) {
            cerr<<"Error: load/store displacement must be within -16 to 15"<<endl;
            cerr<<"       at line "<<m_instructions[i].line<<" "<<m_instructions[i].inst_text<<endl;
            m_instructions[i].has_error = true;
          }
					binary+=utils::trim_or_padd_zeros(utils::dec_to_binary((unsigned)m_instructions[i].imm_value),5);
        }
        else if(params[p]=="shift") {
					if( m_instructions[i].shift_code && m_instructions[i].imm_value != 1 ) {
            cerr<<"Error: shift value must be 1"<<endl;
            cerr<<"       at line "<<m_instructions[i].line<<" "<<m_instructions[i].inst_text<<endl;
            m_instructions[i].has_error = true;
          }
					binary+=utils::trim_or_padd_zeros(utils::dec_to_binary((unsigned)m_instructions[i].shift_code),2);
        }
				else binary+=params[p];
			}

			if(m_instructions[i].has_error){
				binary = "Error in instruction ";
				any_error = true;
			}

			list_file<<std::hex<<setw(m_addr_width/4)<<std::right<<std::setfill('0')<<m_instructions[i].pc/PC_INCREMENT<<setfill(' ')<<setw(8)<<" "
			<<std::left<<setw(35)<<binary<<std::left<<setw(40)<<m_instructions[i].inst_text<<endl;

			v_binaries.push_back(binary_list_t(m_instructions[i].pc,binary));
		}

		list_file.close();

		if(!any_error) {
			generate_files(&v_binaries);
		}
	else {
		cout<<"Errors found."<<endl;
		exit(0);
	}
}

void assembler::generate_files(vector<binary_list_t> * v_binaries){
	map<unsigned, string> bin_output;
	get_instruction_list(v_binaries, &bin_output);
	if(VERILOG_E)
		generate_verilog_bin(&bin_output);
	if(VHDL_E)
		generate_vhdl_mif_bin(&bin_output);
	
}

void assembler::get_instruction_list(vector<binary_list_t> * v_binaries, map<unsigned, string>* bin_output){
	for(unsigned i=0; i<v_binaries->size(); i++){
      string bin = utils::replace_char((*v_binaries)[i].binary, '-', '0');
	  unsigned pc = ((*v_binaries)[i].pc);
	  if(bin_output->find(pc) != bin_output->end())
		{
			cerr<<"Error: multiple instructions are written to address "<<pc<<endl;
			exit(-1);
		}
	  (*bin_output)[pc] = bin;
	}
	
	for(unsigned i=0; i<m_data.size(); i++ ) {
      string bin=utils::trim_or_padd_zeros(utils::dec_to_binary(m_data[i].value),WORD_SIZE*8);
      unsigned addr = m_data[i].addr;
	  if(bin_output->find(addr) != bin_output->end())
		{
			cerr<<"Error: multiple instructions/data are written to address "<<((*v_binaries)[i].pc)<<endl;
			exit(-1);
		}
		(*bin_output)[addr] = bin;
	}
}

void assembler::generate_verilog_bin(map<unsigned, string>* bin_list){
	string fileName = m_file_name+".txt";
	ofstream bin_file(fileName.c_str());
	if(!bin_file.is_open()){
		cerr<<"Error: failed to open output file "<<fileName<<endl;
		exit(-1);
	}
	
	unsigned lastpc = 0;
    map<unsigned, string>::iterator iter;
	for (iter = bin_list->begin(); iter != bin_list->end(); ++iter) {
		unsigned inst_pc = iter->first;
		while(lastpc < inst_pc) {
		  bin_file<<"@"<<std::hex<<std::setfill('0')<<std::setw(m_addr_width/4)<<lastpc
				  <<" "<<utils::trim_or_padd_zeros("",WORD_SIZE_BITS)<<endl;
		  lastpc++;
		}
		bin_file<<"@"<<std::hex<<std::setfill('0')<<std::setw(m_addr_width/4)<<inst_pc
				<<" "<<(*bin_list)[inst_pc]<<endl;
		lastpc=inst_pc+1;
    }
    while(lastpc < ROM_SIZE) {
	    bin_file<<"@"<<std::hex<<std::setfill('0')<<std::setw(m_addr_width/4)<<lastpc
				  <<" "<<utils::trim_or_padd_zeros("",WORD_SIZE_BITS)<<endl;
		lastpc++;
    }
	bin_file.close();
}

void assembler::generate_vhdl_mif_bin(map<unsigned, string>* bin_list){
	ofstream mif_file((m_file_name+".mif").c_str());
	ofstream bin_file((m_file_name+".bin").c_str());
	if(!mif_file.is_open()){
		cerr<<"Error: failed to open output file "<<m_file_name+".mif"<<endl;
		exit(-1);
	}
	if(!bin_file.is_open()){
		cerr<<"Error: failed to open output file "<<m_file_name+".bin"<<endl;
		exit(-1);
	}
	
	mif_file<<get_mif_header();
	
	unsigned lastpc = 0;
	map<unsigned, string>::iterator iter;
	for (iter = bin_list->begin(); iter != bin_list->end(); ++iter) {
		unsigned inst_pc = iter->first;
		while(lastpc < inst_pc) {
		  mif_file<<std::hex<<std::uppercase<<std::setfill('0')<<std::setw(m_addr_width/4)
				  <<lastpc<<": "<<utils::trim_or_padd_zeros("",WORD_SIZE_BITS)<<";"<<endl;
		  bin_file<<utils::trim_or_padd_zeros("",WORD_SIZE_BITS)<<endl;
		  lastpc++;
		}
		mif_file<<std::hex<<std::uppercase<<std::setfill('0')<<std::setw(m_addr_width/4)
			    <<inst_pc<<": "<<(*bin_list)[inst_pc]<<";"<<endl;
		bin_file<<(*bin_list)[inst_pc]<<endl;
		lastpc=inst_pc+1;
	 }
	while(lastpc < ROM_SIZE) {
		mif_file<<std::hex<<std::uppercase<<std::setfill('0')<<std::setw(m_addr_width/4)
			    <<lastpc<<": "<<utils::trim_or_padd_zeros("",WORD_SIZE_BITS)<<";"<<endl;
		bin_file<<utils::trim_or_padd_zeros("",WORD_SIZE_BITS)<<endl;
		lastpc++;
	}
	
	mif_file<<get_mif_footer();
	mif_file.close();
	bin_file.close();
}

string assembler::get_mif_header() {
  string depth;
  ostringstream tmp;
  tmp << (int)pow(2,m_addr_width);
  depth = tmp.str();

	return "DEPTH = " + depth +
    "; % DEPTH is the number of addresses %\n"
		"WIDTH = 16; % WIDTH is the number of bits of data per word %\n"
		"ADDRESS_RADIX = HEX; % Address and value radixes are required %\n"
		"DATA_RADIX = BIN; % Enter BIN, DEC, HEX, OCT, or UNS; unless %\n"
		"CONTENT\n"
		"BEGIN\n"
	;
}
string assembler::get_mif_footer() {
	return
		"END;\n"
	;
}
