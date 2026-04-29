using CSV   
using DataFrames
using CairoMakie
using Peaks
using LsqFit   
using Printf

df1 = CSV.read("light/マイケルソン/data/白1.csv", DataFrame)

λ = 600 # 波長
Δl = df1[:,2] #移動変化量Δ
d = 2.03 * 10^6 # 厚み
n_N = -4:1:4 # xranges
n_n = 1.3:0.1:1.9 # 屈折率
x_plot = range(-4, 4, length=20000) #plot用のxの点
θ = n_N * π ./ 180 #deg -> rad
# 保存する用の行列(配列)
D = zeros(Float64, length(n_N), length(n_n))


# figureの設定
fig = Figure()
axis = Axis(fig[1,1])
#=
fi = Figure()
axi = Axis(fi[1,1])
=#


# 理論値の屈折率におけるグラフのplot
for j = 1 : length(n_n)
    ϕ = asin.(sin.(θ ./ n_n[j])) #ϕはrad
    vec_D = d .* ( n_n[j] .* (1 ./ cos.(ϕ) .- 1) .- ( cos.(θ .- ϕ) ./ cos.(ϕ) .- 1) ) #D=Δ + δの式 
    D[:,j] = vec_D # Dに格納
    # plot
    lines!(axis,n_N,D[:,j],label="n = $(n_n[j])") 
    axislegend(axis,labelsize=10)  
end

#= ここで用いたでできた値の保存csv
result = DataFrame(
    θ= θ,
    ϕ_vec = ϕ
)
result_D = DataFrame(D, :auto)


output_dir1 = "light/マイケルソン/data2"
if !ispath(output_dir1)
    mkpath(output_dir1)
end

CSV.write("light/マイケルソン/data2/予測光路差_白1.csv", result) =#
CSV.write("light/マイケルソン/data2/D_白1.csv", result_D)


#display(fig)

###########実験値の解析####################

# Δlからlに変換
l = cumsum(Δl)
# Dを求める　D = 1/2 λl ,lは246を基準とした移動量，D_l はvector
D_l = 1/2 .* l  .* λ

# xlabel=n_N,ylabel=D_l
scatter!(axi,n_N,D_l)

# フィっティイング Lsqfitを用いた


    
d2(t,p) = p[1] .* t.^2  .+ p[2] .* t .+ p[3]#fitting function
pθ = [1.0,1.0,1.0] # 
fit = curve_fit(d2,n_N,D_l,pθ)  
p_fit = coef(fit)
yfit = d2(x_plot, p_fit) #fitした関数のy座標を作成
#scatter!(axi,x_plot, yfit)

#display(fi)

# 平方完成
δx = - p_fit[2]/ (2 * p_fit[1]) #平方完成した時のxのズレ
δy = p_fit[3] -(p_fit[2]^2) /( 4 * p_fit[1]) #平方完成した時のyのズレ
# 平方完成の式，いらない　
#  fit_1(x) = p_fit[1] * ( x + δx)^2 + δy

# 座標変換
new_N = n_N .-  δx
new_Dl =  δy .- D_l
h(x) = - p_fit[1] * x.^2
h_y = h(new_N)
#scatter!(axis,new_N,new_Dl)
scatter!(axis,new_N,h_y,color=:red)

display(fig)





