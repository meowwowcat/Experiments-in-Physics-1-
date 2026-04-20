
# 高速化されたコード
using CSV
using DataFrames
using Plots
using Printf

# データ読み込み
df1 = CSV.read("light/data/干渉フィルター.csv", DataFrame; types=Float64)
df2 = CSV.read("light/data/直接光.csv", DataFrame; types=Float64)

#### グラフの作成#####

l = df1[:, 1]
direct = df2[:, 2]

# グラフの初期化
p = plot(xlabel="Wave lenght (nm)", ylabel="Transmittance ", legend=:topright)
over = plot(xlabel="Wave lenght (nm)", ylabel="Over Transmittance",
    legend=false,
    xlims=(500, 600),
    )

# ベクトル化で高速化：ループを避けて行列演算
data_matrix = Matrix(df1[:, 2:15])  # 2列目から15列目を行列に
over_matrix = data_matrix ./ direct  # 直接光との比をベクトル化

# 列名を取得
column_names = names(df1)[2:15]

# プロットを一度に追加（ベクトル化）
for (i, col) in enumerate(eachcol(data_matrix))
    plot!(p, l, col, label=column_names[i])
end

for (i, col) in enumerate(eachcol(over_matrix))
    plot!(over, l, col, label="Over " * column_names[i])
end

savefig(p, "light/figure/干渉フィルター.png")
savefig(over, "light/figure/Over_干渉フィルター.png")


####最大値####
#=

for i = 2:15
    y = df[:, i]
    max_value = maximum(y)
    @printf("Column %d: Max Value = %.2f\n", i, max_value)
end

=#



