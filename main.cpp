/***********
*ParserTest2
***********/
#include <iostream>
#include <string>
#include <sstream>
#define MAX_TERM 10000
using namespace std;
typedef struct{
    bool type;//int->false double->true
    int INT;
    string name;
    double DOUBLE;
}output;
char input[MAX_TERM];
output out[MAX_TERM];
int line=-1;
bool invalid=false;
void stmts(string);
void program();
void type(string );
void calculate(int  ,string );
double number(int,string);
void ID(int Beg,string in);
int main()
{
    program();
    if(invalid)
        cout <<"invalid output"<<endl;
    else
    {
        cout <<"int:"<<endl;
        bool have_i=false;
        bool have_d=false;
        for(int k=0;k<=line;k++)
        {
            //cout <<"out["<<k<<"].type="<<out[k].type<<endl;
            if(!out[k].type)
            {
                //cout <<"out["<<k<<"].type="<<out[k].type<<endl;
                have_i=true;
                cout << out[k].name<<":"<<out[k].INT<<endl;
            }
        }
        if(!have_i)
        {
            cout <<"none"<<endl;
        }
         cout <<"double:"<<endl;
        for(int k=0;k<=line;k++)
        {
            //cout <<"out["<<k<<"].type="<<out[k].type<<endl;
            if(out[k].type)
            {
                //cout <<"out["<<k<<"].type="<<out[k].type<<endl;
                have_d=true;
                if(out[k].DOUBLE-(int)out[k].DOUBLE==0)
                    cout << out[k].name<<":"<<out[k].DOUBLE<<".0"<<endl;
                else
                    cout << out[k].name<<":"<<out[k].DOUBLE<<endl;
            }

        }
        if(!have_d)
        {
            cout <<"none"<<endl;
        }
    }


    return 0;
}
void program(){
    string IN;
    string IN_line="";
    string space=" ";
    while(cin >> IN)
    {
         IN_line=IN_line+space+IN;
         if(IN_line[IN_line.size()-1]==';')
         {
             //cout <<"IN_line: "<<IN_line<<endl;
             if(IN_line.size()==1)
                invalid=true;
             stmts(IN_line);
             IN_line="";
         }
    }
    if(IN_line!="")
    {
        invalid=true;
    }

}
void stmts(string in){
    type(in);
}
void calculate(int Beg,string in){
    int j=Beg;
   // cout <<"in calculate"<<endl;
   // cout <<"in["<<j<<"]= "<<in[j]<<endl;
    while(in[j]==' ')
    {
        j++;
        //cout <<"in["<<j<<"]= "<<in[j]<<endl;
    }
    if(in[j]==';')
    {
        //cout <<"in ; !!"<<endl;
        out[line].INT=0;
        out[line].DOUBLE=0.0;
    }else if(in[j]=='=')
    {
        j++;
        if( out[line].type==false)
        {
            //cout <<"out["<<line<<"].type="<<out[line].type<<endl;
            out[line].INT=number(j,in);
            //cout <<"out["<<line<<"].INT="<<out[line].INT<<endl;
        }else if( out[line].type==true)
        {
            //cout <<"out["<<line<<"].type="<<out[line].type<<endl;
            out[line].DOUBLE=number(j,in);
        }

    }
}
void ID(int Beg,string in){
    string Output="";
    int j=Beg;
    char a;
    //cout <<"in"<<in<<endl;
    a=in[j];
    //cout <<"input["<<j<<"]: "<<a<<endl;
    while(in[j]==' ')
    {
        //cout <<"input["<<j<<"]: "<<in[j]<<endl;
        j++;
    }
    //cout <<"in"<<in<<endl;
    //cout <<"input["<<j<<"]: "<<in[j]<<endl;
    if((in[j]<='Z'&&in[j]>='A')||(in[j]<='z'&&in[j]>='a')||in[j]=='_')
    {
        //cout <<"IN ID"<<endl;
        for(j;j<=in.size();j++)
        {
            if((in[j]<='Z'&&in[j]>='A')||(in[j]<='z'&&in[j]>='a')||in[j]=='_'||(in[j]<='9'&&in[j]>='0'))
            {
                Output = Output +in[j];
            }
            else if(in[j]==' '||in[j]=='='||in[j]==';')
            {
                //cout <<" Output: "<<Output<<endl;
                out[line].name=Output;
                if(Output=="int"||Output=="double")
                    invalid=true;
                calculate(j,in);
                break;
            }else
            {
                //cout <<"ID invalid"<<endl;
                invalid=true;
                break;
            }

        }
    }else
        invalid=true;
}


void type(string in)
{
    int j=0;
    while(in[j]==' ')
    {
        j++;
    }
    if(in[0+j]=='d'&&in[1+j]=='o'&&in[2+j]=='u'&&in[3+j]=='b'&&in[4+j]=='l'&&in[5+j]=='e'&&in[6+j]==' ')
    {
        //cout <<"type double "<<endl;
        out[++line].type=true;
        //cout <<"line: "<<line<<endl;
        ID(j+6,in);
    }else if(in[0+j]=='i'&&in[1+j]=='n'&&in[2+j]=='t'&&in[3+j]==' ')
    {
        //cout <<"type int "<<endl;
        out[++line].type=false;
        //cout <<"line: "<<line<<endl;
        ID(j+3,in);

    }else
    {
        bool fin=false;
        //cout <<"here"<<endl;
        //cout <<"line="<<line<<endl;
        for(int k=0;k<=line;k++)
        {
            //cout <<"k="<<k<<endl;
            //cout <<in.substr(j,out[k].name.size())<<endl;
            if(in.substr(j,out[k].name.size())==out[k].name)
            {
                //cout <<in.substr(j,out[k].name.size())<<endl;
                j=j+out[k].name.size();
                //cout <<"in[j]"<<in[j]<<endl;
                while(in[j]==' ')
                {
                    j++;
                }
                //cout <<"in[j]"<<in[j]<<endl;
                if(in[j]=='=')
                {
                    //cout <<"="<<endl;
                    if(out[k].type)
                    {
                        out[k].DOUBLE=number(++j,in);
                    }else
                    {
                        out[k].INT=number(++j,in);
                    }
                }else if(in[j]==';')
                {

                }else
                {
                    invalid=true;
                }

                fin=true;
                //invalid=false;
            }
        }
        if(!fin)
            number(0,in);
    }
}
double number(int Beg,string in)
{

    double num_2;
    int j=Beg;
    stringstream ss;
    double num=0;
    string thenumber;

    //cout <<"in number"<<endl;
    //cout <<"in["<<j<<"]= "<<in[j]<<endl;
    while(in[j]==' ')
    {
        j++;

    }
    //cout <<"in["<<j<<"]= "<<in[j]<<endl;
    while(in[j]=='-'||in[j]=='+'||(in[j]>='0'&&in[j]<='9')||in[j]=='.')
    {
        thenumber=thenumber+in[j];
        j++;
        while(in[j]==' ')
        {
            j++;
        }
        if(in[j]=='-'||in[j]=='+')
        {
            break;
        }
    }
    ss << thenumber;
    ss >> num;
    if(in[j]!=';'&&in[j]!='-'&&in[j]!='+'&&in[j]!=' ')
    {
        invalid=true;
    }
    while(in[j]==' ')
    {
        j++;
    }
    if(in[j]=='+'||in[j]=='-')
    {
        //cout <<"num  ="<<num <<endl;
        return num + number(j,in);
    }else if(in[j]==';')
    {
        ////cout <<"num ="<<num<<endl;
        return num;
    }else
    {
        invalid=true;
        return 999;
    }

}
