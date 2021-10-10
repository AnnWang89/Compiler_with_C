###### tags: `Compiler`
# Compiler Final Project

1. 用課程所學的lex和yacc來寫。
2. 架構為題目所提供的架構，而運算的分為兩個部分，第一部分為直接的運算，另一個部分為建tree的方式。
    * 第一部分是較為直觀，運算每個需要回傳的值(struct num)，其中:
    ```
    int i;//傳Numerical operation的結果或數字
    int b;//傳Logical Operations的結果或true false
    int index;//傳tree中node的index
    ```
    * 第二個部分是建tree:
        * 以矩陣的方式建tree。
        * 每個node都有5個變數:
        ```
        int inum; // 存放int 的運算結果
        int bnum; // 存放bool 的運算結果，0->false，1->true
        int ope; // 要做的運算，下方以表格呈現
        char* varn; // 存變數名稱
        int left; // tree 的left children 的index
        int right; // tree 的right children 的index
        ```


        | Ope   | 該節點所做的運算                                                       |
        | ----- | ---------------------------------------------------------------------- |
        | -1    | 此節點為leaf，不需要做運算。                                           |
        | 0     | 將left children的inum加right children的inum。                          |
        | 1     | 將left children的inum減right children的inum。                          |
        | 2     | 將left children的inum乘right children的inum。                          |
        | 3     | 將left children的inum除right children的inum。                          |
        | 4     | 將left children的inum mod right children的inum。                       |
        | 5     | 如果left children 的inum > right children的inum，bnum=1。反之bnum =0。 |
        | 6     | 如果left children 的inum < right children的inum，bnum=1。反之bnum =0。 |
        | 7     | 如果left children 的inum =right children的inum，bnum=1。反之bnum =0。  |
        | 8     | 將left children的bnum和right children的bnum做and運算。                 |
        | 9     | 將left children的bnum和right children的bnum做or運算。                  |
        | 10    | 將left children的bnum做not運算。                                       |
        | 11    | 用來判斷條件(if)，left children放條件，right children放結果。          |
        | 12    | if中用來看then 還是else，left children放then，right children放else。   |
        | 13~19 | 都是在function，以方便之後的運算，下方以圖來表示。                     |


        * 下方為function的ope概念參考圖，紅色的為ope。

          ![](https://i.imgur.com/BpUXK8Y.png)
        * 下方為if的ope概念參考圖，紅色的為ope。 

          ![](https://i.imgur.com/6p3v6af.png)

3. 以下針對所寫的function進行說明:
    * void defvar(char *v,int vn):
        定義新的變數的時候，確認該變數是否存在，若不存在，則把該變數放到矩陣中。
    * int findvar(char *v):
        預見一個變數名稱，要去找是否有定義過，如果有就取他的值。
    * int findvarinfun(char *v):
        和findvar相似，只是會多尋找function中的變數。
    * void checktype(int iorb,int what ):
        做type checking，也就是Bonus2的部分。
    * void printfun(int whichindex, int intorbool):
        如果是function，就要先存他的變數再去做處理。
    * void treetriverse(int start,int end,int intorbool,int prin):
        用bottom up的方式，看過所要用到的tree的部分，也就是從index start ~ end。如果要的結果是int，intorbool 傳0進去，如果要bool，intorbool 傳1進去。Prin是判斷要不要print出結果。

        以 (+ 1 (+ 2 3 4) (* 4 5 6) (/ 8 3) (mod 10 3))為例，
        如果想要知道他的結果是多少可以呼叫treetriverse(0,26,0,1)。
        如果只想知道(+ 2 3 4)的結果，可以呼叫treetriverse(1,7,0,1)。

        ![](https://i.imgur.com/0O2NIJY.png)

4. 目前進度完成Basic 1-7 及 Bonus 2。
