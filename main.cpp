/***********
*ScannerTest
***********/
#include <iostream>
#include <string>
#define MAX_TERM 1000
using namespace std;

int main()
{
    char input[MAX_TERM];
    /*
    for(int j=0;j<MAX_TERM;j++)
        input[j]=NULL;
    */
    int i=0;
    while(cin >> input[i])
    {
        //cout << input[i]<<endl;
        i++;

    }

    for(int j=0;j<i;j++)
    {
        //cout <<"in"<<j<<":";
        if(input[j]=='+')
        {
            cout <<"PLUS\n";
        }
        else if(input[j]=='-')
        {
            cout <<"MINUS\n";
        }else if(input[j]=='*')
        {
            cout <<"MUL\n";
        }else if(input[j]=='/')
        {
            cout <<"DIV \n";
        }else if(input[j]=='(')
        {
            cout <<"LPR\n";
        }else if(input[j]==')')
        {
            cout <<"RPR\n";
        }else if(input[j]<='9'&&input[j]>='0')
        {
            int num = input[j] - '0';
            while(input[j+1]<='9'&&input[j+1]>='0')
            {

                num = num*10 + (input[j+1]-'0');
                //cout << "num: "<< num <<endl;
                j++;
            }
            cout << "NUM " << num << "\n";
        }

    }

    return 0;
}
