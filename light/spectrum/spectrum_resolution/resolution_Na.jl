using CSV   
using DataFrames
using CairoMakie
using Peaks
using LsqFit   
using Printf

df1 = CSV.read("data/Hg 17ms.txt", DataFrame; types=Float64, header=false, delim='\t')
df2 = CSV.read("data/Hg 17ms bg.txt", DataFrame; types=Float64, header=false, delim='\t')

d = df1[:, 1]
l1 = df1[:, 2]
l2 = df2[:, 2]  
Δl = l1 - l2

fig = Figure()
ax = Axis(fig[1, 1], xlabel="d", ylabel="Δl")
lines!(ax, d, Δl,  color=:blue)

indices, heights = findmaxima(Δl)


mask = heights .> 500   #ピークの高さを任意の値以上に制限．今回は500以上のピーク．
filtered_indices = indices[mask]
filtered_heights = heights[mask]
filtered_positions = d[filtered_indices]

#ピークの位置と値をDataframeにまとめる
result = DataFrame(
    position = filtered_positions,
    peak = filtered_heights
    
)

#ピークをCSVファイルに保存
CSV.write("spectrum_resolution/peak/Hg.csv", result)


peak = scatter!(ax, filtered_positions, filtered_heights, color=:red)
save("spectrum_resolution/figure/Hg_peaks.png", fig)

mat_d =  zeros(Float64,length(Δl), length(filtered_positions))

n = length(filtered_positions)

for i =1:n
    mat_d[:, i] = d .- filtered_positions[i]
end

fig_2 = Figure(size = (1000, 500))

### define gaussian
gaussian(x, p) = p[1] .* exp.(-0.5 .* (x ./ p[2]).^2)

### define axes 
axes = Vector{Axis}(undef, n)

for i= 1:n
    axes[i] = Axis(fig_2[1, i], 
        limits = ((-2.0, 2.0), nothing)
        #=xlabel = "Δd (relative to peak)", 
        ylabel = "Intensity (Δl)", 
        title = "Peak at $(filtered_positions[i])"=#
    )
    scatter!(axes[i], mat_d[:, i], Δl,label="Peak at $(filtered_positions[i])")

end

σ = Vector{Float64}(undef, n)
for i = 1:n
    fit_mask = -2.0 .<= mat_d[:, i] .<= 2.0
    x_data = mat_d[fit_mask, i]
    y_data = Δl[fit_mask]

    p0 = [filtered_heights[i], 0.3] 
    fit = curve_fit(gaussian, x_data, y_data, p0)
    p_fit = fit.param

    σ[i] = 2 * p_fit[2] *  sqrt(2 * log(2))  
    

    x_plot = range(-2, 2, length=200)
    lines!(axes[i], x_plot, gaussian(x_plot, p_fit), color = :red, linewidth = 2)

    open("spectrum_resolution/bunkainou/bunkainou_Hg.txt", "a") do io
        @printf(io, "Na\n")
        @printf(io, "波長: %f, ピークの値: %f\n", filtered_positions[i]  , filtered_heights[i])
        @printf(io, "フィットしたパラメータ: A = %f, σ = %f\n", p_fit[1], p_fit[2])
        @printf(io, "スペクトルの分解能 (FWHM): %f\n", σ[i])   
    end

end



save("spectrum_resolution/figure/Hg_fits.png", fig_2)
