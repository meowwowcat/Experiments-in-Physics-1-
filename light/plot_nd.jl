using CSV
using DataFrames
using Plots
using Printf


df = CSV.read("data/NDフィルター.csv", DataFrame)

l = df[:, 1]

# グラフの初期化
p = plot(xlabel="Wave lenght (nm)", ylabel="Transmittance ", legend=:false#=topright=#)

# 2列目から11列目までをループで回して重ねる
for i in 2:11
    # データを一時変数として取得
    y = df[:, i]
    # 各列のラベルを列名から取得（ラベルがない場合は"ND"等に変更可能）
    label_name = names(df)[i]
    
    # グラフに追加（! をつけると既存のグラフに追加される）
    plot!(p, l, y, label=label_name)
end

savefig(p, "figure/NDフィルターのスペクトル特性.png")

