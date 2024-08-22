
ic_height_uniform(x; bg = 0.25, ϵ = 1e-20) = x * log2((x + ϵ) / bg)
ic_height(col, bg; ϵ = 1e-30) = col .* log2.((col .+ ϵ) ./ bg)
# ic_height_here(col) = sum(ic_height_uniform.(col))
ic_height_here(col; background=[0.25 for _ = 1:4]) = sum(ic_height(col, background))


width_factor(num_cols) = exp(-0.65*num_cols+7)+25