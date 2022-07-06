CC = gcc
CFLAGS = -g -O0 -std=c99

parser: miniL.lex miniL.y
	bison -v -d --file-prefix=y miniL.y
	flex miniL.lex
	gcc -o parser y.tab.c lex.yy.c -lfl

clean:
	rm -f *.o miniL-lex.c miniL-parser.c miniL-parser.h *.output *.dot miniL