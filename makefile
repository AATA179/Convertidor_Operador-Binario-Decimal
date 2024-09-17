limpiar:
	rm -r ejecutable lex.yy.c y.tab.c y.tab.h 

lexer:
	flex convertidor_operador.l

parser:
	yacc -d convertidor_operador.y

compilar:
	gcc lex.yy.c y.tab.c -o ejecutable -lfl

run:
	./ejecutable
