


# Julia 
juliaで忘れがちなものを記述します．実験自体にはほとんど関係ないです．
基本メモとして使います．

図の作成は主にPlots.jlを用います．ただし，将来的にはMakie.jlに変えるつもりです．

## csv,dataframes について
csvファイルを読み取る時にcsv.jl,dataframes.jl を使います．そのとき，
```
CSV.read("file_name.csv",Dataframe)
```
と記述します．この時読み取るcsvファイルの一行目はheaderとなるため扱う数値は二行目からになります．
参考:[Header = false not working ](https://discourse.julialang.org/t/header-false-not-working/84174)

なお，csvでではなく，xlsl形式でも読み取ることができる．(コードを多少書き換える必要あり．)

## 配列等に関して Aは行列とする
maximum(A,dims=1)は各列の最大値を計算している．
maximum(A,dims=2)は各行の最大値を計算している．

+ 例
```
julia>A = [
    1,2,3
    4,5,6
    7,8,9
]
```
```math
A = 
\begin{pmatrix}
1  & 2 & 3 \\
4 & 5 & 6 \\
7 & 8 & 9
\end{pmatrix}
```
とする．
この時，```dims=1```　は
```
julia>maximum(A,dims=1)

7 8 9
```
となり，各列の最大値が表示される．
また，```dims=2```とすると，
``` 
julia>maximum(A,dims=2 )

3 6 9
```
となり，各行の最大値が表示される．



