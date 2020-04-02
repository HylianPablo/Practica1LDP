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
<COM>^\n	{locf++; locc++;}
<COM>^{rell_com}*{rell_com}*$	{ locc++;}
<COM>^{rell_com}*[*][*]*[/]{white}*$	{BEGIN(INITIAL); locc++;}
<COM>^{rell_com}*[*][*]*[/]	{BEGIN(INITIAL);}
^\n	{locf++; locw++;}
^{white}*{white}*$	{locw++;}
^{white}*[/][/].*$	{locc++;}
^{white}*[/][*]{rell_com}*[*][*]*[/]{white}*$	{locc++;}
^{white}*[/][*]{rell_com}*[*][*]*[/]{white}*[/][/].*$	{locc++;}
^{white}*[/][*]{rell_com}*$	{BEGIN(COM); locc++;}
[/][/].*$	;
["]	{BEGIN(STRING);}
<STRING>\n	{locf++;}
<STRING>["]	{BEGIN(INITIAL);}
<STRING>.	;
[']	{BEGIN(STSIMP);}
<STSIMP>\n	{locf++;}
<STSIMP>[']	{BEGIN(INITIAL);}
<STSIMP>.	;
[/][*]	{BEGIN(CICCOM);}
<CICCOM>[*][/]	{BEGIN(INITIAL);}
<CICCOM>[*][/]{white}*{complFun}{white}*([(]|[{])	{BEGIN(INITIAL); mcCabe++;}
<CICCOM>[*][/]{white}*case{white}	{BEGIN(INITIAL); mcCabe++;}
<CICCOM>\n	{locf++; BEGIN(COM);}
<CICCOM>.	;
^{white}*{complFun}{white}*([(]|[{])	{mcCabe++;}
([}]|[{]|;|else){white}*{complFun}{white}*([(]|[{])	{mcCabe++;}
{logic}	{mcCabe++;}
^{white}*case{white}	{mcCabe++;}
([{]|;){white}*case{white}	{mcCabe++;}
{op_ternario}	{mcCabe++;}
\n	{locf++;}
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
