#include <malloc.h>
#include <stdio.h>
#include "main.h"
typedef TreeNode* Item;
typedef struct node* Qnode;

typedef struct
{
	Qnode front;
	int  length;
}queue;

queue *NewQueue();
void EnQueue(queue *list,Item item);
void DeQueue(queue *list,Item *pitem);
void link(TreeNode *parent,TreeNode *child);

void printTree(TreeNode* root,FILE *stream)
{   
	TreeNode* tmp;
	TreeNode* Child;
	TreeNode* Brother;
	int i = 0;
	queue *que;
	que=NewQueue();
	EnQueue(que, root);
	while(que->length!=0)
	{
		DeQueue(que, &tmp);
		fprintf(stream,"\n");
		for(i = 0; i < tmp->col ;i++)
			fprintf(stream,"%s", "---");
		fprintf(stream,"|%-1s",tmp->name);
		Child=tmp->child;
		Brother=tmp->brother;
		if(Brother!=NULL)
		{
			Brother->col=tmp->col;
			EnQueue(que,Brother);
		}
		if(Child!=NULL)
		{
			Child->col=tmp->col+1;
			EnQueue(que,Child);
		}
	}
}

queue *NewQueue()
{
	queue *p=(queue *)malloc(sizeof(queue));
	if (p==NULL)
	{
		printf("Error:out of memory.\n");
		return p;
	}
	else
		{p->front=NULL;
		 p->length=0;
		 return p;
		}
}


void EnQueue(queue *list,Item item)
{  
   Qnode p=(Qnode)malloc(sizeof(struct node));
   if(p==NULL)
   {
   	printf("Error:empty node.\n");
   	return;
   }
   else
   { 
   	 p->data=item;
   	 if(list->length == 0)
     	p->next=NULL;
     else
        p->next=list->front;
    list->length++;
    list->front=p;
    }
 }

 void DeQueue(queue *list,Item *pitem)
 {  
 	Qnode tmp=list->front;
 	if(list->length == 0)
 	{
 		printf("Error:empty list.\n");
    return;
 	}
 	else
 	{
 		if(pitem!=NULL)
 			*pitem=tmp->data;
 		list->front=tmp->next;
 		list->length--;
 		free(tmp);
 		if(list->length==0)
 			list->front=NULL;
 	}

 }

void link(TreeNode *parent,TreeNode *child)  
{     
    TreeNode *p;  
    if (child==NULL)  
        return;  
    if(parent->child==NULL)  
    {  
        parent->child=child;  
    }  
    else  
    {  
        p=parent->child;  
        while(p->brother!=NULL)  
            p=p->brother;  
        p->brother=child;   
    }
}  



