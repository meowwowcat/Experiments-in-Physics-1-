using CSV
using DataFrames
using CairoMakie

# データのimport
df1 = CSV.read("light/マッハツェンダー/data/kaidan.csv",DataFrame)

# 定数の設定
Number = df1[:,1]
vol = Matrix(df1[:, [3, 5, 7]])
pre = Matrix(df1[:,[2,4,6]])
λ_l = 633

# FIgureの設定
fig = Figure()
axis = Axis(fig[1,1])



for i = 1:3
    scatter!(axis,pre[:,i]vol[:,i])
end
