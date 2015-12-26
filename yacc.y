%{
#include "main.h"	//lex和yacc要共用的头文件，里面包含了一些头文件
#include <stdlib.h>  
#include <stdio.h>  
#include "tree.c" 
#include "IR.c" 
  
TreeNode* p;  
FILE *fout1;

  					
	void yyerror(char *s);
	extern int Line;//改变量外部定义，为了能编译和链接，必须用extern加以声明

TreeNode* newNode (char* node_name,int line)  
{  
    
    TreeNode * p=(TreeNode *)malloc(sizeof(struct Node));  
    if (p==NULL)  
    {  
        printf("Error:out of memory.\n");  
        exit(1);  
    }    
    p->name=strdup(node_name);////原本用的strncpy，ｎ为20报错
    p->brother=NULL;
    p->child=NULL;  
    p->Line=line;   
    p->col=0;  
 
    return p;  
};
%}

%union{  
        struct Node* treeNode; 
} 
/*lex里要return的记号的声明用%type<member>来定义(否则会报错)，以指明它们的属性对应YYSTYPE中哪个成员，这时对该非终结符的引用，如$$，会自动替换为$$.member*/

%token<treeNode> INTEGER IDENTIFIER SEMI COMMA LC RC STRUCT RETURN IF ELSE BREAK CONT FOR READ WRITE    
%right<treeNode>  TYPE ASSIGNOP BINARYOP11  
%left<treeNode>  BINARYOP10  
%left<treeNode>  BINARYOP9  
%left<treeNode>  BINARYOP8  
%left<treeNode>  BINARYOP7  
%left<treeNode>  BINARYOP6  
%left<treeNode>  BINARYOP5  
%left<treeNode>  BINARYOP4  
%left<treeNode>  BINARYOP3  
%left<treeNode>  BINARYOP2 SUB 
%left<treeNode>  BINARYOP1  
%right<treeNode> UNARYOP MINUS
%left<treeNode>  DOT  LP RP LB RB  

%start program
%type <treeNode> program extdefs extdef extvars spec stspec opttag var func paras para stmtblock stmts stmt estmt defs def decs dec init exp exps arrs args  
%%  

program :   
           extdefs    { 
			p=newNode("program",$1->Line);  
                       link(p,$1);  
                       $$ =p;}  
        ;  
extdefs :   
           extdef extdefs  { 
				p=newNode("extdefs",$1->Line);  
                            link(p,$1); link(p,$2);  
                            $$=p;}  
        |                   { p=newNode("NULL",0);  
                                $$=p;}  
        ;  
extdef  :    
           spec extvars SEMI  { 
				p=newNode("extdef",$1->Line);  
                                link(p,$1);  link(p,$2);  link(p,$3);  
                                $$=p;}  
        |  spec func stmtblock { p=newNode("extdef",$1->Line);  
                                link(p,$1); link(p,$2); link(p,$3);  
                                $$=p;}  
        ;  
extvars :  
           dec                 { p=newNode("extvars",$1->Line);  
                                 link(p,$1);  
                                 $$=p;}  
        |  dec COMMA extvars   { p=newNode("extvars",$1->Line);  
                                link(p,$1); link(p,$2); link(p,$3);  
                                $$=p;}  
        |                       { p=newNode("NULL",0);  
                                $$=p;}  
        ;  
spec    :  
           TYPE                 { p=newNode("type",$1->Line);  
                                 link(p,$1);  
                                 $$=p;}   
        |  stspec               { p=newNode("spec",$1->Line);  
                                 link(p,$1);  
                                 $$=p;}        
        ;  
stspec  :  
           STRUCT opttag LC defs RC { p=newNode("stspec",$1->Line);  
                                link(p,$1);  link(p,$2); link(p,$3); link(p,$4); link(p,$5);  
                                $$=p;}  
        | STRUCT IDENTIFIER             { p=newNode("stspec",$1->Line);  
                                link(p,$1); link(p,$2);  
                                $$=p;}  
        ;  
opttag  :  
           IDENTIFIER                   {p=newNode("opttag",$1->Line);  
                                link(p,$1);  
                                $$=p;}  
        |                       { $$=NULL;}  
        ;  
var     :    
           IDENTIFIER                   {p=newNode("var",$1->Line);  
                                link(p,$1);  
                                $$=p;}  
        |  var LB INTEGER RB       { p=newNode("var",$1->Line);  
                                link(p,$1); link(p,$2); link(p,$3); link(p,$4);  
                                $$=p;}  
        ;  
func    :  
           IDENTIFIER LP paras RP       {p=newNode("func",$1->Line);  
                                link(p,$1); link(p,$2); link(p,$3); link(p,$4);  
                                $$=p;}  
        ;  
paras   :  
           para COMMA paras     {p=newNode("paras",$1->Line);  
                                link(p,$1); link(p,$2); link(p,$3);  
                                $$=p;}  
        |  para                 { p=newNode("paras",$1->Line);  
                                link(p,$1);  
                                $$=p;}  
        |                        { p=newNode("NULL",0);  
                                $$=p;}  
        ;  
para    :    
           spec var            { p=newNode("para",$1->Line);  
                                link(p,$1);link(p,$2);  
                                $$=p;}   
        ;  
stmtblock :   
           LC defs stmts RC     {p=newNode("stmtblock",$1->Line);  
                                link(p,$1);link(p,$2);link(p,$3);link(p,$4);  
                                $$=p;}  
          ;  
stmts     :  
            stmt stmts          {p=newNode("stmts",$1->Line);  
                                link(p,$1); link(p,$2);  
                                $$=p;}  
          |                     { p=newNode("NULL",0);  
                                $$=p;}  
          ;  
stmt      :  
            exp SEMI            {p=newNode("stmt",$1->Line);  
                                link(p,$1); link(p,$2);  
                                $$=p;}  
          |  stmtblock           { p=newNode("stmt",$1->Line);  
                                link(p,$1);  
                                $$=p;}  
          |  RETURN exps SEMI     { p=newNode("stmt",$1->Line);  
                                link(p,$1); link(p,$2);  link(p,$3);  
                                $$=p;}  
          | IF LP exps RP stmt estmt  { p=newNode("stmt",$1->Line);  
                                link(p,$1);  link(p,$2); link(p,$3); link(p,$4);link(p,$5); link(p,$6);  
                                $$=p;}  
          | FOR LP exp SEMI exp SEMI exp RP stmt { p=newNode("stmt",$1->Line);  
                                link(p,$1);  
                                link(p,$2); link(p,$3); link(p,$4); link(p,$5); link(p,$6); link(p,$7); link(p,$8); link(p,$9);  
                                $$=p;}  
          | CONT SEMI           { p=newNode("stmt",$1->Line); link(p,$1); link(p,$2);  
                                $$=p;}  
          | BREAK SEMI          { p=newNode("stmt",$1->Line); link(p,$1); link(p,$2);  
                                $$=p;}  
          | WRITE LP exp RP SEMI    { p=newNode("stmt",$1->Line);  
                                link(p,$1); link(p,$2); link(p,$3); link(p,$4); link(p,$5);  
                                $$=p;}  
          | READ LP exp RP SEMI    { p=newNode("stmt",$1->Line);  
                                link(p,$1); link(p,$2); link(p,$3); link(p,$4); link(p,$5);  
                                $$=p;}  
          ;  
estmt      :  
            ELSE stmt            {p=newNode("estmt",$1->Line);  
                                link(p,$1); link(p,$2);  
                                $$=p;}  
          |                      { p=newNode("NULL",0);  
                                $$=p;}  
          ;  
defs      :  
            def defs            {p=newNode("defs",$1->Line); link(p,$1); link(p,$2);  
                                $$=p;}  
          |                      { p=newNode("NULL",0);  
                                $$=p;}  
          ;  
def       :  
            spec decs SEMI      {p=newNode("def",$1->Line);  
                                link(p,$1); link(p,$2); link(p,$3);  
                                $$=p;}  
          ;  
decs      :   
            dec COMMA decs     {p=newNode("decs",$1->Line);  
                                link(p,$1); link(p,$2); link(p,$3);  
                                $$=p;}  
          | dec                { p=newNode("decs",$1->Line);  
                                link(p,$1);  
                                $$=p;}  
          ;  
dec       :  
            var                {p=newNode("dec",$1->Line);  
                                link(p,$1);  
                                $$=p;}  
          | var ASSIGNOP init  { p=newNode("dec",$1->Line);  
                                link(p,$1); link(p,$2); link(p,$3);  
                                $$=p;} 
	  ; 
init      :  
             exp                {p=newNode("init",$1->Line); link(p,$1);  
                                $$=p;}  
          |  LC args RC          { p=newNode("init",$1->Line);  
                                link(p,$1); link(p,$2); link(p,$3);  
                                $$=p;}  
          ;  
 

exps       :  
             exp BINARYOP1 exp     {p=newNode("exp",$1->Line);  
                                link(p,$1); link(p,$2); link(p,$3);  
                                $$=p;}  
        |   exp BINARYOP2 exp     { p=newNode("exp",$1->Line); link(p,$1);  
                                link(p,$2); link(p,$3);  
                                $$=p;}  
        |   exp BINARYOP3 exp     { p=newNode("exp",$1->Line);  
                                link(p,$1); link(p,$2); link(p,$3);  
                                $$=p;}  
        |   exp BINARYOP4 exp     { p=newNode("exp",$1->Line);  
                                link(p,$1); link(p,$2); link(p,$3);  
                                $$=p;}  
        |   exp BINARYOP5 exp     { p=newNode("exp",$1->Line);  
                                link(p,$1); link(p,$2); link(p,$3);  
                                $$=p;}  
        |   exp BINARYOP6 exp     { p=newNode("exp",$1->Line);  
                                link(p,$1); link(p,$2); link(p,$3);  
                                $$=p;}  
        |   exp BINARYOP7 exp     { p=newNode("exp",$1->Line);  
                                link(p,$1); link(p,$2); link(p,$3);  
                                $$=p;}  
        |   exp BINARYOP8 exp     { p=newNode("exp",$1->Line);  
                                link(p,$1); link(p,$2); link(p,$3);  
                                $$=p;}  
        |   exp BINARYOP9 exp     { p=newNode("exp",$1->Line);  
                                link(p,$1); link(p,$2); link(p,$3);  
                                $$=p;}  
        |   exp BINARYOP10 exp     { p=newNode("exp",$1->Line);  
                                link(p,$1); link(p,$2); link(p,$3);  
                                $$=p;}  
          | exp BINARYOP11 exp  {p = newNode("exp", $1->Line);  
                                        link(p, $1);  
                                        link(p, $2);  
                                        link(p, $3);  
                                        $$ = p;}  
          | exp ASSIGNOP exp    {p = newNode("exp", $1->Line);  
                                   link(p, $1);  
                                   link(p, $2);  
                                   link(p, $3);  
                                $$ = p;}  
          | exp SUB exp        {p = newNode("exp", $1->Line);  //改成exps SUB exp 会好一点？
                                      link(p, $1);  
                                      link(p, $2);  
                                      link(p, $3);  
                                      $$ = p;}  
          |  UNARYOP exp        { p=newNode("exp",$1->Line);  
                                link(p,$1); link(p,$2);  
                                $$=p;}  
          | SUB exp %prec MINUS   {p = newNode("exp", $1->Line);  
                                        link(p, $1);  
                                        link(p, $2);  
                                        $$ = p;}  
          |  LP exp RP          { p=newNode("exp",$1->Line);  
                                link(p,$1); link(p,$2); link(p,$3);  
                                $$=p;}  
          |  IDENTIFIER LP args RP      { p=newNode("exp",$1->Line);  
                                link(p,$1); link(p,$2); link(p,$3); link(p,$4);  
                                $$=p;}  
          |   IDENTIFIER arrs           { p=newNode("exp",$1->Line);  
                                link(p,$1); link(p,$2);  
                                $$=p;}  
          |   exp DOT IDENTIFIER      { p=newNode("exp",$1->Line);  
                                link(p,$1); link(p,$2); link(p,$3);  
                                $$=p;}  
          |  INTEGER               { p=newNode("exp",$1->Line);  
                                link(p,$1);  
                                $$=p;}  
          ;  

exp       :  exps               {TreeNode *p=$1; $$=p;}              
          |                    {p=newNode("exp-null",0);  
                                $$=p;}  
          ; 

arrs      :  
             LB exp RB arrs    {p=newNode("arrs",$1->Line);  
                                link(p,$1); link(p,$2); link(p,$3); link(p,$4);  
                                $$=p;}  
          |                     { p=newNode("arrs",0);  
                                $$=p;}  
          ;   
args      :  exp COMMA args    {p=newNode("args",$1->Line);  
                                link(p,$1); link(p,$2); link(p,$3);  
                                $$=p;}  
          | exp                { p=newNode("args",$1->Line);  
                                link(p,$1);  
                                $$=p;}  
          ;  
%%  

void yyerror(char *s)			//当yacc遇到语法错误时，会回调yyerror函数，并且把错误信息放在参数s中
{
	 FILE* errdir=NULL;  
     errdir=fopen("stderr","w");  
     if(fout1!=NULL)  
     fprintf(fout1,"Error.");  
     fprintf(errdir,"line %d error.\n",Line);  
     fclose(fout1);  
     fclose(errdir);  
     exit(1); 
}

int main(int argc,char *argv[])		//程序主函数，这个函数也可以放到其它.c, .cpp文件里
{
	FILE* fin=NULL;  //yyin和yyout都是FILE*类型
     extern FILE* yyin;  
     fin=fopen(argv[1],"r");   //打开要读取的文本文件
     fout1=fopen(argv[2],"w");  
     if(fin==NULL)  
     {   
         printf("cannot open reading file.\n");  
         return -1;  
     }  
     yyin=fin;  //yacc会从yyin读取输入，yyin默认是标准输入，这里改为磁盘文件。yacc默认向yyout输出，可修改yyout改变输出目的
     yyparse();  //使yacc开始读取输入和解析，它会调用lex的yylex()读取记号
	 TreeNode* root = p;
     printTree(p,fout1);  
	 program(root);
     fclose(fin);  
     fclose(fout1);  
     return 0; 
 

}
