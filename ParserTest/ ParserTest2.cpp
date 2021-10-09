/***********
*ParserTest2
***********/
#include <iostream>
#include <string>
#define MAX_TERM 1000
using namespace std;
int n=0;
char input[MAX_TERM];
string output[MAX_TERM];
int line=0;
bool invalid=false;
void program();
void stmts(int,int);
void stmt(int,int);
void primary(int,int);
void primary_tail(int,int);
void ID(int,int);
int main()
{
    program();
    if(invalid)
        cout <<"invalid input"<<endl;
    else
        for(int k=0;k<line;k++)
            cout <<output[k]<<endl;
    return 0;
}
void program(){
    string IN;
    while(cin >> IN)
    {
         for(int i=0;i<IN.size();i++)
         {
             input[n]=IN[i];
             n++;
         }
         input[n]=' ';//separate stmts
         n++;
    }
   stmts(0,n);
}
void stmts(int Beg,int End){
    int i=Beg;
    if(Beg<End){
        while(input[i]!=' ')
            i++;
        stmt(Beg,i-1);
        stmts(i+1,End);
    }
}
void stmt(int Beg,int End){
    if(input[Beg]=='"'){
        output[line]="STRLIT ";
        for(int i=Beg;i<=End;i++)
            output[line]=output[line]+input[i];

        if(input[End]!='"')
            invalid=true;
        line++;
    }else if(Beg>End){
    }else
        primary(Beg,End);
}
void primary(int Beg,int End){
    ID(Beg,End);
}
void primary_tail(int Beg,int End){
    if(input[Beg]=='.'){
        output[line]="DOT .";
        line++;
        ID(Beg+1,End);
    }else if(input[Beg]=='('){
        output[line]="LBR (";
        line++;
        int i;
        for(i=End;i>Beg;i--)
            if(input[i]==')')
                break;
        if(i<=Beg)
            invalid=true;
        stmt(Beg+1,i-1);
        output[line]="RBR )";
        line++;
        primary_tail(i+1,End);
    }
}
void ID(int Beg,int End){
    output[line]="ID ";
    if((input[Beg]<='Z'&&input[Beg]>='A')||(input[Beg]<='z'&&input[Beg]>='a')||input[Beg]=='_')
    {
        int i;
        for(i=Beg;i<=End;i++)
        {
            if(input[i]=='.'||input[i]=='(')
                break;
            else if((input[i]<='Z'&&input[i]>='A')||(input[i]<='z'&&input[i]>='a')||input[i]=='_'||(input[i]<='9'&&input[i]>='0'))
                output[line]=output[line]+input[i];
            else
            {
                invalid=true;
                break;
            }
        }
        line++;
        primary_tail(i,End);
    }else
        invalid=true;
}
