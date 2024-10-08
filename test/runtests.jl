using PlotPWM
using Test

@testset "PlotPWM.jl" begin

pfm =  [0.02  1.0  0.98  0.0   0.0   0.0   0.98  0.0   0.18  1.0
        0.98  0.0  0.02  0.19  0.0   0.96  0.01  0.89  0.03  0.0
        0.0   0.0  0.0   0.77  0.01  0.0   0.0   0.0   0.56  0.0
        0.0   0.0  0.0   0.04  0.99  0.04  0.01  0.11  0.23  0.0]

background = [0.25, 0.25, 0.25, 0.25]

# test basic plotting is ok
@test begin 
    logoplot(pfm, background)
    true
end

C = [0.01  0.01  0.03  0.0   0.37  0.03  0.02  0.03  0.01  0.0
     0.01  0.0   0.11  0.01  0.26  0.0   0.03  0.01  0.02  0.01]

# test basic plotting is ok for crosslinking
@test begin
    logoplotwithcrosslink(pfm, background, C; rna=true)
    true
end

highlighted_regions1=[1:3, 7:10]
highlighted_regions2=[4:8]

# test if plotting is ok for highlighted regions
@test begin
    logoplot_with_highlight(pfm, background, highlighted_regions1)
    logoplot_with_highlight(pfm, background, highlighted_regions2)
    true
end

# test if plotting is ok for crosslinking with highlighted regions
@test begin
    logoplot_with_highlight_crosslink(pfm, background, C, highlighted_regions1)
    logoplot_with_highlight_crosslink(pfm, background, C, highlighted_regions2)
    true
end

# test if output file is created for logoplot
@test begin
    output_file = "output_plot.png"  # Replace with your file path
    save_logoplot(pfm, background, output_file; highlighted_regions=highlighted_regions2)
    # Optionally, delete the file after the test
    test_condition = isfile(output_file)  # Check if the file exists
    rm(output_file; force=true)
    test_condition
end

# test if output file is created for crosslinked logoplot
@test begin
    output_file = "output_plot_crosslinked.png"  # Replace with your file path
    save_crosslinked_logoplot(pfm, background, C, output_file; highlighted_regions=highlighted_regions2)
    # Optionally, delete the file after the test
    test_condition = isfile(output_file)  # Check if the file exists
    rm(output_file; force=true)
    test_condition
end

end
