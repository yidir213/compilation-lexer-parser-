%{
#include "synt.tab.h"
int numLigne = 1;
int codeOp = 0;
char sauvType[20];
char nomIdf[20];
char sauvNomFonc[20];
int a;
int b;
%}

%union{
 int entier;
 char* str;
 float Fl;
};

%token <str>idf mc_langage mc_var dp pvg <str>mc_int <str>mc_float <str>mc_bool vg mc_bgn mc_end <entier>cst aff err
		plus minus mult division mcWhile ov fr ls gt lse gte eq neq mcIf
		Fun retun mc_cst <Fl>cstr mctrue mcfalse
%%

S: mc_langage idf mc_var ListDec Fonction {strcpy(sauvNomFonc,"main");} mc_bgn ListInsts mc_end{printf("Syntaxe correcte.\n"); YYACCEPT;}
;

Fonction: Type Fun idf mc_var ListDec mc_bgn ListInsts retun EXP pvg mc_end {strcpy(sauvNomFonc,$3);}
          |
;

ListDec: Dec ListDec
        |Dec
;

Dec: DecVar 
;

DecVar: ListeIdfs dp Type pvg {doubleDeclarationListeIdfs(sauvType);}
	   |ListeIdfsInit dp mc_cst Type pvg {doubleDeclarationListeIdfs1(sauvType); }
	   |ListeIdfs dp mc_cst Type pvg {doubleDeclarationListeIdfs1(sauvType);}
		                             
;

Type: mc_int {strcpy(sauvType,$1);}
     |mc_float{strcpy(sauvType,$1);}
     |mc_bool {strcpy(sauvType,$1);}
;

ListeIdfs: idf vg ListeIdfs {sauvListeIdfs($1);}
          |idf {sauvListeIdfs($1); strcpy(nomIdf,$1);}
;

ListeIdfsInit: idf aff cst vg ListeIdfsInit{sauvListeIdfs($1);InitConst($1);}				
			  |idf aff cst {sauvListeIdfs($1);InitConst($1);strcpy(nomIdf,$1);}

ListInsts: Inst ListInsts
          |
;

Inst: Affectation 
	| LOOP
	| IF
;

IF: mcIf ov CONDITION fr mc_bgn Inst mc_end 
	|mcIf ov CONDITION fr mc_bgn mc_end 
;

LOOP: mcWhile ov CONDITION fr mc_bgn Inst mc_end
	|mcWhile ov CONDITION fr mc_bgn  mc_end
;

CONDITION: EXP OPRAT EXP 
; 

OPRAT: ls 
	| gt 
	| gte 
	| lse 
	| eq 
	| neq 
;

Affectation: idf aff EXP pvg {
		                      if(Constante($1)==1) printf("Erreur semantique: changement de valeur de la constante %s à ligne %d\n", $1, numLigne);
		                      else declaredNonIntialaizedCst($1);
		                      if(Declared($1)==0) printf("Erreur sémantique: variable %s non declarée à la ligne %d\n", $1, numLigne);
		                      if( a==1 && typeEntier($1)) printf("Erreur sémantique: type incompatibe de %s (valeur INT à une variable FLOAT) à la ligne %d\n", $1, numLigne);
		                      if( a==0 && typeFloat($1)) printf("Erreur sémantique: type incompatibe de %s (valeur FLOAT à une variable INT) à la ligne %d\n", $1, numLigne);
		                      //if(checkIfConst($1)) printf("Erreur sémantique: double declaration de constante %s à la ligne %d\n", $1, numLigne);
			                 }
			|idf aff booll pvg{
			                   if(typeEntier($1)||typeFloat($1))printf("Erreur sémantique : type incompatibe de %s (valeur BOOL à une variable FLOAT ou INT) à la ligne %d\n", $1, numLigne);
		                      }
				      |idf plus plus pvg
;

booll : mctrue | mcfalse
;

EXP : idf OPR EXP 
	| cst OPR EXP
	|	idf
	| cstr OPR EXP	 {a=1;}
	| 	cstr         {a=1;}
	|	cst {a=0;
	         if(codeOp ==3 && $1==0)
				printf("Erreur sémantique: Division sur 0 à la ligne %d\n", numLigne);
		    }
;

OPR: plus {codeOp=0;}
	| minus {codeOp=1;}
    | mult {codeOp=2;}
	| division{codeOp=3;}
;

%%

main () 
{
printf("Le Compilateur MiniAlgo: \n");
yyparse();
Afficher();
}
yywrap()
{}
int yyerror(char*msg){
printf ("Erreur syntaxique à la ligne %d", numLigne);
}