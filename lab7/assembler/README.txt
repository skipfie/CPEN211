Note that sas is installed on ssh.ece.ubc.ca at ~cpen211/bin/sas. If you know
how to use Putty and pscp.exe (e.g., for handin) then you can avoid needing to
install sas on your own computer.    

1. INSTALLING sas

If using Linux, type "make".

If using Mac OS X install Xcode and ensure you have gcc, bison, and lex
installed and then open Terminal and change directory to the folder
contining this file and then type "make".

If using Windows install cygwin using the instructions on Piazza. Then,
run Cygwin by clicking on the cygwin icon.  If installed correctly, running
cygwin will open up a UNIX style command line environment or terminal.  The
rest of the commands below should be typed in the cygwin terminal.  Next, Copy
the entire contents of the folder "sas" (highlight it and press CTRL+C).
Browse to C:\cygwin64\home\<username> where <username> is your windows
username. This directory should already exist.  If you install the 32-bit
version of cygwin it will be C:\cygwin\home\<username>.  Copy the contents
after unzipping sas.zip to this directory.  To build assembler type "make". 
You should see:

    $ make
    yacc -d -t sas.y
    flex  sas.l
    make: Warning: File 'y.tab.c' has modification time 0.12 s in the future
    g++ -Wno-write-strings -g  sas.cpp y.tab.c lex.yy.c -lfl -lm -o sas
    make: warning:  Clock skew detected.  Your build may be incomplete.

You may or may not see the "Warning" messages above.  If you get *errors* this
means you likely did not install all the components of cygwin specified in the
install handout.

2. USAGE

To run assembler:

On Window: type "./sas.exe <file>.s" but replace "<file>" with the name
of a .s file -- e.g. "./sas.exe test.s"

On Linux/Mac OS X: type "./sas <file>.s"

Copy the resulting <file>.txt file to your Verilog project directory (top level
directory).  

Set your $readmemb file name to your .txt file.  You can do this by overriding
the parameter filename in the RAM module in Slide Set 7 when you instantiate
the RAM.
