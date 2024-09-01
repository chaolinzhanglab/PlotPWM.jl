
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
                   setup_off=false,
                   margin=275Plots.mm,
                   dpi=300,
                   beta=1.0,
                   alpha=1.0
                   )
    if !setup_off
        num_cols = size(data.args[1], 2)
        ylims --> (0, 2)
        xlims --> (-0.5, num_cols+1)
        logo_size = (_width_factor_(num_cols)*num_cols, 220)
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
        framestyle --> :zerolines
    end
    dpi --> dpi
    alpha --> alpha
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

# check if there's any overlap in the highlighted region
function chk_overlap(highlighted_regions::Vector{UnitRange{T}}) where T <: Integer
    for i in 1:length(highlighted_regions)-1
        if is_overlapping(highlighted_regions[i], highlighted_regions[i+1])
            return true
        end
    end
    return false
end

# plot the logo with highlight
function logoplot_with_highlight(
        pfm::AbstractMatrix, 
        background::AbstractVector, 
        highlighted_regions::Vector{UnitRange{Int}};
        dpi=65,
        alpha = _alpha_
    )

    if length(highlighted_regions) > 1
        @assert !chk_overlap(highlighted_regions) "highlighted_regions shouldn't be overlapping"
    end
    
    num_columns = size(pfm, 2)
    range_complement = complement_ranges(highlighted_regions, num_columns)
    p = nothinglogo(num_columns);
    for r in range_complement
        logo_x_offset = r.start-1
        logoplot!(p, 
                  (@view pfm[:, r]), background; 
                  alpha=alpha,
                  dpi=dpi,
                  setup_off=true, 
                  logo_x_offset=logo_x_offset)
    end
    for r in highlighted_regions
        logo_x_offset = r.start-1
        logoplot!(p, (@view pfm[:, r]), background; 
                     dpi=dpi,
                     setup_off=true, 
                     logo_x_offset=logo_x_offset)
    end
    return p
end

function logoplot_with_highlight(
        pfm::AbstractMatrix, 
        highlighted_regions::Vector{UnitRange{Int}})
    return logoplot_with_highlight(pfm, 
                                   default_genomic_background, 
                                   highlighted_regions)
end


"""
    save_logoplot(pfm, background, save_name; dpi=65)

# Arguments
- `pfm::Matrix{Real}`: Position frequency matrix
- `background::Vector{Real}`: Background probabilities of A, C, G, T
- `save_name::String`: Name of the path/file to save the plot

Note that
- `pfm` must be a probability matrix
    - sum of each column must be 1
- `background` must be a vector of length 4
    - must be a vector of probabilities
    - sum of `background` must be 1

# Example
```julia

pfm =  [0.02  1.0  0.98  0.0   0.0   0.0   0.98  0.0   0.18  1.0
        0.98  0.0  0.02  0.19  0.0   0.96  0.01  0.89  0.03  0.0
        0.0   0.0  0.0   0.77  0.01  0.0   0.0   0.0   0.56  0.0
        0.0   0.0  0.0   0.04  0.99  0.04  0.01  0.11  0.23  0.0]

background = [0.25, 0.25, 0.25, 0.25]

#= save the logo plot in the tmp folder as logo.png =#
save_logoplot(pfm, background, "tmp/logo.png")

#= save the logo plot in the current folder as logo.png with a dpi of 65 =#
save_logoplot(pfm, background, "logo.png"; dpi=65)

```
"""
function save_logoplot(pfm, background, save_name::String; dpi=65, highlighted_regions=nothing)
    @assert all(sum(pfm, dims=1) .≈ 1) "pfm must be a probability matrix"
    @assert length(background) == 4 "background must be a vector of length 4"
    @assert all(0 .≤ background .≤ 1) "background must be a vector of probabilities"
    @assert sum(background) ≈ 1 "background must sum to 1"
    if isnothing(highlighted_regions)
        p = logoplot(pfm, background; dpi=dpi, highlighted_regions=highlighted_regions)
    else
        p = logoplot_with_highlight(pfm, background, highlighted_regions; dpi=dpi)
    end
    savefig(p, save_name)
end

"""
    save_logoplot(pfm, save_name; dpi=65)

    This is the same as `save_logoplot(pfm, background, save_name; dpi=65)`
    where `background` is set to `[0.25, 0.25, 0.25, 0.25]`

    See `save_logoplot(pfm, background, save_name; dpi=65)` for more details.
"""
function save_logoplot(pfm, save_name::String; dpi=65, highlighted_regions=nothing)
    save_logoplot(pfm, default_genomic_background, save_name; dpi=dpi, highlighted_regions=highlighted_regions)
end