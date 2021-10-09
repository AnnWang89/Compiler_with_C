#include <iostream>
#include <string>
#define MAX_TERM 1000
using namespace std;
char Nonterminal[MAX_TERM];
string terminal[MAX_TERM];
string first_set[MAX_TERM];
string first_set_sort[MAX_TERM];
void sort_nonterminal(int);
bool find_first_set(int,int);
bool nothing[MAX_TERM];
int token_type(char);
int find_nonter(char);
int index=0;
int main()
{
    string input;

    while(cin>>input)
    {
        if(input=="END_OF_GRAMMAR")
        {
            break;
        }
        Nonterminal[index]=input[0];
        nothing[index]=false;
        cin >>terminal[index++];
    }
    sort_nonterminal(index);

    for(int i=0;i<index;i++)
    {
        //cout << Nonterminal[i]<<" "<<terminal[i]<<endl;
        find_first_set(i,i);
    }

    for(int i=0;i<index;i++)
    {
        char tem=' ';
        char Max='~';
        for(int j=0;j<first_set[i].size();j++)
        {
            //cout << "first_set["<<i<<"]["<<j<<"]: "<<first_set[i][j]<<endl;
            for(int k=0;k<first_set[i].size();k++)
            {
                //cout << "first_set["<<i<<"]["<<k<<"]: "<<first_set[i][k]<<endl;
                if(tem<first_set[i][k]&&first_set[i][k]<Max)
                {
                    tem=first_set[i][k];
                }
            }
            if(tem==' ')
            {
                break;
            }
            if(tem==';'&&!nothing[i])
            {

            }else
                first_set_sort[i]=first_set_sort[i]+tem;
            Max=tem;
            tem=' ';
        }
    }
    for(int i=0;i<index;i++)
    {
        //cout << Nonterminal[i]<<" "<<first_set[i]<<endl;
        //cout << "nothing["<<i<<"]= "<<nothing[i]<<endl;
        cout << Nonterminal[i]<<" "<<first_set_sort[i]<<endl;
    }
    cout <<"END_OF_FIRST"<<endl;
    return 0;
}
void sort_nonterminal(int length)
{
    char temp;
    string temp2;
    for(int i=0;i<length-1;i++)
    {
        for(int j=0;j<length-i-1;j++)
        {
            if(Nonterminal[j]<Nonterminal[j+1])
            {
                temp=Nonterminal[j];
                Nonterminal[j]=Nonterminal[j+1];
                Nonterminal[j+1]=temp;

                temp2=terminal[j];
                terminal[j]=terminal[j+1];
                terminal[j+1]=temp2;
            }
        }
    }
}
bool find_first_set(int the_nonter_index,int store)
{
    int the_token;
    int find_next;
    bool next=false;
    bool see_next=false;
    //cout <<endl<<"IN: "<<store<<endl;
    //cout <<"the_nonter_index: "<<the_nonter_index<<endl;
    for(int i=0;i<terminal[the_nonter_index].size();i++)
    {
        next=false;
        the_token = token_type(terminal[the_nonter_index][i]);
        //cout <<"the_token: "<<the_token<<endl;
        switch(the_token)
        {
        case 0:
            //cout <<"case 0"<<endl;
            find_next=find_nonter(terminal[the_nonter_index][i]);
            see_next=find_first_set(find_next,store);
            next=see_next;
            //cout <<"first_set["<<store<<"]: "<<first_set[store]<<endl;
            //cout <<"next"<<next<<endl;
            break;
        case 1:
            //cout <<"case 1"<<endl;
            first_set[store]=first_set[store]+terminal[the_nonter_index][i];
            //cout <<"first_set["<<store<<"]: "<<first_set[store]<<endl;
            //cout <<"terminal["<<the_nonter_index<<"]["<<i<<"]: "<<terminal[the_nonter_index][i]<<endl;
            break;
        case 2:
            //cout <<"case 2"<<endl;
            see_next=true;
            nothing[the_nonter_index]=true;
            first_set[store]=first_set[store]+terminal[the_nonter_index][i];
            //cout <<"next"<<next<<endl;
            break;
        case 3:
            //cout <<"case 3"<<endl;
            nothing[store]=true;
            next=true;
            break;
        case 4:
            //cout <<"case 4"<<endl;
            first_set[store]=first_set[store]+"$";
            //cout <<"next"<<next<<endl;
            break;
        case -1:
            //cout <<"case -1"<<endl;
            break;
        }
        if(!next)
        {
            i++;
            while(terminal[the_nonter_index][i]!='|'&&(i)<terminal[the_nonter_index].size())
            {
                i++;
            }
            //cout <<"terminal["<<the_nonter_index<<"]["<<i<<"]: "<<terminal[the_nonter_index][i]<<endl;
            if(terminal[the_nonter_index][i]!='|')
            {
                break;
            }

        }else
        {
            //cout <<"i="<<i<<endl;
            if(i==terminal[store].size()-1)
            {
                //cout <<"nothing i="<<i<<endl;
                nothing[store]=true;
            }
        }

    }
    return see_next;
}
int token_type(char token)
{
   //cout <<"the token: "<<token<<endl;
   if(token>='a'&&token<='z')
   {
       return 0;
   }else if((token>='A'&&token<='Z')||token=='!'||token=='@'||token=='!'||token=='#'||token=='%'||token=='^'||token=='&'||token=='*')
   {
       return 1;
   }else if(token==';')
   {
       return 2;
   }else if(token=='|')
   {
       return 3;
   }else if(token=='$')
   {
       return 4;
   }else
   {
       return -1;
   }
}
int find_nonter(char ter)
{
    for(int i=0;i<index;i++)
    {
        if(ter==Nonterminal[i])
        {
            return i;
        }
    }
    return -1;
}
