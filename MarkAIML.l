%option noyywrap
/*Sección de Declaraciones*/
%{
#include <iostream>
#include <fstream>

using namespace std ;

ifstream ficheroEntrada ;
ofstream ficheroSalida ;
int numeroEstrellas ;

void procesar(string resto,ofstream &salida) ;
void abrirTag(string tag,ofstream &salida) ;
void cerrarTagEnter(string tag,ofstream &salida) ;
void cerrarTag(string tag,ofstream &salida) ;
%}

/*Sección de Reglas*/
%%
^"[XML]"        {ficheroSalida << "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" << endl ;}
^"[AIML]".*   {abrirTag("aiml version=\"2.0\"",ficheroSalida) ;}
^"[<->]".*      {abrirTag("category",ficheroSalida);}
^"[]".*         {cerrarTagEnter("category",ficheroSalida);}
"[>>]".*     {abrirTag("pattern",ficheroSalida); numeroEstrellas = 0; procesar(YYText()+4,ficheroSalida) ; cerrarTagEnter("pattern",ficheroSalida);}
"[<<]".*      {abrirTag("template",ficheroSalida); procesar(YYText()+4,ficheroSalida) ;cerrarTagEnter("template",ficheroSalida);}
[*^_#$]     {ficheroSalida << YYText()[0] ;numeroEstrellas++;}
"[>JS:]".*   {abrirTag("javascript",ficheroSalida);procesar(YYText()+6,ficheroSalida) ;cerrarTag("javascript",ficheroSalida);}
"[->]".*      {abrirTag("topic",ficheroSalida);procesar(YYText()+4,ficheroSalida) ;cerrarTag("topic",ficheroSalida);}
"[|#|]".*     {abrirTag("learn",ficheroSalida);procesar(YYText()+5,ficheroSalida) ;cerrarTag("learn",ficheroSalida);}
"[/]".*    {abrirTag("think",ficheroSalida);procesar(YYText()+3,ficheroSalida) ;cerrarTag("think",ficheroSalida);}
"[--]".*    {abrirTag("li",ficheroSalida);procesar(YYText()+4,ficheroSalida);}
"[@]".*   {cerrarTag("li",ficheroSalida);procesar(YYText()+3,ficheroSalida);}
"[?]".*       {abrirTag("random",ficheroSalida);procesar(YYText()+3,ficheroSalida) ;cerrarTag("random",ficheroSalida);}
"[aA]".*      {abrirTag("uppercase",ficheroSalida);procesar(YYText()+4,ficheroSalida) ;cerrarTag("uppercase",ficheroSalida);}
"[Aa]".*      {abrirTag("lowercase",ficheroSalida);procesar(YYText()+4,ficheroSalida) ;cerrarTag("lowercase",ficheroSalida);}
"["[0-9]"]" {ficheroSalida << "<star index = \"" << YYText()[1] << "\"/>" ;}
"[END]".*     {cerrarTag("aiml",ficheroSalida);}
%%
/*Sección de Procedimientos*/
int main(int argc, char * argv[]){
    if (argc==3){
        ficheroEntrada.open (argv[1]) ;
        if (!ficheroEntrada.is_open()){
            cout << "Error de lectura" << endl ;
            exit(-2) ;
        }
        ficheroSalida.open (argv[2]) ;
        if (!ficheroSalida.is_open()){
            cout << "Error de escritura" << endl ;
            exit(-3) ;
        }
    }
    else exit(-1) ;

    yyFlexLexer flujoMarkAIML (&ficheroEntrada,&ficheroSalida) ;
    flujoMarkAIML.yylex() ;

    return 0 ;
}
void procesar(string resto,ofstream &salida){
    ifstream Pentrada ;
    ofstream Psalida ;
    Psalida.open ("buffer.txt") ;
    if (!Psalida.is_open()){
            cout << "Error de buffer - Salida" << endl ;
            exit(-4) ;
    }
    Psalida << resto ;
    Psalida.close() ;
    Pentrada.open ("buffer.txt") ;
    if (!Pentrada.is_open()){
            cout << "Error de buffer - Entrada" << endl ;
            exit(-5) ;
    }
    yyFlexLexer flujoAuxiliar (&Pentrada, &salida) ;
    flujoAuxiliar.yylex() ;
}

void abrirTag(string tag,ofstream &salida){
    salida << "<" << tag << ">" ;
}

void cerrarTag(string tag,ofstream &salida){
    salida << "</" << tag << ">" ;
}

void cerrarTagEnter(string tag,ofstream &salida){
    salida << "</" << tag << ">" << endl ;
}