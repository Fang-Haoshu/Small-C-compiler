//lex.l��yacc.y��ͬʹ�õ�ͷ�ļ�
#ifndef MAIN_HPP
#define MAIN_HPP


#include <stdio.h>//printf��FILEҪ�õ�
#include <stdlib.h>
#include <string.h>

/*��lexÿʶ���һ���Ǻź���ͨ������yylval��yacc�������ݵġ�Ĭ�������yylval��int���ͣ�Ҳ����ֻ�ܴ����������ݡ�
yylval����YYSTYPE�궨��ģ�ֻҪ�ض���YYSTYPE�꣬��������ָ��yylval������(�ɲμ�yacc�Զ����ɵ�ͷ�ļ�yacc.tab.h)��
�����ǵ��������ʶ�����ʶ����Ҫ��yacc���������ʶ������yylval��������Ͳ�̫����(Ҫ��ǿ��ת�������ͣ�yacc����ת����char*)��
�����YYSTYPE�ض���Ϊstruct Type���ɴ�Ŷ�����Ϣ*/

typedef struct Node
{
	struct Node* brother;
	struct Node* child;
    char* name;
    int Line;	
	int col;
}TreeNode;



struct node
{
	struct Node* data;
	struct node* next;
};



//typedef struct Type//ͨ��������ÿ����Ա��ÿ��ֻ��ʹ������һ����һ���Ƕ����union�Խ�ʡ�ռ�(����������string�ȸ���������ɲ�����)
//{
//	TreeNode* treeNode;
//}type;

//#define YYSTYPE type//��YYSTYPE(��yylval����)�ض���Ϊstruct Type���ͣ�����lex������yacc���ظ����������

#endif
