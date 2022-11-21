LEX		= flex
LEXFLAGS	= #-B -d -v 
YACC		= yacc
YFLAGS		= -d -t
CC		= gcc
CCFLAGS		= -Wno-write-strings -g
OPT_FLAGS	= 
CXX		= g++
CXXFLAGS	= ${CCFLAGS}


all: sas

debug: OPT_FLAGS = 
debug: CCFLAGS+= -ggdb
debug: CXXFLAGS+= -ggdb
debug: YFLAGS+= --debug --verbose --report=all
debug: sas

sas: lex.yy.c y.tab.c y.tab.h sas.h sas.cpp
	${CXX} ${CXXFLAGS} ${OPT_FLAGS} sas.cpp y.tab.c lex.yy.c -lm -o sas

y.tab.c y.tab.h: sas.y sas.h
	${YACC} ${YFLAGS} sas.y

lex.yy.c: sas.l y.tab.h
	${LEX} ${LEXFLAGS} sas.l

clean:
	rm -rf *o sas.exe sas y.tab.c y.tab.h lex.yy.c *~ y.output
