%{
    #include <stdio.h>
    #include <string.h>

    int yylex(void);
    void yyerror(const char *);
%}

/* This section defines the data type used in the `%union` section. */
%code requires {
    typedef struct {
        struct record {
            char* elem;
            int num;
        } table[100];
        size_t table_size;
    } dict;
}

/* This section defines the additional function using the data type in
 * `%code requires` section.
*/
%code provides {
    dict create_dict(void);
    void add_record(dict*, char*, int);
    dict merge_dict(dict, dict);
    dict diff_dict(dict, dict);
    void sort_dict(dict*);
    void show_dict(dict);
}

%union {
    int ival;
    char* elem;
    dict d;
}

/* declarations */
%token <ival> INTEGER
%token <elem> ELEM
%type <d> expr
%type <d> formula

/* precedences */
%left ARROW
%left '+'
%nonassoc '(' ')'
%nonassoc ELEM
%nonassoc INTEGER
%nonassoc REDUCE_FORMULA    // force `formula . formula` reduce instead of
                            // shifting

%%
line    : expr ARROW expr '\n'  {
                                    dict d = diff_dict($1, $3);
                                    sort_dict(&d);
                                    show_dict(d);
                                }
        ;

expr    : expr '+' expr         {$$ = merge_dict($1, $3);}
        | INTEGER formula       {   // factor of the compound
                                    size_t i;
                                    for (i = 0; i < $2.table_size; i++)
                                        $2.table[i].num *= $1;
                                    $$ = $2;
                                }
        | formula               {$$ = $1;}
        ;

formula : formula formula %prec REDUCE_FORMULA {
                                $$ = merge_dict($1, $2);
                                }
        | '(' formula ')' INTEGER {
                                    size_t i;
                                    for (i = 0; i < $2.table_size; i++)
                                        $2.table[i].num *= $4;
                                    $$ = $2;
                                }
        | '(' formula ')'       {$$ = $2;}
        | ELEM INTEGER          {
                                    dict d = create_dict();
                                    add_record(&d, $1, $2);
                                    $$ = d;
                                }
        | ELEM                  {
                                    dict d = create_dict();
                                    add_record(&d, $1, 1);
                                    $$ = d;
                                }
        ;

%%

void yyerror(const char *message) {
    printf("Invalid format\n");
}

int main(void) {
    yyparse();
    return 0;
}

dict create_dict(void)
{
    dict d;
    d.table_size = 0;
    return d;
}

void add_record(dict* d, char* elem, int num)
{
    size_t i;
    for (i = 0; i < d->table_size; i++)
        if (strcmp(d->table[i].elem, elem) == 0) {
            d->table[i].num += num;
            return;
        }
    // for-else (not finding the elem in table --> append new elem)
    d->table[d->table_size].elem = elem;
    d->table[d->table_size++].num = num;
}

dict merge_dict(dict d1, dict d2)
{
    size_t i;
    for (i = 0; i < d1.table_size; i++)
        add_record(&d2, d1.table[i].elem, d1.table[i].num);
    return d2;
}

dict diff_dict(dict d1, dict d2)
{
    size_t i, j;
    for (i = 0; i < d1.table_size; i++)
        for (j = 0; j < d2.table_size; j++)
            if (strcmp(d1.table[i].elem, d2.table[j].elem) == 0)
                d1.table[i].num -= d2.table[j].num;
    unsigned int in_dict;
    for (j = 0; j < d2.table_size; j++) {
        in_dict = 0;
        for (i = 0; i < d1.table_size; i++)
            if (strcmp(d1.table[i].elem, d2.table[j].elem) == 0) {
                in_dict = 1;
                break;
            }
        if (!in_dict)
            add_record(&d1, d2.table[j].elem, -d2.table[j].num);
    }
    return d1;
}

void sort_dict(dict* d)
{
    size_t i, j;
    struct record temp;
    for (i = 0; i < d->table_size - 1; i++)
        for (j = i + 1; j < d->table_size; j++)
            if (strcmp(d->table[i].elem, d->table[j].elem) > 0) {
                temp = d->table[i];
                d->table[i] = d->table[j];
                d->table[j] = temp;
            }
}

void show_dict(dict d)
{
    size_t i;
    for (i = 0; i < d.table_size; i++)
        if (d.table[i].num != 0)
            printf("%s %d\n", d.table[i].elem, d.table[i].num);
}
