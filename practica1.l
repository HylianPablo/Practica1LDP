%{
#include<stdio.h>
#include<string.h>
#define IF 250
%}
%option case-insensitive

letra         [a-zA-Z]
digito        [0-9]
identificador {letra}({letra}|{digito})*
fraccion      [.]{digito}+ 
exponencial   [eE][+-]?{digito}+
decimal       {digito}+({fraccion}|{exponencial})
numero        {digito}+
cadena        \"[^"]*\"
comentario_barras    [/][/].*
complejidad   (if|for|while|catch|[&][&]|[|][|])
operando      (null|boolean|true|false|int|short|double|float|long|void|{cadena}|{decimal}|{numero}|{identificador})
compl	[^*/\n]
rell	([/]|[*]*{compl})
intercom	[*][*]*[/][/][*]
rell_com	({rell}|{intercom})
op_ternario   {rell_com}[?]{rell_com}[:]{rell_com}
white	(\x20|\t)

 int locc = 0, locp = 0, locw = 0, mcCabe=0;
%s COM
%%
<COM>^\n	{locc++; printf("com_multi_empty ");}
<COM>^{rell_com}*{rell_com}*$	{locc++; printf("com_multi_rell ");}
<COM>^{rell_com}*[*][*]*[/]{white}*$	{BEGIN INITIAL; locc++; printf("com_multi_end ");}
<COM>^{rell_com}*[*][*]*[/].*	{BEGIN INITIAL; locp++; printf("com_multi_cod");}
^[/][/].*	{locc++; printf("com_barras ");}
^[/][*]{rell_com}*[*][*]*[/]$	{locc++; printf("com_ast1 ");}
^[/][*]{rell_com}*[*][*]*[/][/][/].*$	{locc++; printf("com_ast_barras");}
^[/][*]{rell_com}*$	{BEGIN COM; locc++; printf("com_multi_ini ");}
.*[/][*]{rell_com}*$	{BEGIN COM; locp++; printf("cod_multi_ini ");}
^\n	{locw++; printf("w_empty\n");}
^{white}*{white}*$	{locw++; printf("w_white");}
.*	{locp++; printf("cod ");}
%%
int main( int argc, char** argv){
	if( argc > 1 )
		yyin = fopen (argv[1], "r");
	else
		yyin = stdin;
    yylex();
    printf("\nResults: \n");
	printf("LOCC = %d\n", locc);
	printf("LOCP = %d\n", locp);
	printf("LOCW = %d\n", locw);
	printf("LOCF = %d\n", locc+locp+locw);
    printf("Número ciclomático = %d\n", mcCabe);
	return 0;
}
