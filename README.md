This is a project in assembly x86 AT&T syntax which is divided into 3 subtasks. It simulates Conway's Game of Life. 
The first program (program 0) takes the initial state of matrix and the number of evolutions as input 
and outputs the final state of matrix after evolutions. The third program (program 2) does the same thing but uses files for input and output.
The second program (program 1) uses the state of matrix after k evolutions to produce a key for encryption/decryption of text messages. 
Based on input it can either encrypt a message or decrypt it using the same key.
This AT&T syntax runs only on Linux. To run it with gcc compiler use command gcc -m32 131_program_name.s -o program_name -no-pie and then ./program_name
