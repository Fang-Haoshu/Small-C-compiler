#include <malloc.h>
#include <stdio.h>
#include <stdlib.h>
#include "main.h"

struct symbol
{
    char* word;
    char type;
    int arrSize;
    char* structName;
    int structMem;
};
struct symbol* symTable[27][20]; //symbol Table

int rNum, callNum, ifNum, forNum, arridxNum; //for register allocation
int paraFlag = 0; //paremetres flag
int paraPoint = 0; //parameters point
char* paraArr[10]; //parametres array
int entryDepth = 0; //depth of stmtblocks
int loadFlag = 1; //load or not?
char* arrName; //array Name
int arrPtr; // which element in array
int arrSize; //array size
char* strName; //struct name
int structMemNum; //Number of struct members
FILE *fout;

void argsFunc(TreeNode* p);
char* Exps(TreeNode* p);
char* Exp(TreeNode* p);
void stmt(TreeNode* p);
void stmts(TreeNode* p);
void ExpInner(TreeNode* p);
void InnerArgs(TreeNode* p);
void decStrIdINT(TreeNode* p);
void initArgs(TreeNode* p);
void args(TreeNode* p);
void para(TreeNode* p);
void paras(TreeNode* p);
void ExpArgs(TreeNode* p);
void stmtblock(TreeNode* p);
void extvarsType(TreeNode* p);
void defs(TreeNode* p);
void def(TreeNode* p);
void decInner(TreeNode* p);
void decsInner(TreeNode* p);
void decStrId(TreeNode* p);
void extvarsStrId(TreeNode* p);
void extdefStrID(TreeNode* p);
void defInStr(TreeNode* p);
void defsInStr(TreeNode* p);
void extdefStrOp(TreeNode *p);
void extvarsStruct(TreeNode * p);
void extdef(TreeNode *p);
void extdefs(TreeNode * p);
void func(TreeNode* p);


void program(TreeNode * root)
{
	
	fout = fopen("IR.ll","w");
	extdefs(root->child);
}

void extdefs(TreeNode * p)
{
	if(p->child!= NULL)
	{
	extdef(p->child);
	extdefs(p->child->brother);
	}

}

void extdef(TreeNode *p)
{
	if(!strcmp(p->child->brother->name,"func"))//spec func stmtblock
	{
		//We don't need to check SPEC anymore, cause all the functions in Small-C returns INT
		func(p->child->brother);
		stmtblock(p->child->brother->brother);
	}
	else if(!strcmp(p->child->name,"type"))
	{	
		extvarsType(p->child->brother);
	}
	else if(!strcmp(p->child->name,"spec"))
	{
		extvarsStruct(p);
	}
	else
		printf("error in %d",p->Line);
}

void extvarsStruct(TreeNode * p)
{
	if(p->child->child->child->brother->brother != NULL)//STRUCT opttag LC defs RC
	{
		extdefStrOp(p);
	}
	else//STRUCT IDENTIFIER
	{
		extdefStrID(p);
	}
}

void extdefStrOp(TreeNode *p)
{
	TreeNode *tmp = p->child->child->child->brother->child;//IDENTIFIER
	fprintf(fout,"%%struct.%s = type { ",tmp->name);
	structMemNum = 0;
	defsInStr(p->child->child->child->brother->brother->brother);//DEFS in STRUCT opttag LC defs RC
	structMemNum = 0;
	fprintf(fout," } \n");
	//假设struct定义之后不会立即声明。 ASSUME there is no  STRUCT IDENTIFIER extvars SEMI;
}

void defsInStr(TreeNode* p) //definitons, for STSPEC -> STRUCT OPTTAG LC DEFS RC case
{
	if(p->child!=NULL)
	{
		defInStr(p->child);
		structMemNum++;
		if(p->child->brother->child != NULL) fprintf(fout,", ");
		defsInStr(p->child->brother);
	}

}

void defInStr(TreeNode* p)//definiton, for STSPEC -> STRUCT OPTTAG LC DEFS RC case
{
	TreeNode* tmpvar = p->child->brother->child->child->child;//IDENTIFIER
	int dim1=0;
	if(tmpvar->name[0]<'A' || tmpvar->name[0]>'z') dim1=26;
	else dim1 = (tmpvar->name[0] <= 'Z') ? tmpvar->name[0]-'A' : tmpvar->name[0]-'a';
	
	int i=0;
    while (symTable[dim1][i]) i++;//find an empty place
    symTable[dim1][i] = (struct symbol*)malloc(sizeof(struct symbol));
    struct symbol* s = symTable[dim1][i];
    s->word = (char*)malloc(sizeof(char)*200);
    strcpy(s->word,tmpvar->name); //don't need s->type here
    s->structMem = structMemNum;

    fprintf(fout,"i32");
}

void extdefStrID(TreeNode* p)//external definiton for STRUCT IDENTIFIER
{
	//CAN DO CHECK HERE, TO SEE IF IDENTIFIER REALLY EXISTS
	strName = (char*)malloc(sizeof(char)*200);

    TreeNode* nodeId = p->child->child->child->brother;
    strcpy(strName,nodeId->name);
    extvarsStrId(p->child->brother);

    free(strName);
}

void extvarsStrId(TreeNode* p) //external variables for STRUCT ID
{
    if(p->child == NULL){}
    else if (p->child->brother!=NULL)
    {
        decStrId(p->child);
        extvarsStrId(p->child->brother->brother);
    }
    else decStrId(p->child);
}

void decStrId(TreeNode* p)//declaration
{
	TreeNode* tmp = p->child;//var
	if(tmp->brother == NULL)//without init
	{
		TreeNode* id = tmp->child;// IDENTIFIER, ASSUME there is no a[] in struct;
		fprintf(fout,"@%s = common global %%struct.%s zeroinitializer, align 4\n",id->name,strName);
		
		int dim1=0;
		if(id->name[0]<'A' || id->name[0]>'z') dim1 = 26;
		else dim1 = (id->name[0]<='Z')? id->name[0]-'A':id->name[0]-'a';
		int i=0;
		while (symTable[dim1][i]) i++;
		symTable[dim1][i] = (struct symbol*)malloc(sizeof(struct symbol));
		struct symbol* s = symTable[dim1][i];
		s->word = (char*)malloc(sizeof(char)*200);
		strcpy(s->word,tmp->child->name);
		s->structName = (char*)malloc(sizeof(char)*200);
		strcpy(s->structName,strName);
		s->type = 'g';
	}
	else{//dec = var ASSIGNOP init
		//WAIT FOR FUTURE WORK, TO INIT VAR
	}
}

void extvarsType(TreeNode* p)
{
	if(p->child->brother == NULL)
	{
		decStrIdINT(p->child);
	}
	else
	{
		decStrIdINT(p->child);
		extvarsType(p->child->brother->brother);
	}
}

void decStrIdINT(TreeNode* p)//p is dec
{


	if(p->child->brother == NULL)//no init
	{
		if(p->child->child->brother ==NULL ) //IDENTIFIER
		{
			TreeNode* id = p->child->child;
			fprintf(fout,"@%s = common global i32 0, align 4\n",id->name);
			int dim1 = 0;
			if(id->name[0]<'A' || id->name[0]>'z') dim1 = 26;
				else dim1 = (id->name[0]<='Z')? id->name[0]-'A':id->name[0]-'a';
			int i=0;
			while (symTable[dim1][i]) i++;
			symTable[dim1][i] = (struct symbol*)malloc(sizeof(struct symbol));
			struct symbol* s = symTable[dim1][i];
			s->word = (char*)malloc(sizeof(char)*60);
            strcpy(s->word,id->name);
            s->type = 'g';
		}
		else//var LB INTEGER RB , ASSUME there is only one dimension of array
		{
			TreeNode* id = p->child->child->child;//IDENTIFIER
			TreeNode* var = p->child->child;//var LB INTEGER RB
			fprintf(fout,"@%s = common global [ %d x i32] zeroinitializer,",id->name,atoi(var->brother->brother->name));
			fprintf(fout, " align %d\n",atoi(var->brother->brother->name)*4);
			
			int dim1 = 0;
			if(id->name[0]<'A' || id->name[0]>'z') dim1 = 26;
				else dim1 = (id->name[0]<='Z')? id->name[0]-'A':id->name[0]-'a';
			int i=0;
			while (symTable[dim1][i]) i++;
			symTable[dim1][i] = (struct symbol*)malloc(sizeof(struct symbol));
			struct symbol* s = symTable[dim1][i];
			s->word = (char*)malloc(sizeof(char)*60);
            strcpy(s->word,id->name);
            s->type = 'g';
			s->arrSize = atoi(var->brother->brother->name);
		}
	}

	else //need to init
	{
		if(p->child->child->brother == NULL ) //IDENTIFIER with init value
		{
			TreeNode* id = p->child->child;
			TreeNode* initVal = p->child->brother->brother->child->child;//ASSUME there is only one integer in the init.
			fprintf(fout,"@%s = global i32 %d, align 4\n",id->name, atoi(initVal->name));
			
			int dim1 = 0;
			if(id->name[0]<'A' || id->name[0]>'z') dim1 = 26;
			else dim1 = (id->name[0]<='Z')? id->name[0]-'A':id->name[0]-'a';
			int i=0;
			while (symTable[dim1][i]) i++;
			symTable[dim1][i] = (struct symbol*)malloc(sizeof(struct symbol));
			struct symbol* s = symTable[dim1][i];
			s->word = (char*)malloc(sizeof(char)*60);
            strcpy(s->word,id->name);
            s->type = 'g';
		}
		else//var LB INTEGER RB , ASSUME there is only one dimension of array
		{
			TreeNode* id = p->child->child->child;
			TreeNode* var = p->child->child;

			fprintf(fout,"@%s = global [%d x i32] [", id->name,atoi(var->brother->brother->name));
			initArgs(p->child->brother->brother);//init
			fprintf(fout,"], align %d\n",atoi(var->brother->brother->name));

			int dim1 = 0;
			if(id->name[0]<'A' || id->name[0]>'z') dim1 = 26;
			else dim1 = (id->name[0]<='Z')? id->name[0]-'A':id->name[0]-'a';
			int i=0;
			while (symTable[dim1][i]) i++;
			symTable[dim1][i] = (struct symbol*)malloc(sizeof(struct symbol));
			struct symbol* s = symTable[dim1][i];
			s->word = (char*)malloc(sizeof(char)*60);
            strcpy(s->word,id->name);
            s->type = 'g';
			s->arrSize = atoi(var->brother->brother->name);
		}
	}
}

void initArgs(TreeNode* p)
{
	args(p->child->brother);//args
}

void args(TreeNode* p)//ASSUME the Exp in args is just INTEGER
{
	if(p->child->brother == NULL)
	{
		ExpArgs(p->child);
	}
	else
	{
		ExpArgs(p->child);
		fprintf(fout,", ");
		args(p->child->brother->brother);
	}
}

void ExpArgs(TreeNode* p)//Exp in args
{
	fprintf(fout,"i32 %d", atoi(p->child->name));
}

void func(TreeNode* p)//func
{
	fprintf(fout,"define i32 @%s(",p->child->name);
	paras(p->child->brother->brother);
	fprintf(fout,") #0 {\n");
}

void paras(TreeNode* p)
{
	if(!strcmp(p->name,"NULL")){
		paraFlag = 0;
	}//para is empty
	else if(p->child->brother == NULL )//PARA
	{
		paraFlag = 1;
		para(p->child);
	}
	else//PARA COMMA PARAS
	{
		paraFlag = 1;
		para(p->child);
		fprintf(fout,", ");
		paras(p->child->brother->brother);
	}
}

void para(TreeNode* p)
{
	TreeNode* id = p->child->brother->child;//ASSUME the type is always INT and the var is always IDENTIFIER
	fprintf(fout, "i32 %%%s",id->name);
	
	int dim1 = 0;
	if(id->name[0]<'A' || id->name[0]>'z') dim1 = 26;
	else dim1 = (id->name[0]<='Z')? id->name[0]-'A':id->name[0]-'a';
	int i=0;
	while (symTable[dim1][i]) i++;
	symTable[dim1][i] = (struct symbol*)malloc(sizeof(struct symbol));
	struct symbol* s = symTable[dim1][i];
	s->word = (char*)malloc(sizeof(char)*60);
    strcpy(s->word,id->name);
    s->type = 'a';
	
	paraArr[paraPoint] = (char*)malloc(sizeof(char)*60);//WHAT IS IT??????????????????
    strcpy(paraArr[paraPoint],id->name);
    paraPoint++;
}

void stmtblock(TreeNode* p)
{
	if (!entryDepth)
    {
        fprintf(fout,"entry:\n");
    }

    if (paraFlag)
    {
        //%x.addr = alloca i32, align 4
        //store i32 %x, i32* %x.addr, align 4
        int i=0;
        while (paraArr[i])
        {
            fprintf(fout,"  %%%s.addr = alloca i32, align 4\n",paraArr[i]);
            fprintf(fout,"  store i32 %%%s, i32* %%%s.addr, align 4\n",paraArr[i],paraArr[i]);
            free(paraArr[i]);
            i++;
        }
        paraFlag = 0;
        paraPoint = 0;
    }

    defs(p->child->brother);
    stmts(p->child->brother->brother);

    if (!entryDepth) fprintf(fout, "}\n");
}

void defs(TreeNode* p)
{
	if(!strcmp(p->name,"NULL")){}
	else
	{
		def(p->child);
		defs(p->child->brother);
	}
}

void def(TreeNode* p)
{
	//ASSUME the spec is TYPE
	decsInner(p->child->brother);
}

void decsInner(TreeNode* p)
{
	if(p->child->brother == NULL )//dec case
	{
		decInner(p->child);
	}
	else//DEC COMMA DECS case
	{
		decInner(p->child);
		decsInner(p->child->brother->brother);
	}
}

void decInner(TreeNode* p)
{
	if(p->child->brother == NULL)//without init
	{
		if(p->child->child->brother == NULL) //var is IDENTIFIER
		{
			TreeNode* id = p->child->child;
			fprintf(fout,"@%s = alloca i32 , align 4\n",id->name);
			int dim1 = 0;
			if(id->name[0]<'A' || id->name[0]>'z') dim1 = 26;
			else dim1 = (id->name[0]<='Z')? id->name[0]-'A':id->name[0]-'a';
			int i=0;
			while (symTable[dim1][i]) i++;
			symTable[dim1][i] = (struct symbol*)malloc(sizeof(struct symbol));
			struct symbol* s = symTable[dim1][i];
			s->word = (char*)malloc(sizeof(char)*60);
            strcpy(s->word,id->name);
            s->type = 'l';
		}
		else//var is var LB INTEGER RB 
		{
			TreeNode* id = p->child->child->child;//IDENTIFIER
			TreeNode* var = p->child->child;//var LB INTEGER RB
			fprintf(fout,"@%s = alloca [ %d x i32], align 4\n",id->name,atoi(var->brother->brother->name));
			
			int dim1 = 0;
			if(id->name[0]<'A' || id->name[0]>'z') dim1 = 26;
				else dim1 = (id->name[0]<='Z')? id->name[0]-'A':id->name[0]-'a';
			int i=0;
			while (symTable[dim1][i]) i++;
			symTable[dim1][i] = (struct symbol*)malloc(sizeof(struct symbol));
			struct symbol* s = symTable[dim1][i];
			s->word = (char*)malloc(sizeof(char)*60);
            strcpy(s->word,id->name);
            s->type = 'l';
			s->arrSize = atoi(var->brother->brother->name);
		}
	}
	else//with init
	{
		if(p->child->child->brother == NULL)
		{
			TreeNode* id = p->child->child;
			TreeNode* initVal = p->child->brother->brother->child->child;//ASSUME there is only one integer in the init.
			fprintf(fout,"%s = alloca i32, align 4\n",id->name);
			fprintf(fout,"store i32 %d, i32* %s, align 4\n",atoi(initVal->name),id->name);
			
			int dim1 = 0;
			if(id->name[0]<'A' || id->name[0]>'z') dim1 = 26;
			else dim1 = (id->name[0]<='Z')? id->name[0]-'A':id->name[0]-'a';
			int i=0;
			while (symTable[dim1][i]) i++;
			symTable[dim1][i] = (struct symbol*)malloc(sizeof(struct symbol));
			struct symbol* s = symTable[dim1][i];
			s->word = (char*)malloc(sizeof(char)*60);
            strcpy(s->word,id->name);
            s->type = 'l';
		}
		else
		{
			TreeNode* id = p->child->child->child;
			TreeNode* var = p->child->child;
			fprintf(fout,"  %%%s = alloca [%d x i32], align 4\n", id->name,atoi(var->brother->brother->name));
			
			int dim1 = 0;
			if(id->name[0]<'A' || id->name[0]>'z') dim1 = 26;
			else dim1 = (id->name[0]<='Z')? id->name[0]-'A':id->name[0]-'a';
			int i=0;
			while (symTable[dim1][i]) i++;
			symTable[dim1][i] = (struct symbol*)malloc(sizeof(struct symbol));
			struct symbol* s = symTable[dim1][i];
			s->word = (char*)malloc(sizeof(char)*60);
            strcpy(s->word,id->name);
            s->type = 'l';
			s->arrSize = atoi(var->brother->brother->name);
						
			arrName = (char*)malloc(sizeof(char)*60);
			strcpy(arrName,id->name);
			arrSize = s->arrSize;
			InnerArgs(p->child->brother->brother->child->brother);//args under init
			free(arrName);
			arrSize = 0;
		}
	}
}

void InnerArgs(TreeNode* p)
{
	if(p->child->brother == NULL )
	{
		ExpInner(p->child);
		arrPtr = 0;//指向数组中第几个元素
	}
	else{
		ExpInner(p->child);
		arrPtr++;
		InnerArgs(p->child->brother->brother);
	}
}

void ExpInner(TreeNode* p)
{
		char* val = (char*)malloc(sizeof(char)*60);
        val = Exp(p);
        fprintf(fout,"  %%arrayidx%d = getelementptr inbounds [%d x i32], [%d x i32]* %s, i64 0, i64 %d\n",arridxNum,arrSize,arrSize,arrName,arrPtr);
        fprintf(fout,"  store i32 %s, i32* %%arrayidx%d, align 4\n",val,arridxNum);
        arridxNum++;
}

void stmts(TreeNode* p)
{
	if(!strcmp(p->name,"NULL"))
	{
		//do nothing
	}
	else{
		stmt(p->child);
		stmts(p->child->brother);
	}

}

void stmt(TreeNode* p)
{
	if(p->child->name[0]=='e' && p->child->name[1]=='x' && p->child->name[2]=='p')
	{
		Exp(p->child);
	}
	else if(!strcmp(p->child->name,"stmtblock"))
	{

		entryDepth++;
		stmtblock(p->child);
		entryDepth--;
	}
	else if(!strcmp(p->child->name,"return"))
	{

        char* tmp = (char*)malloc(sizeof(char)*60);
        tmp = Exps(p->child->brother);//EXPS will not be empty
        fprintf(fout,"  %%%d = load i32, i32* %s, align 4\n",rNum,tmp);
        fprintf(fout,"  ret i32 %%%d\n",rNum);
        rNum++;
	}
	else if(!strcmp(p->child->name,"if"))
	{
        /*
        br i1 %cmp, label %if.then, label %if.else

        if.then:                                          ; preds = %entry
        store i32 1, i32* %a, align 4
        br label %if.end

        if.else:                                          ; preds = %entry
        store i32 2, i32* %a, align 4
        br label %if.end

        if.end:                                           ; preds = %if.else, %if.then
        store i32 3, i32* %a, align 4
        */
        if (p->child->brother->brother->brother->brother->brother->child!= NULL) //ESTMT not null
        {
            char* tmp = (char*)malloc(sizeof(char)*60);
            tmp = Exps(p->child->brother->brother);


            if (!strcmp(p->child->brother->brother->child->brother->name,"."))//DOT, special case
            {
                char num[10];
                sprintf(num, "%d", rNum++);
                char* tmpReg = (char*)malloc(sizeof(char)*60);
                strcpy(tmpReg,"%r");
                strcat(tmpReg,num);

                fprintf(fout,"  %s = icmp ne i32 %s, 0\n",tmpReg,tmp);
                strcpy(tmp,tmpReg);
            }


            fprintf(fout,"  br i1 %s, label %%if%d.then, label %%if%d.else\n\n",tmp, ifNum, ifNum);

            fprintf(fout,"if%d.then:\n",ifNum);
            stmt(p->child->brother->brother->brother->brother);
            fprintf(fout,"  br label %%if%d.end\n\n",ifNum);

            fprintf(fout,"if%d.else:\n",ifNum);
            stmt(p->child->brother->brother->brother->brother->brother->child->brother);
            fprintf(fout,"  br label %%if%d.end\n\n",ifNum);

            fprintf(fout,"if%d.end:\n",ifNum);

            ifNum++;
        }
        else
        {

            char* tmp = (char*)malloc(sizeof(char)*60);
            tmp = Exps(p->child->brother->brother);

            if (!strcmp(p->child->brother->brother->child->brother->name,"."))//DOT, special case
            {
                char num[10];
                sprintf(num, "%d", rNum++);
                char* tmpReg = (char*)malloc(sizeof(char)*60);
                strcpy(tmpReg,"%r");
                strcat(tmpReg,num);

                fprintf(fout,"  %s = icmp ne i32 %s, 0\n",tmpReg,tmp);
                strcpy(tmp,tmpReg);
            }


            fprintf(fout,"  br i1 %s, label %%if%d.then, label %%if%d.end\n\n",tmp, ifNum, ifNum);

            fprintf(fout,"if%d.then:\n",ifNum);
            stmt(p->child->brother->brother->brother->brother);
            fprintf(fout,"  br label %%if%d.end\n\n",ifNum);

            fprintf(fout,"if%d.end:\n",ifNum);

            ifNum++;

        }		
	}
	else if(!strcmp(p->child->name,"for"))
	{
		//store i32 0, i32* %i, align 4
        //br label %for.cond
        Exp(p->child->brother->brother);//EXP can be empty
        fprintf(fout,"  br label %%for%d.cond\n\n",forNum);

        fprintf(fout,"for%d.cond:\n",forNum);
        char* tmp = (char*)malloc(sizeof(char)*60);
		TreeNode* Exp2 = p->child->brother->brother->brother->brother;
		if(Exp2->child->brother == NULL)//ERROR checking.
		{
			fprintf(fout,"line%d:error! It will loop forever in the for(;;)!",p->Line);
			exit(-1);
		}

        tmp = Exp(Exp2);
	
        if (!strcmp(Exp2->child->brother->name,"arrs")) //special case, ID ARRS
        {
            //%cmp = icmp sgt i32 %0, 16
            fprintf(fout,"  %%r%d = icmp ne i32 %s, 0\n",rNum,tmp);
            fprintf(fout,"  br i1 %%r%d, label %%for%d.body, label %%for%d.end\n\n",rNum,forNum,forNum);
            rNum++;
        }
        else fprintf(fout,"  br i1 %s, label %%for%d.body, label %%for%d.end\n\n",tmp,forNum,forNum);

        fprintf(fout,"for%d.body:\n",forNum);
        stmt(p->child->brother->brother->brother->brother->brother->brother->brother->brother);
        fprintf(fout,"  br label %%for%d.inc\n\n",forNum);
        fprintf(fout,"for%d.inc:\n",forNum);

        Exp(p->child->brother->brother->brother->brother->brother->brother);
        fprintf(fout,"  br label %%for%d.cond\n\n",forNum);
        fprintf(fout,"for%d.end:\n",forNum);

        forNum++;
	
	}
	else if(!strcmp(p->child->name,"cont"))
	{
		
	}
	else if(!strcmp(p->child->name,"break"))
	{
		
	}
	else if(!strcmp(p->child->name,"write"))
	{
			char* tmp = (char*)malloc(sizeof(char)*60);
            tmp = Exp(p->child->brother->brother);
            int trans;
            if (strlen(tmp)>1 && (tmp[0]=='0' || (tmp[0]=='-' && tmp[1]=='0')))
            {
                trans = strtol(tmp,NULL,0);
                fprintf(fout,"  %%call%d = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @.str, i32 0, i32 0), i32 %d)\n",callNum,trans);
                callNum++;
                fprintf(fout,"  %%call%d = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @.str1, i32 0, i32 0))\n",callNum);
                callNum++;
            }
            else
            {
                fprintf(fout,"  %%call%d = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @.str, i32 0, i32 0), i32 %s)\n",callNum,tmp);
                callNum++;
                fprintf(fout,"  %%call%d = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @.str1, i32 0, i32 0))\n",callNum);
                callNum++;
            }
	}
	else//read
	{
			//%call = call i32 (i8*, ...)* @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8]* @.str, i32 0, i32 0), i32* %a)
            char* tmp = (char*)malloc(sizeof(char)*200);
            loadFlag = 0;
            tmp = Exp(p->child->brother->brother);
            loadFlag = 1;

            fprintf(fout,"  %%call%d = call i32 (i8*, ...)* @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8]* @.str, i32 0, i32 0), i32* %s)\n",callNum,tmp);
            callNum++;

	}
}


char* Exp(TreeNode* p)
{
	if(!strcmp(p->name,"exp-null"))
		return NULL;
	else
		return Exps(p);
}

char* Exps(TreeNode* p)
{
	if (p->child->brother==NULL) //EXP->INT
    {
        char* tmp = (char*)malloc(sizeof(char)*60);
        strcpy(tmp,p->child->name);
        return tmp;
    }

    else if (!strcmp(p->child->name,"++")) //++
    {
        //%27 = load i32* %i, align 4
        //%inc26 = add nsw i32 %27, 1
        //store i32 %inc26, i32* %i, align 4
        char* op = (char*)malloc(sizeof(char)*60);
        loadFlag = 0;
        op = Exp(p->child->brother);
        loadFlag = 1;

        fprintf(fout,"  %%r%d = load i32, i32* %s, align 4\n",rNum,op);
        fprintf(fout,"  %%r%d = add nsw i32 %%r%d, 1\n",rNum+1,rNum);
        fprintf(fout,"  store i32 %%r%d, i32* %s, align 4\n",rNum+1,op);

        rNum+=2;
        return NULL;
    }
	else if (!strcmp(p->child->name,"--")) //--
	{
		//The same like ++
	}
    else if (!strcmp(p->child->name,"-")) //-
    {
        //%%0 = load i32, i32* %s, align 4
		//%sub = sub nsw i32 0, %0
		//store i32 %sub, i32* %q, align 4
        char* op = (char*)malloc(sizeof(char)*60);
        loadFlag = 0;
        op = Exp(p->child->brother);
        loadFlag = 1;

        fprintf(fout,"  %%r%d = load i32, i32* %s, align 4\n",rNum,op);
        fprintf(fout,"  %%r%d = sub nsw i32 0, %%r%d\n",rNum+1,rNum);
        //fprintf(fout,"  store i32 %%r%d, i32* %s, align 4\n",rNum+1,op);  shouldn't be here

        char num[10];
        sprintf(num, "%d", rNum+1);
        char* tmpReg = (char*)malloc(sizeof(char)*60);
        strcpy(tmpReg,"%r");
        strcat(tmpReg,num);

        rNum+=2;
        return tmpReg;
    }
    else if (!strcmp(p->child->name,"!")) //!
    {
        //%1 = load i32, i32* %s, align 4---------op will do it
		//%tobool = icmp ne i32 %1, 0
		//%lnot = xor i1 %tobool, true
		//%lnot.ext = zext i1 %lnot to i32
		//store i32 %lnot.ext, i32* %r, align 4--------not here
        char* op = (char*)malloc(sizeof(char)*60);
        op = Exp(p->child->brother);

        char num[10];
        sprintf(num, "%d", rNum++);
        char* tmpReg = (char*)malloc(sizeof(char)*60);
		char* tmpReg1 = (char*)malloc(sizeof(char)*60);
		char* retReg = (char*)malloc(sizeof(char)*60);
        strcpy(tmpReg,"%r");
        strcat(tmpReg,num);
        fprintf(fout,"  %s = icmp ne i32 %s, 0\n",tmpReg,op);
		
		strcpy(tmpReg1,tmpReg);
        strcat(tmpReg1,"lnot");
		fprintf(fout,"  %s = xor i1 %s, true\n",tmpReg1,tmpReg);
		return tmpReg1;
		//strcpy(retReg,tmpReg1);
        //strcat(retReg,".ext");
		//fprintf(fout,"  %s = zext i1 %s to i32\n",retReg,tmpReg1);
       // return retReg;
    }

    else if (!strcmp(p->child->brother->name,"=")) //EXP->EXP ASSIGNOP EXP
    {

        char* op2 = (char*)malloc(sizeof(char)*200);
        op2 = Exp(p->child->brother->brother);

        loadFlag = 0;
        char* op1 = (char*)malloc(sizeof(char)*200);
        op1 = Exp(p->child);
        loadFlag = 1;

        fprintf(fout,"  store i32 %s, i32* %s, align 4\n",op2,op1);
        return NULL;

    }
    else if (!strcmp(p->child->name,"(")) //LP EXP RP
    {
        return Exp(p->child->brother);
    }
    else if (!strcmp(p->child->brother->name,"arrs")) //IDENTIFIER arrs           
    {
        //printf("%s, %c",symTable[0][0]->word,symTable[0][0]->type);
        //return symTable[0][0]->word;

        TreeNode* nodeArrs = p->child->brother;
        if (nodeArrs->child == NULL) //ARRS->NULL, ID case
        {
            char* tmp = (char*)malloc(sizeof(char)*60);
	    char* tmp1 = (char*)malloc(sizeof(char)*60);
            TreeNode* nodeId = p->child;
	    strcpy(tmp1,nodeId->name);
			int dim1 = 0;
			if(nodeId->name[0]<'A' || nodeId->name[0]>'z') dim1 = 26;
			else dim1 = (nodeId->name[0]<='Z')? nodeId->name[0]-'A':nodeId->name[0]-'a';

            int i=0;
            while (strcmp(nodeId->name,symTable[dim1][i]->word)) 
			{
				i++;
				if(i>=20)
				{
					printf("line%d: no such IDENTIFIER",p->Line);
					exit(-1);
				}
			}
            struct symbol* id = symTable[dim1][i];
            switch (id->type)
            {
                case 'g':
		for (i=strlen(tmp1);i>=0;i--) tmp[i+1] = tmp1[i];
                tmp[0] = '@';
                break;

                case 'l':
                tmp[0] = '%';
				strcat(tmp,tmp1);
                break;

                case 'a':
                tmp[0] = '%';
				strcat(tmp,tmp1);
                strcat(tmp,".addr");
                break;
            }
	    free(tmp1);
            if (loadFlag)
            {
                char num[10];
                sprintf(num, "%d", rNum++);
                char* tmpReg = (char*)malloc(sizeof(char)*60);
                strcpy(tmpReg,"%r");
                strcat(tmpReg,num);

                fprintf(fout,"  %s = load i32, i32* %s, align 4\n",tmpReg,tmp);
                return tmpReg;
            }
            else return tmp;
        }
        else //we need to return arrindex
        {
            char* tmp = (char*)malloc(sizeof(char)*60);
            TreeNode* nodeId = p->child;
            strcpy(tmp,nodeId->name);

            char* arrsIndex = (char*)malloc(sizeof(char)*60);
            if (loadFlag==0)
            {
                loadFlag = 1;
                arrsIndex = Exp(p->child->brother->child->brother); //what we obtained could be register or INT
                loadFlag = 0;
            }
            else arrsIndex = Exp(p->child->brother->child->brother);

            char* ret = (char*)malloc(sizeof(char)*60);
            strcpy(ret,"%arrayidx");

            char num[10];
            sprintf(num, "%d", arridxNum++);
            strcat(ret,num);

			int dim1 = 0;
			if(nodeId->name[0]<'A' || nodeId->name[0]>'z') dim1 = 26;
			else dim1 = (nodeId->name[0]<='Z')? nodeId->name[0]-'A':nodeId->name[0]-'a';

            int i=0;
            while (strcmp(tmp,symTable[dim1][i]->word)) 
			{
				i++;
				if(i>=20)
				{
					printf("line%d: error! can't find the array", p->Line);
				}
			}
            struct symbol* id = symTable[dim1][i];
            switch (id->type)
            {
                case 'g':
                for (i=strlen(tmp);i>=0;i--) tmp[i+1] = tmp[i];
                tmp[0] = '@';
                break;

                case 'l':
                for (i=strlen(tmp);i>=0;i--) tmp[i+1] = tmp[i];
                tmp[0] = '%';
                break;

                case 'a':
                for (i=strlen(tmp);i>=0;i--) tmp[i+1] = tmp[i];
                tmp[0] = '%';
                strcat(tmp,".addr");
                break;
            }

            //%arrayidx4 = getelementptr inbounds [2 x i32]* %d, i32 0, i32 1
            fprintf(fout,"  %s = getelementptr inbounds [%d x i32]* %s, i32 0, i32 %s\n",ret,id->arrSize,tmp,arrsIndex);

            if (loadFlag)
            {
                char num[10];
                sprintf(num, "%d", rNum++);
                char* tmpReg = (char*)malloc(sizeof(char)*60);
                strcpy(tmpReg,"%r");
                strcat(tmpReg,num);

                fprintf(fout,"  %s = load i32, i32* %s, align 4\n",tmpReg,ret);
                return tmpReg;
            }
            else return ret;
        }
    }

    else if (!strcmp(p->child->brother->name,".")) ////EXP->EXP DOT THEID
    {
        //%0 = load i32* getelementptr inbounds (%struct.doubleO* @T, i32 0, i32 0), align 4
        TreeNode* nodeId = p->child->child;

        int dim1 = 0;
		if(nodeId->name[0]<'A' || nodeId->name[0]>'z') dim1 = 26;
		else dim1 = (nodeId->name[0]<='Z')? nodeId->name[0]-'A':nodeId->name[0]-'a';

        int i=0;
        while (strcmp(nodeId->name,symTable[dim1][i]->word)) //Error checking
		{
			i++;
			if(i>=20) 
			{
				printf("line%d:error, struct undefined",p->Line);
				exit(-1);
			}
		}

        struct symbol* id = symTable[dim1][i];

        char* op1 = (char*)malloc(sizeof(char)*200);
        strcpy(op1,nodeId->name);

        char* opStr = (char*)malloc(sizeof(char)*200);
        strcpy(opStr,id->structName); //opStr, doubleO


        nodeId = p->child->brother->brother;
		
        dim1 = 0;
		if(nodeId->name[0]<'A' || nodeId->name[0]>'z') dim1 = 26;
		else dim1 = (nodeId->name[0]<='Z')? nodeId->name[0]-'A':nodeId->name[0]-'a';

        i=0;
        while (strcmp(nodeId->name,symTable[dim1][i]->word)) 
		{
			i++;
			if(i>=20)
			{
				printf("line%d: struct has no such element.",p->Line);
				exit(-1);
			}
		}
        id = symTable[dim1][i];

        int op2 = id->structMem; //op2, 0

        char* ret = (char*)malloc(sizeof(char)*200);
        strcpy(ret,"getelementptr inbounds (%struct.");
        strcat(ret,opStr);
        strcat(ret,"* @");
        strcat(ret,op1);
        strcat(ret,", i32 0, i32 ");
        char indTmp = '0'+op2;
        char* ind = (char*)malloc(sizeof(char)*70); ind[0] = indTmp; ind[1] = '\0';
        strcat(ret,ind);
        strcat(ret,")");

        if (loadFlag)
        {
            char num[10];
            sprintf(num, "%d", rNum++);
            char* tmpReg = (char*)malloc(sizeof(char)*200);
            strcpy(tmpReg,"%r");
            strcat(tmpReg,num);

            fprintf(fout,"  %s = load i32, i32* %s, align 4\n",tmpReg,ret);
            return tmpReg;
        }
        else return ret;
    }
    else if (!strcmp(p->child->brother->name,"==")) //EXP->EXP == EXP
    {
        //%cmp = icmp eq i32 %0, %1
		//%conv = zext i1 %cmp to i32
        char* op1 = (char*)malloc(sizeof(char)*60);
        op1 = Exp(p->child);
        char* op2 = (char*)malloc(sizeof(char)*60);
        op2 = Exp(p->child->brother->brother);

        char num[10];
        sprintf(num, "%d", rNum++);
		
        char* tmpReg = (char*)malloc(sizeof(char)*60);
        strcpy(tmpReg,"%r");
        strcat(tmpReg,num);
        fprintf(fout,"  %s = icmp eq i32 %s, %s\n",tmpReg,op1,op2);
	return tmpReg;
        //char* retReg = (char*)malloc(sizeof(char)*60);
        //strcpy(retReg,tmpReg);
        //strcat(retReg,".ext");
        //fprintf(fout,"  %s = zext i1 %s to i32\n",retReg,tmpReg);
		
        //return retReg;
    }
    else if (!strcmp(p->child->brother->name,">")) //EXP->EXP GREATER EXP
    {
        //%cmp = icmp sgt i32 %0, 16
        char* op1 = (char*)malloc(sizeof(char)*60);
        op1 = Exp(p->child);
        char* op2 = (char*)malloc(sizeof(char)*60);
        op2 = Exp(p->child->brother->brother);

        char num[10];
        sprintf(num, "%d", rNum++);
		
        char* tmpReg = (char*)malloc(sizeof(char)*60);
        strcpy(tmpReg,"%r");
        strcat(tmpReg,num);
        fprintf(fout,"  %s = icmp sgt i32 %s, %s\n",tmpReg,op1,op2);
	return tmpReg;
        //char* retReg = (char*)malloc(sizeof(char)*60);
        //strcpy(retReg,tmpReg);
        //strcat(retReg,".ext");
        //fprintf(fout,"  %s = zext i1 %s to i32\n",retReg,tmpReg);
		
        //return retReg;
    }
    else if (!strcmp(p->child->brother->name,"<")) //EXP->EXP LESS EXP
    {
        //%cmp = icmp sgt i32 %0, 16
        char* op1 = (char*)malloc(sizeof(char)*60);
        op1 = Exp(p->child);
        char* op2 = (char*)malloc(sizeof(char)*60);
        op2 = Exp(p->child->brother->brother);

        char num[10];
        sprintf(num, "%d", rNum++);
		
        char* tmpReg = (char*)malloc(sizeof(char)*60);
        strcpy(tmpReg,"%r");
        strcat(tmpReg,num);
        fprintf(fout,"  %s = icmp slt i32 %s, %s\n",tmpReg,op1,op2);
	return tmpReg;
        //char* retReg = (char*)malloc(sizeof(char)*60);
        //strcpy(retReg,tmpReg);
        //strcat(retReg,".ext");
        //fprintf(fout,"  %s = zext i1 %s to i32\n",retReg,tmpReg);
		
        //return retReg;
    }
    else if (!strcmp(p->child->brother->name,"&&")) //EXP->EXP LOGICAND EXP
    {
        //%cmp = icmp eq i32 %0, %1
        char* op1 = (char*)malloc(sizeof(char)*60);
        op1 = Exp(p->child);
        char* op2 = (char*)malloc(sizeof(char)*60);
        op2 = Exp(p->child->brother->brother);

        int reg1 = rNum, reg2 = rNum+1; rNum+=2;
        fprintf(fout,"  %%r%d = icmp ne i32 %s, 0\n",reg1,op1);
        fprintf(fout,"  %%r%d = icmp ne i32 %s, 0\n",reg2,op2);

        int reg3 = rNum; rNum++;
        fprintf(fout,"  %%r%d = and i1 %%r%d, %%r%d\n",reg3,reg1,reg2);

        char num[10];
        sprintf(num, "%d", reg3);
        char* tmpReg = (char*)malloc(sizeof(char)*60);
        strcpy(tmpReg,"%r");
        strcat(tmpReg,num);

        return tmpReg;
    }
    else if (!strcmp(p->child->brother->name,"+")) //EXP ADD EXP
    {
        //%0 = load i32* %a, align 4
        //%1 = load i32* %b, align 4
        //%add = add nsw i32 %0, %1
        char* op1 = (char*)malloc(sizeof(char)*60);
        op1 = Exp(p->child);
        char* op2 = (char*)malloc(sizeof(char)*60);
        op2 = Exp(p->child->brother->brother);

        char num[10];
        sprintf(num, "%d", rNum++);
        char* tmpReg = (char*)malloc(sizeof(char)*60);
        strcpy(tmpReg,"%r");
        strcat(tmpReg,num);

        fprintf(fout,"  %s = add nsw i32 %s, %s\n",tmpReg,op1,op2);
        return tmpReg;
    }
    else if (!strcmp(p->child->brother->name,"-")) //EXP -> EXP - Exp
    {
		//%0 = load i32, i32* %s, align 4
		//%1 = load i32, i32* %r, align 4
		//%sub = sub nsw i32 %0, %1
        char* op1 = (char*)malloc(sizeof(char)*60);
        op1 = Exp(p->child);

        char* op2 = (char*)malloc(sizeof(char)*60);
        op2 = Exp(p->child->brother->brother);

        char num[10];
        sprintf(num, "%d", rNum++);
        char* tmpReg = (char*)malloc(sizeof(char)*60);
        strcpy(tmpReg,"%r");
        strcat(tmpReg,num);

        fprintf(fout,"  %s = sub nsw i32 %s, %s\n",tmpReg,op1,op2);
        return tmpReg;
    }
    else if (!strcmp(p->child->brother->name,"*")) //EXP MULT EXP
    {
        //%0 = load i32* %a, align 4
        //%1 = load i32* %b, align 4
        //%add = add nsw i32 %0, %1
        char* op1 = (char*)malloc(sizeof(char)*60);
        op1 = Exp(p->child);
        char* op2 = (char*)malloc(sizeof(char)*60);
        op2 = Exp(p->child->brother->brother);

        char num[10];
        sprintf(num, "%d", rNum++);
        char* tmpReg = (char*)malloc(sizeof(char)*60);
        strcpy(tmpReg,"%r");
        strcat(tmpReg,num);

        fprintf(fout,"  %s = mul nsw i32 %s, %s\n",tmpReg,op1,op2);
        return tmpReg;
    }
    else if (!strcmp(p->child->brother->name,"%"))//MOD srem
    {
        //%0 = load i32* %a, align 4
        //%1 = load i32* %b, align 4
        //%add = add nsw i32 %0, %1
        char* op1 = (char*)malloc(sizeof(char)*60);
        op1 = Exp(p->child);
        char* op2 = (char*)malloc(sizeof(char)*60);
        op2 = Exp(p->child->brother->brother);

        char num[10];
        sprintf(num, "%d", rNum++);
        char* tmpReg = (char*)malloc(sizeof(char)*60);
        strcpy(tmpReg,"%r");
        strcat(tmpReg,num);

        fprintf(fout,"  %s = srem i32 %s, %s\n",tmpReg,op1,op2);
        return tmpReg;
    }
    else if (!strcmp(p->child->brother->name,"&"))//BITAND
    {
        char* op1 = (char*)malloc(sizeof(char)*60);
        op1 = Exp(p->child);
        char* op2 = (char*)malloc(sizeof(char)*60);
        op2 = Exp(p->child->brother->brother);

        char num[10];
        sprintf(num, "%d", rNum++);
        char* tmpReg = (char*)malloc(sizeof(char)*60);
        strcpy(tmpReg,"%r");
        strcat(tmpReg,num);

        fprintf(fout,"  %s = and i32 %s, %s\n",tmpReg,op1,op2);
        //这里最后返回了一个i1,实质上是不合理的，不过无所谓吧
        sprintf(num, "%d", rNum++);
        strcpy(tmpReg,"%r");
        strcat(tmpReg,num);

        fprintf(fout,"  %s = icmp ne i32 %%r%d, 0\n",tmpReg,rNum-2);
        return  tmpReg;
    }
    else if (!strcmp(p->child->brother->name,"^"))//BITXOR
    {
        char* op1 = (char*)malloc(sizeof(char)*60);
        op1 = Exp(p->child);
        char* op2 = (char*)malloc(sizeof(char)*60);
        op2 = Exp(p->child->brother->brother);

        char num[10];
        sprintf(num, "%d", rNum++);
        char* tmpReg = (char*)malloc(sizeof(char)*60);
        strcpy(tmpReg,"%r");
        strcat(tmpReg,num);

        fprintf(fout,"  %s = xor i32 %s, %s\n",tmpReg,op1,op2);
        return tmpReg;
    }
    else if (!strcmp(p->child->brother->name,">>=")) //EXP SHIFTRA EXP
    {
        //%0 = load i32* %x, align 4
        //%shr = ashr i32 %0, 1
        //store i32 %shr, i32* %x, align 4
        char* op1 = (char*)malloc(sizeof(char)*60);
        loadFlag = 0;
        op1 = Exp(p->child);
        loadFlag = 1;
        char* op2 = (char*)malloc(sizeof(char)*60);
        op2 = Exp(p->child->brother->brother);

       fprintf(fout,"%%r%d = load i32, i32* %s, align 4\n",rNum,op1);
        fprintf(fout,"  %%r%d = ashr i32 %%r%d, %s\n",rNum+1,rNum,op2);
        fprintf(fout,"  store i32 %%r%d, i32* %s, align 4\n",rNum+1,op1);
        rNum+=2;
        return NULL;
    }
    else if (!strcmp(p->child->brother->brother->name,"args")) //ID LP ARGS RP
    {
        //%0 = load i32* @a, align 4
        //%1 = load i32* @b, align 4
        //%call2 = call i32 @gcd(i32 %0, i32 %1)

        argsFunc(p->child->brother->brother);

        char num[10];
        sprintf(num, "%d", callNum++);
        char* tmpReg = (char*)malloc(sizeof(char)*60);
        strcpy(tmpReg,"%call");
        strcat(tmpReg,num);

        TreeNode* id = p->child;

        fprintf(fout,"  %s = call i32 @%s(",tmpReg,id->name);
		int i;

        for (i=0;i<paraPoint-1;i++)
        {
            fprintf(fout,"i32 %s, ",paraArr[i]);
            free(paraArr[i]);
        }
        if (paraPoint>0)
        {
            fprintf(fout,"i32 %s",paraArr[paraPoint-1]);
            free(paraArr[i]);
            paraPoint = 0;
        }
        fprintf(fout,")\n");

        return tmpReg;
    }
}

void argsFunc(TreeNode* p) //ARGS for function call
{
    if (p->child->brother == NULL) //EXP
    {
        char* tmp = (char*)malloc(sizeof(char)*60);
        tmp = Exp(p->child);
        paraArr[paraPoint] = (char*)malloc(sizeof(char)*60);
        strcpy(paraArr[paraPoint],tmp);
        paraPoint++;
    }
    else //EXP COMMA ARGS
    {
        char* tmp = (char*)malloc(sizeof(char)*60);
        tmp = Exp(p->child);
        paraArr[paraPoint] = (char*)malloc(sizeof(char)*60);
        strcpy(paraArr[paraPoint],tmp);
        paraPoint++;

        argsFunc(p->child->brother->brother);
    }
}
