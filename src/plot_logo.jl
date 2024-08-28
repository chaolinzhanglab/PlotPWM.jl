
function freq2xy(pfm; 
                 background=[0.25 for _ = 1:4],
                 dna=true, 
                 beta=1.0, # width of the x-axis for each letter in the motif
                 logo_x_offset = 0.0,
                 logo_y_offset = 0.0, 
                 alphabet_coords=ALPHABET_GLYPHS,
                 very_small_perturb = 1e-5 .* rand(4))
    # @assert sum(pfm, dims=1) .≈ 1 "pfm must be a probability matrix"
    all_coords = []
    charnames = dna ? dna_letters : rna_letters
    # For each character (row):
    #   Collect all positions and heights of that character's polygon
    for (j, c) in enumerate(charnames)
        xs, ys = Float64[], Float64[]
        # Get character glyph coords; o/w get the simple rectangle
        charglyph = get(alphabet_coords, c, BASIC_RECT)
        # for each postion in the sequence:
        #     1. Push in the coords for the character's polygon
        #     2. Adjust y_height based on information content and frequency 
        for (xoffset,col) in enumerate(eachcol(pfm))
            acgt = @view col[1:4]
            ic_height = ic_height_here(col; background=background)
            adjusted_height = ic_height .* acgt .+ very_small_perturb
            yoffset = sum(adjusted_height[adjusted_height .< adjusted_height[j]])
            push!(xs, ((beta * 1.2) .* charglyph.x .+ (1/((beta * 0.9)))*0.35 .+ xoffset .+ (logo_x_offset - 1))...)
            push!(xs, NaN)
            push!(ys, (adjusted_height[j] .* charglyph.y .+ yoffset .+ logo_y_offset)...)
            push!(ys, NaN)
        end        
        push!(all_coords, (c, (;xs, ys)))
    end
    all_coords
end

@userplot LogoPlot
@recipe function f(data::LogoPlot; 
                   dna=true, 
                   xaxis=false,
                   yaxis=false,
                   thickness_scaling=0.0525,
                   logo_x_offset=0.0,
                   logo_y_offset=0.0,
                   ytickfontsize=265,
                   margin=275Plots.mm,
                   dpi=300,
                   beta=1.0)
    num_cols = size(data.args[1], 2)
    width_factor = exp(-0.65*num_cols+7)+25
    logo_size = (width_factor*num_cols, 220)
    ylims --> (0, 2)
    xlims --> (-0.5, num_cols+1)
    framestyle --> :zerolines
    dpi --> dpi

    ticks --> :native
    yticks --> 0:1:2  # Ensure ticks are generated
    ytickfontcolor --> :gray
    ytick_direction --> :out
    ytickfontsize --> ytickfontsize
    yminorticks --> 25
    ytickfont --> font(45, "Helvetica")

    xtickfontcolor --> :gray
    xticks --> 1:1:num_cols
    xtickfontsize --> 145
    xaxis && (xaxis --> xaxis)
    yaxis && (yaxis --> yaxis)
    legend --> false
    tickdir --> :out
    grid --> false
    dtick--> 10
    margin --> margin
    thickness_scaling --> thickness_scaling
    size --> logo_size
    pfm = data.args[1]
    background = length(data.args) ≥ 2 ? data.args[2] : [0.25 for _ = 1:4]
    coords = freq2xy(pfm; background=background, dna=dna, beta=beta,
                     logo_x_offset=logo_x_offset, 
                     logo_y_offset=logo_y_offset);
    for (k, v) in coords
        @series begin
            fill := 0
            lw --> 0
            label --> k
            color --> get(AA_PALETTE3, k, :grey)
            v.xs, v.ys
        end
    end
end

"""
    save_logoplot(pfm, save_name; dpi=65)

# Arguments
- `pfm::Matrix{Real}`: Position frequency matrix
- `save_name::String`: Name of the path/file to save the plot

# Example
```julia
#= save the logo plot in the tmp folder as logo.png =#
save_logoplot(pfm, "tmp/logo.png")

#= save the logo plot in the current folder as logo.png with a dpi of 65 =#
save_logoplot(pfm, "logo.png"; dpi=65)

```
"""
function save_logoplot(pfm, save_name; dpi=65)
    p = logoplot(pfm; dpi=dpi)
    savefig(p, save_name)
end
