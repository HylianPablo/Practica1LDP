%{
    int locc, locp, locw, locf;
    locc = 0;
    locp = 0;
    locw = 0;
    locf = 0;
%}
%option case-insensitive
%x COMMENT 
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
relleno_comentario  -> cambiar
complem_comentario  [^\/\*] -> cambiar
%%
\x20* "\n"      locw;   // x20 es el símbolo del espacio en blanco en hexadeciaml
^{comentario_barras}   locc ++;
^\/[*].*        locc ++;
^\/[*]{relleno_comentario}  -> cambiar
