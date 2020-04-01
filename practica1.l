%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
%}
%option case-insensitive

complFun	(if|for|while|catch)
logic   ([&][&]|[|][|])
compl	[^*/\n]
rell	([/]|[*]*{compl})
intercom	[*][*]*[/]{white}*[/][*]
rell_com	({rell}|{intercom})
op_ternario   [?]
white	(\x20|\t)
com_uni	[*][/]{rell_com}*[*][*]*[/]

 int locc=0, locf=0, locp=0, locw=0, mcCabe=1;
%s COM
%x CICCOM STRING STSIMP
%%
<COM>^\n	{locf++; locc++; printf("com_multi_empty ");}
<COM>^{rell_com}*{rell_com}*$	{ locc++; printf("com_multi_rell ");}
<COM>^{rell_com}*[*][*]*[/]{white}*$	{BEGIN(INITIAL); locc++; printf("com_multi_end ");}
<COM>^{rell_com}*[*][*]*[/]	{BEGIN(INITIAL); printf("com_multi_cod");}
^\n	{locf++; locw++; printf("w_empty\n");}
^{white}*{white}*$	{locw++; printf("w_white ");}
^{white}*[/][/].*$	{locc++; printf("com_barras ");}
^{white}*[/][*]{rell_com}*[*][*]*[/]{white}*$	{locc++; printf("com_ast1 ");}
^{white}*[/][*]{rell_com}*[*][*]*[/]{white}*[/][/].*$	{locc++; printf("com_ast_barras");}
^{white}*[/][*]{rell_com}*$	{BEGIN(COM); locc++; printf("com_multi_ini ");}
[/][/].*$	{printf("com_barras_post ");}
["]	{BEGIN(STRING); printf("iniString ");}
<STRING>\n	{locf++;}
<STRING>["]	{BEGIN(INITIAL); printf("endString ");}
<STRING>.	;
[']	{BEGIN(STSIMP); printf("iniStsimp ");}
<STSIMP>\n	{locf++;}
<STSIMP>[']	{BEGIN(INITIAL); printf("endStsimp ");}
<STSIMP>.	;
[/][*]	{BEGIN(CICCOM); printf("iniCom ");}
<CICCOM>[*][/]	{BEGIN(INITIAL); printf("finCom ");}
<CICCOM>[*][/]{white}*{complFun}{white}*([(]|[{])	{BEGIN(INITIAL); mcCabe++; printf("functPostComment");}
<CICCOM>[*][/]{white}*case{white}	{BEGIN(INITIAL); mcCabe++; printf("casePostComment");}
<CICCOM>\n	{locf++; BEGIN(COM); printf("comentario ");}
<CICCOM>.	;
^{white}*{complFun}{white}*([(]|[{])	{mcCabe++; printf("functIni ");}
([}]|[{]|;|else){white}*{complFun}{white}*([(]|[{])	{mcCabe++; printf("funct ");}
{logic}	{mcCabe++; printf("logic ");}
^{white}*case{white}	{mcCabe++; printf("caseIni ");}
([{]|;){white}*case{white}	{mcCabe++; printf("case ");}
{op_ternario}	{mcCabe++; printf("ternario ");}
\n	{locf++; printf("+1 ");}
.	;
%%
int main( int argc, char *argv[]){

	if( argc > 1 ){
		yyin = fopen (argv[1], "r");
	}else{
		fprintf(stderr, "No hay argumentos suficientes.\n");
		exit(EXIT_FAILURE);
	}	

	yylex();
	printf("\nResultado: \n");
	printf("LOCC = %d\n", locc);
	printf("LOCP = %d\n", locf-locc-locw);
	printf("LOCW = %d\n", locw);
	printf("LOCF = %d\n", locf);
	printf("Número ciclomático = %d\n", mcCabe);
	FILE *fp = fopen("salida.txt", "w");
	fprintf(fp, "LOCC = %d\n", locc);
	fprintf(fp, "LOCP = %d\n", locf-locc-locw);
	fprintf(fp, "LOCW = %d\n", locw);
	fprintf(fp, "LOCF = %d\n", locf);
	fprintf(fp, "Número ciclomático = %d\n", mcCabe);

	return 0;
}
