# 高速化されたコード (Makie使用)
using CSV
using DataFrames
using CairoMakie
using Printf

# データ読み込み
df1 = CSV.read("light/透過率/data/干渉フィルター.csv", DataFrame; types=Float64)
df2 = CSV.read("light/透過率/data/直接光.csv", DataFrame; types=Float64)

#### グラフの作成#####

l = df1[:, 1]
direct = df2[:, 2]

# グラフの初期化
fig1 = Figure()
ax1 = Axis(fig1[1,1], xlabel="Wavelength (nm)", ylabel="Transmittance", title="Interference Filter")
fig2 = Figure()
ax2 = Axis(fig2[1,1], xlabel="Wavelength (nm)", ylabel="Transmittance",
    limits=(500, 575, 0, 0.4), title="Normalized Transmittance")

# ベクトル化で高速化
data_matrix = Matrix(df1[:, 2:15])  # 2列目から15列目を行列に
over_matrix = data_matrix ./ direct  # 直接光との比をベクトル化

# 列名を取得
column_names = names(df1)[2:15]

# プロットを一度に追加（ベクトル化）
for (i, col) in enumerate(eachcol(data_matrix))
    lines!(ax1, l, col, label=column_names[i])
end

for (i, col) in enumerate(eachcol(over_matrix))
    lines!(ax2, l, col, label=column_names[i] * "°")
end

axislegend(ax1, position=:rt)
axislegend(ax2, position=:lt)

save("light/透過率/figure/干渉フィルター_makie.pdf", fig1)
save("light/透過率/figure/Transmittance_干渉フィルター_makie.pdf", fig2)

# 最大透過率の波長を調べる
println("\n最大透過率の波長:")
data_matrix = Matrix(df1[:, 2:15])
max_vals = maximum(data_matrix, dims=1)  # 各列の最大値
max_indices = argmax(data_matrix, dims=1)  # 各列の最大値のインデックス（CartesianIndex）
column_names = names(df1)[2:15]

# 結果をDataFrameにまとめる
results = DataFrame(
    Column = column_names,
    Wavelength_max = [l[max_indices[i][1]] for i in 1:length(column_names)],
    Max_Transmittance = vec(max_vals)
    
)

# CSVに保存
CSV.write("light/透過率/data/kan_最大透過率.csv", results)

# 入射角と最大透過率の関係
angles = [parse(Int, replace(col, "dig" => "")) for col in column_names]
fig3 = Figure()
ax3 = Axis(fig3[1,1], xlabel="Angle of Incidence (θ)", ylabel="Maximum Transmittance")
lines!(ax3, angles, vec(max_vals))
save("light/透過率/figure/波長_最大透過率_makie.pdf", fig3)
