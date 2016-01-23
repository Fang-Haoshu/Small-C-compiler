%{
#include<stdio.h>
#include<stdlib.h>
#include "main.h"
#include "y.tab.h"

						
extern void  yyerror(char *s);//该函数是在y.tab.c里定义的，必须用extern加以声明
extern TreeNode * newNode (char* node_name,int line); //同理 
int yywrap(void);
int Line=1; 	//定义行数，输出错误信息

%}

/*非数字由大小写字母、下划线组成*/
nondigit	([_A-Za-z])

/*一位数字，可以是0到9*/
digit		([0-9])

/*A sequence of digits or digits followed by “0x(0X)” or “0” without spaces*/
integer		(({digit}+)|(0x|0X|0)[0-9a-fA-F]+)

/*标识符，以非数字开头，后跟0至多个数字或非数字*/
identifier	({nondigit}({nondigit}|{digit})*)

/*一个或一段连续的空白符*/
blank_chars	([ \f\r\t\v]+)

/*规则段*/
%%

\n                        {Line++;}  							

int                    { yylval.treeNode= newNode(yytext,Line);
                          return TYPE;}  
struct                  { yylval.treeNode= newNode(yytext,Line);  
                          return STRUCT; }  
return                  { yylval.treeNode= newNode(yytext,Line);  
                          return RETURN; }  
if                      { yylval.treeNode= newNode(yytext,Line);  
                          return IF ; }  
else                    { yylval.treeNode= newNode(yytext,Line);  
                          return ELSE ;}  
break                   { yylval.treeNode= newNode(yytext,Line);  
                          return BREAK;}  
cont                    { yylval.treeNode= newNode(yytext,Line);  
                          return CONT; }  
for                     { yylval.treeNode= newNode(yytext,Line);  
                          return FOR;  }  
read                    { yylval.treeNode= newNode(yytext,Line);  
                          return READ;  }  
write                    { yylval.treeNode= newNode(yytext,Line);  
                          return WRITE;  }    
						  
{identifier}			{yylval.treeNode= newNode(yytext,Line);
						return IDENTIFIER;}		//向yacc返回: 识别出的记号类型是IDENTIFIER
				

{integer}				{yylval.treeNode = newNode(yytext,Line);
						return INTEGER;}			//向yacc返回: 识别出的记号类型是INTEGER
						  
[;]                    {  
                       yylval.treeNode= newNode(yytext,Line);  
                       return SEMI;  
                      }  
[,]                    {  
                       yylval.treeNode= newNode(yytext,Line);  
                       return COMMA;  
                      }  
[.]                    {  
                       yylval.treeNode= newNode(yytext,Line);  
                       return DOT;  
                      }  
(!)|(\+\+)|(\-\-)|(~)   {  
                       yylval.treeNode= newNode(yytext,Line);  
                       return UNARYOP;                    
                      }  
[-]                 {yylval.treeNode = newNode(yytext, Line);  
                    return (SUB);}  
(\*)|(\/)|(%)         {  
                       yylval.treeNode= newNode(yytext,Line);  
                       return BINARYOP1;  
                       }  
(\+)                  {  
                       yylval.treeNode= newNode(yytext,Line);  
                       return BINARYOP2;  
                       }  
(<<)|(>>)             {  
                       yylval.treeNode= newNode(yytext,Line);  
                       return BINARYOP3;  
                       }  
(>)|(>=)|(<)|(<=)     {  
                       yylval.treeNode= newNode(yytext,Line);  
                       return BINARYOP4;  
                       }  
(==)|(!=)             {  
                       yylval.treeNode= newNode(yytext,Line);  
                       return BINARYOP5;  
                       }  
[&]                   {  
                       yylval.treeNode= newNode(yytext,Line);  
                       return BINARYOP6;  
                       }  
"^"                   {  
                       yylval.treeNode= newNode(yytext,Line);  
                       return BINARYOP7;  
                       }  
(\|)                    {  
                       yylval.treeNode= newNode(yytext,Line);  
                       return BINARYOP8;  
                       }  
(&&)                     {  
                       yylval.treeNode= newNode(yytext,Line);  
                       return BINARYOP9;  
                       }  
(\|\|)                  {  
                       yylval.treeNode= newNode(yytext,Line);  
                       return BINARYOP10;  
                       }  
(\+=)|(-=)|(\*=)|(\/=)|(&=)|(^=)|(\|=)|(<<=)|(>>=)    {  
                       yylval.treeNode= newNode(yytext,Line);  
                       return BINARYOP11;  
                       }  
[=]                     { yylval.treeNode= newNode(yytext,Line);  
                        return ASSIGNOP;}  
[(]                     { yylval.treeNode= newNode(yytext,Line);  
                          return LP;  }  
[)]                     { yylval.treeNode= newNode(yytext,Line);  
                          return RP;  }  
"["                     { yylval.treeNode= newNode(yytext,Line);  
                          return LB;  }  
[]]                     { yylval.treeNode= newNode(yytext,Line);  
                          return RB;  }  
[{]                     { yylval.treeNode= newNode(yytext,Line);  
                          return LC;  }  
[}]                     { yylval.treeNode= newNode(yytext,Line);  
                          return RC;  }  
						  
				
{blank_chars}	{							//遇空白符时，什么也不做，忽略它们
				}
				


.				{//.表示除\n以外的其它字符，注意这个规则要放在最后，因为一旦匹配了.就不会匹配后面的规则了(以其它状态<>开头的规则除外)
					 yyerror("Error:invalid input.\n"); 
				}



%%

//第3段：C函数定义段
int yywrap(void)
{
	//puts("Success!");
	return 1;	//返回1表示读取全部结束。如果要接着读其它文件，可以这里fopen该文件，文件指针赋给yyin，并返回0
}
