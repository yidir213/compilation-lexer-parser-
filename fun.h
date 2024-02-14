#include <stdlib.h>
struct Node{
  char nomEn[20];
  char codeEn[20];
  char typeEn[20];
  int constant;
  int constInit;
  char nomF[20];
  struct Node *next;
};

extern char sauvNomFonc[20];


struct Node *head,*node;


struct Node *rechercher(struct Node *head,char entite[]){
    // Base case
    if (head == NULL)
        return NULL;
 
    // If key is present in current node, return true
    if (strcmp(head->nomEn, entite)==0)
        return head;
 
    // Recur for remaining list
    return rechercher(head->next, entite);
}
void inserer(char entite[],char Code[])
{
	if (rechercher(head,entite)==NULL){
    /* allocate node */
    struct Node* new_node
        = (struct Node*)malloc(sizeof(struct Node));
 
    /* put in the key  */
    //new_node->nomEn = strdup(entite);
	strcpy(new_node->nomEn,entite);
	strcpy(new_node->codeEn,Code);
	strcpy(new_node->typeEn,"");
	strcpy(new_node->nomF,"main");
	new_node->constant=0;
	new_node->constInit=0;
    /* link the old list off the new node */
    new_node->next = head;
 
    /* move the head to point to the new node */
    head = new_node;
	}
}

void insererType(char entite[],char Type[])
{
	struct Node *pos;
	pos= rechercher(head,entite);
    if(pos!=NULL){
		strcpy(pos->typeEn,Type);
		strcpy(pos->nomF, sauvNomFonc);
	} 
}
int doubleDeclaration(char entite[]){
	struct Node *pos;
	pos= rechercher(head,entite);
	if(strcmp(pos->typeEn,"")==0)return 0;
	return -1;
}

void SauvInfoConst(char entite[]){
	struct Node *pos;
	pos= rechercher(head,entite);
	if(pos->constant==0)pos->constant = 1;
}

void insererNomFonc(char entite[], char nomFonc[])
{
	struct Node *pos;
	pos = rechercher(head,entite);
    if(pos!=NULL){
		strcpy(pos->nomF, nomFonc);
	} 
}

int Constante(char entite[]){
	struct Node *pos;
	pos= rechercher(head,entite);
	if(pos->constant==1&& pos->constInit==1)return 1;
	pos->constInit==1;
	return 0;
}
void InitConst(char entite[]){
	struct Node *pos;
	pos= rechercher(head,entite);
	pos->constInit=1;
}

void Afficher(){
	printf("\n**************************************************************** Table de symbole ***************************************************************\n");
	printf("_________________________________________________________________________________________________________________________________________________\n");
	printf("|     NomEntité     |      CodeEntité        |       TypeEnitité       |       Constante       |        InitConst       |       NomFonction      |\n");
	printf("_________________________________________________________________________________________________________________________________________________\n");
	node = head;
	while(node!=NULL)
    {
        printf("|   %12s    |     %12s       |      %12s       |     %12d      |      %12d      |      %12s      |\n", node->nomEn, node->codeEn, node->typeEn, node->constant, node->constInit, node->nomF);
        node = node->next;
    }
	
    printf("\n");
}
struct ListeIdfs{
  char str[20];
  struct ListeIdfs *next;
};

struct ListeIdfs *h ,*p;

void inserer1(char entite[])
{
	
    struct ListeIdfs* new_node
        = (struct ListeIdfs*)malloc(sizeof(struct ListeIdfs));
 
 
	strcpy(new_node->str,entite);
	
    new_node->next = h;
	
	h=new_node;
}


void sauvListeIdfs(char idf[]){
	
	inserer1(idf);
}

void doubleDeclarationListeIdfs(char type[])
{
	
	p = h;
	
	while(p!=NULL){
		
		struct Node *pos;
		
		pos= rechercher(head,p->str);
		
		if(strcmp(pos->typeEn,"")==0) insererType(p->str, type);
		
		else if(strcmp(pos->nomF,"")!=0) printf("Erreur sémantique: double déclation de %s, à la ligne %d\n",p->str,numLigne);
		
		p=p->next;
	}
	
	p=h;
	
    while (h != NULL)
    {
       p = h;
       h = h->next;
       free(p);
    }
}
void doubleDeclarationListeIdfs1(char type[])
{
	
	p = h;
	
	while(p!=NULL){
		
		struct Node *pos;
		
		pos= rechercher(head,p->str);
		pos->constant=1;
		
		if(strcmp(pos->typeEn,"")==0) insererType(p->str, type);
		
		else if(strcmp(pos->nomF,"")!=0) printf("Erreur sémantique: double déclation de %s, à la ligne %d\n",p->str,numLigne);
		
		p=p->next;
	}
	
	p=h;
	
    while (h != NULL)
    {
       p = h;
       h = h->next;
       free(p);
    }
}

int Declared(char entite[]){
	struct Node *pos;
	pos= rechercher(head,entite);
	
	if(strcmp(pos->typeEn,""))return 1;
	else return 0;
}

int typeEntier(char entite[]){
	struct Node *pos;
	pos= rechercher(head,entite);
	
	if(strcmp(pos->typeEn,"INT"))return 0;
	else return 1;
}
int typeFloat(char entite[]){
	struct Node *pos;
	pos= rechercher(head,entite);
	
	if(strcmp(pos->typeEn,"FLOAT"))return 0;
	else return 1;
}
void declaredNonIntialaizedCst(char entite[]){
	struct Node *pos;
	pos= rechercher(head,entite);
	if(pos->constant==1&&pos->constInit==0)
		pos->constInit=1;
}
