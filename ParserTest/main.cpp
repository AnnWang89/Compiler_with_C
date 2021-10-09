/***********
*ParserTest
***********/
#include <iostream>
#include <string>
#define MAX_TERM 1000
using namespace std;

int main()
{
    char input[MAX_TERM];
    string output[MAX_TERM];
    int line=0;
    bool invalid=false;
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
        if(input[j]=='"')
        {
            string STRLIT = "" ;
            STRLIT=STRLIT+input[j];
            //cout <<"input[j]: "<< input[j] <<endl;
            //cout <<"STRLIT11 : "<< STRLIT <<endl;
            while(input[j+1]!='"')
            {
                STRLIT = STRLIT + input[j+1];
                //cout <<"STRLIT : "<< STRLIT <<endl;
                j++;
                if(j>=i)
                {
                    invalid=true;
                    //cout <<"invalid=true "<< endl;
                    break;
                }

            }
            j++;
            STRLIT = STRLIT + input[j];
            if(invalid)
                break;
            //cout <<"STRLIT"<<STRLIT<<"\n";
            output[line++]="STRLIT "+STRLIT;
        }else if(input[j]=='(')
        {
            //cout <<"LBR(\n";
            output[line++]="LBR (";
        }else if(input[j]==')')
        {
            //cout <<"RBR)\n";
            output[line++]="RBR )";
        }
        else if(input[j]=='.')
        {
            //cout <<"DOT.\n";
            output[line++]="DOT .";
        }else if((input[j]<='Z'&&input[j]>='A')||(input[j]<='z'&&input[j]>='a')||input[j]=='_')
        {
            string ID="";
            ID=ID+input[j];
            while((input[j+1]<='9'&&input[j+1]>='0')||(input[j+1]<='Z'&&input[j+1]>='A')||(input[j+1]<='z'&&input[j+1]>='a')||input[j+1]=='_')
            {
                 j++;
                ID = ID + input[j];
                //cout <<"input[j]:"<<input[j]<<endl;
                //cout <<"ID here:"<<ID<<endl;

            }
            if(input[j+1]!='.'&&input[j+1]!='('&&input[j+1]!=')'&&input[j+1]!=' '&&input[j+1]!='\0')
            {
                //cout <<"invalid=true 2"<< endl;
                invalid = true;
            }

            //cout <<"ID "<< ID << endl;
            output[line++]="ID "+ ID;
        }else if(input[j]==' '||input[j]=='\0')
        {

        }else
        {
             invalid = true;
        }


    }
    if(invalid)
    {
        cout <<"invalid input"<<endl;

    }else
    {
        for(int k=0;k<line;k++)
        {
            cout <<output[k]<<endl;
        }
    }

    return 0;
}
