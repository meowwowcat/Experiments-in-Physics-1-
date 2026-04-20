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

    y = df[:, i]

    label_name = names(df)[i]
    
    plot!(p, l, y, label=label_name)
end

savefig(p, "figure/NDフィルター.png")




for i = 2:11
    y = df[:, i]
    max_value = maximum(y)
    @printf("Column %d: Max Value = %.2f\n", i, max_value)

    
end
