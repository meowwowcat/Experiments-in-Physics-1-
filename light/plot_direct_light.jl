using CSV
using DataFrames
using Plots
using Printf


df = CSV.read("data/直接光.csv", DataFrame)

#### グラフの作成#####

l = df[:, 1]

# グラフの初期化

y = df[:, 2]
label_name = names(df)[2]

plot!(p, l, y, label=label_name)


savefig(p, "figure/直接光.png")