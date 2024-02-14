%{
#include "synt.tab.h"
extern int numLigne;
extern YYSTYPE yylval;
#include "fun.h"
%}

lettre [a-zA-Z]
chiffre [0-9]
chiffre2 [1-9]
idf {lettre}({lettre}|{chiffre}|_({chiffre}|{lettre}))*
cst {chiffre}+
boole true|false
cstreel {cst}(.{chiffre}*{chiffre2})

%%

LANGAGE return mc_langage;
VAR return mc_var;
INT {yylval.str=strdup(yytext);
	return mc_int;}
FLOAT {yylval.str=strdup(yytext);
	return mc_float;}
BOOL {yylval.str=strdup(yytext);
	return mc_bool;}
BEGIN return mc_bgn;
END return mc_end;
While return mcWhile;
If return mcIf;
Function return Fun;
Return return retun;
CONST return mc_cst;
TRUE return mctrue;
FALSE return mcfalse;
{idf} {	if(yyleng>12){ 
		printf("Erreur lexicale sur l`entite %s\n",yytext);
		return err;}
		else {
		yylval.str=strdup(yytext);
			inserer(yytext,"idf");
			return idf;}
			}
{cst} {	yylval.entier = atoi(yytext);
		return cst;}
{cstreel} {yylval.Fl = atoi(yytext);
				return cstr;}
: return dp;
; return pvg;
, return vg;
= return aff;
"+" return plus;
"-"	return minus;
"*"	return mult;
"/" return division;
"(" return ov;
")" return fr;
"<" return ls;
">" return gt;
"<=" return lse;
">=" return gte;
"==" return eq;
"<>" return neq;
[ \t]
[{][^}]*[}]
\n numLigne++;
. printf("Erreur lexicale à la ligne %d sur l'entité %s\n", numLigne, yytext);
%%