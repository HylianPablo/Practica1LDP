%{
   int locc = 0; // Lines Of Comment Code
   int locp = 0; // Lines Of Code Program
   int locw = 0; // Lines Of Code Whites
   int locf = 0; // Lines Of Code Physical
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
reservada     {if|else|for|do|while|switch|case|break|try|catch|public|private|class|import|new|this}
operando      {null|boolean|true|false|int|short|double|float|long|void|{cadena}|{decimal}|{numero}|{identificador}}
relleno_comentario  [^\/*] 

%x COMMENT CODE

%%
^(\t|\x20)*(\x20|\t)*$      locw++;   // x20 es el símbolo del espacio en blanco en hexadecimal
^{comentario_barras}        locc ++;
^\/[*]{relleno_comentario}*[*]\/\n {BEGIN INITIAL; locc ++;}
^\/[*]{relleno_comentario}\n  {BEGIN INITIAL; locc ++;}
{relleno_comentario}[*]\/$     {BEGIN CODE; locc ++;}
<INITIAL>.*|\n                        locc++;
<CODE>.*|\n                        locp++;
                   
%%
int main(int argc, char *argv[]){
    if(argc > 1){
        yyin = fopen(argv[1], "r");
    }else{
        printf("Falta argumento.\n");
        exit(1);
    }
    yylex();

    printf("Lineas de comentarios: %d\n", locc);
    printf("Lineas de programa: %d", locp);
    printf("Lineas de blancos: %d", locw);

    return 0;
}
