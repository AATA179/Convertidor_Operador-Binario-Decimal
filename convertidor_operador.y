%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void yyerror(const char *str) {
    fprintf(stderr, "error: %s\n", str);
}

int yywrap() {
    return 1;
}

// Convertir la cadena que contiene un numero binario a un numero en decimal
int binarioADecimal(const char *binario) {
    int decimal = 0;
    int base = 1;  
    int longitud = strlen(binario);

    // Iterar de derecha a izquierda (desde el último dígito)
    for (int i = longitud - 1; i >= 0; i--) {
        if (binario[i] == '1') {
            decimal += base;
        }
        base *= 2;  // Incrementar la potencia de 2
    }

    return decimal;
}

// Convertir un numero decimal a binario
char* decimalABinario(const char* numeroDecimal) {
    // Convierte el string a un número entero
    int decimal = atoi(numeroDecimal);

    // Caso especial para el número 0
    if (decimal == 0) {
        char* binario = (char*)malloc(2 * sizeof(char)); // Espacio para '0' y el terminador '\0'
        strcpy(binario, "0");
        return binario;
    }

    // Buffer temporal para almacenar el binario en orden inverso
    char tempBinario[32];
    int index = 0;

    // Convierte el número decimal a binario
    while (decimal > 0) {
        tempBinario[index++] = (decimal % 2) ? '1' : '0';
        decimal /= 2;
    }

    // Asigna memoria dinámica para el resultado final
    char* binario = (char*)malloc((index + 1) * sizeof(char)); // Incluye el terminador nulo '\0'

    // Invierte el orden y copia a la cadena final
    for (int i = 0; i < index; i++) {
        binario[i] = tempBinario[index - i - 1];
    }

    // Agrega el terminador nulo
    binario[index] = '\0';

    return binario;
}

int main() {
    yyparse();
    return 0;
}
%}

%token <string> NUMERO
%token <number> BASE
%token <string> OP
%token <op> OPERAR

%union {
    int number;
    char *string;
    char op;
}

%%

commands:
    /* empty */
    | commands command
    ;

command:
    convertir
    | operar
    ;

// Conversion de numeros
convertir:
    BASE NUMERO
    {
        if ($1) {
            int decimal = binarioADecimal($2);  // Convierte la cadena binaria a decimal
            printf("\t%d\n", decimal);
        } else {
            printf("\t%s\n", decimalABinario($2));
        }
    }
    ;

// Operacion entre numeros de distintas bases
// El resultado siempre se regresa en decimal
operar:
    OPERAR BASE NUMERO OP BASE NUMERO
    {
	int num1, num2, resultado = -1;
	if ($2) {
	   num1 = binarioADecimal($3); // Si es binario lo convierte a decimal
	} else {
	   num1 = atoi($3); // Si ya es decimal solo convierte el char* a int
	}

	if ($5) {
           num2 = binarioADecimal($6);
	} else {
	   num2 = atoi($6);
	}

	char operador = $4[0];

	// Manejar las distintas operaciones
	switch (operador){
	case '+':
	   resultado = num1 + num2;
	   break;
	case '-':
	   resultado = num1 - num2;
	   break;
	case '*':
	   resultado = num1 * num2;
	   break;
	case '/':
	   resultado = num1 / num2;
	   break;
	}

	printf("\t%d\n", resultado);
    }
    ;	

%%

