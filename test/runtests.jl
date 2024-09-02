using PlotPWM
using Test

@testset "PlotPWM.jl" begin

pfm =  [0.02  1.0  0.98  0.0   0.0   0.0   0.98  0.0   0.18  1.0
        0.98  0.0  0.02  0.19  0.0   0.96  0.01  0.89  0.03  0.0
        0.0   0.0  0.0   0.77  0.01  0.0   0.0   0.0   0.56  0.0
        0.0   0.0  0.0   0.04  0.99  0.04  0.01  0.11  0.23  0.0]

background = [0.25, 0.25, 0.25, 0.25]

# test basic the plotting is ok
@test begin 
        logoplot(pfm, background)
        true
end

C = [0.01  0.02  0.03  0.0   0.37  0.03  0.02  0.03  0.02  0.0
     0.03  0.0   0.11  0.04  0.26  0.0   0.03  0.01  0.02  0.02]

@test begin
    logoplotwithcrosslink(pfm, background, C; rna=true)
    true
end

end
