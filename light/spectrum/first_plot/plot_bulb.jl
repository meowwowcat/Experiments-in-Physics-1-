using CSV
using DataFrames
using Plots: plot, plot!, savefig
using Printf    

df1 = CSV.read("data/bulb 40ms.txt", DataFrame; types=Float64, header=false, delim='\t')
df2 = CSV.read("data/bulb 40ms bg.txt", DataFrame; types=Float64, header=false, delim='\t')

d = df1[:, 1]
l1 = df1[:, 2]
l2 = df2[:, 2]

Δl = l1 - l2

p = plot(d, Δl)

savefig(p, "figure/bulb_40ms.png")