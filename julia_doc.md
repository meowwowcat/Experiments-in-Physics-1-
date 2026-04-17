# Julia 
juliaで忘れがちなものを記述します．実験自体にはほとんど関係ないです．
基本メモとして使います．

## csv,dataframes について
csvファイルを読み取る時にcsv.jl,dataframes.jl を使います．そのとき，
```
CSV.read("file_name.csv",Dataframe)
```
と記述します．この時読み取るcsvファイルの一行目はheaderとなるため扱う数値は二行目からになります．
参考　[Header = false not working ](https://discourse.julialang.org/t/header-false-not-working/84174)

なお，csvでではなく，xlsl形式でも読み取ることができる．(コードを多少書き換える必要あり．)