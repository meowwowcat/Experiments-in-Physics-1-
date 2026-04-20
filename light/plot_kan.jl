
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
over = plot(xlabel="Wave lenght (nm)", ylabel="Transmittance",
    label=false,
    xlims=(500, 575),ylims=(0, 0.4)
    )

# ベクトル化で高速化
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
savefig(over, "light/figure/Transmittance_干渉フィルター.png")

# 最大透過率の波長を調べる
println("\n最大透過率の波長:")
data_matrix = Matrix(df1[:, 2:15])
max_vals = maximum(data_matrix, dims=1)  # 各列の最大値
max_indices = argmax(data_matrix, dims=1)  # 各列の最大値のインデックス（CartesianIndex）
column_names = names(df1)[2:15]

# 結果をDataFrameにまとめる
results = DataFrame(
    Column = column_names,
    Max_Transmittance = Base.vec(max_vals),
    Wavelength_nm = [l[max_indices[i][1]] for i in 1:length(column_names)]
)

# CSVに保存
CSV.write("light/data/kan_透過率.csv", results)

# 出力
for row in eachrow(results)
    @printf("%s: Max Transmittance = %.2f at Wavelength = %.2f nm\n", row.Column, row.Max_Transmittance, row.Wavelength_nm)
end


