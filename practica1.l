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
complFun	(if|for|while|catch)
logic   ([&][&]|[|][|])
operando      (null|boolean|true|false|int|short|double|float|long|void|{cadena}|{decimal}|{numero}|{identificador})
compl	[^*/\n]
rell	([/]|[*]*{compl})
intercom	[*][*]*[/][/][*]
rell_com	({rell}|{intercom})
op_ternario   {rell_com}[?]{rell_com}[:]{rell_com}
white	(\x20|\t)
com_uni	[*][/]{rell_com}*[*][*]*[/]

 int locc=0, locf=0, locp=0, locw=0, mcCabe=1;
%s COM
%x CIC CICCOM STRING STSIMP
%%
<COM>^\n	{locf++; locc++; printf("com_multi_empty ");}
<COM>^{rell_com}*{rell_com}*$	{ locc++; printf("com_multi_rell ");}
<COM>^{rell_com}*[*][*]*[/]{white}*$	{BEGIN(INITIAL); locc++; printf("com_multi_end ");}
<COM>^{rell_com}*[*][*]*[/]	{BEGIN(INITIAL); printf("com_multi_cod");}
^[/][/].*$	{locc++; printf("com_barras ");}
^[/][*]{rell_com}*[*][*]*[/]$	{locc++; printf("com_ast1 ");}
^[/][*]{rell_com}*[*][*]*[/][/][/].*$	{locc++; printf("com_ast_barras");}
^[/][*]{rell_com}*$	{BEGIN(COM); locc++; printf("com_multi_ini ");}
^\n	{locf++; locw++; printf("w_empty\n");}
^{white}*{white}*$	{locw++; printf("w_white ");}
["]	{BEGIN(STRING); printf("iniString ");}
[']	{BEGIN(STSIMP); printf("iniStsimp ");}
<STRING>["]	{BEGIN(INITIAL); printf("endString ");}
<STSIMP>[']	{BEGIN(INITIAL); printf("endStsimp ");}
[/][/]	{BEGIN(CICCOM); printf("comDobBar ");}
[/][*]	{BEGIN(CICCOM); printf("iniCom ");}
<CICCOM>[*][/]	{BEGIN(INITIAL); printf("finCom ");}
^{white}*{complFun}{white}*([(]|[{])	{mcCabe++; printf("functIni ");}
([}]|[{]|;){white}*{complFun}{white}*([(]|[{])	{mcCabe++; printf("funct ");}
^([^[//][/*]]|{com_uni})*{white}*{logic}{white}.*$	{mcCabe++; printf("logic ");}
^{white}*case{white}	{mcCabe++; printf("caseIni ");}
([{]|;){white}*case{white}	{mcCabe++; printf("case ");}
{op_ternario}	{mcCabe++; printf("ternario ");}
\n	{locf++; printf("+1 ");}
<CICCOM>\n	{locf++; BEGIN(COM); printf("comentario ");}
<STRING>\n	{locf++;}
<STSIMP>\n	{locf++;}
.	;
<CICCOM>.	;
<STRING>.	;
<STSIMP>.	;
%%
int main( int argc, char *argv[]){
	if( argc > 1 ){
		yyin = fopen (argv[1], "r");
	}else{
		//yyin = stdin;
		printf("Falta el programa.\n");
	}	
	

	yylex();
	printf("\nResults: \n");
	printf("LOCC = %d\n", locc);
	printf("LOCP = %d\n", locf-locc-locw);
	printf("LOCW = %d\n", locw);
	printf("LOCF = %d\n", locf);
	printf("Número ciclomático = %d\n", mcCabe);
	return 0;
}
