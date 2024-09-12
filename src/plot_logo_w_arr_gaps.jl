
@userplot ArrowPlot
@recipe function f(data::ArrowPlot)
    coords = data.args[1]
    color --> :grey
    for coord in coords
        for v in coord
            @series begin
                fill := 0
                lw --> 0
                # label --> k
                v.x, v.y
            end
        end
    end
end

"""
ds_mat: Matrix of distances between the pfms
    e.g. 12 6
         32 8
    number of rows = number of "modes" of distances
    number of columns = number of distance in between the pfms
weights: weights for each mode of distances
optional parameters:
    given_num_cols: the total number of columns that will be occupied for all the arrow-shapes
    arrow_shape_scale_ratio: the ratio by which the width of the arrow-shapes will be scaled
    height_top: the maximum height of the arrow-shapes
"""
function logoplot_with_arrow_gaps(pfms, 
    ds_mats::AbstractMatrix,
    weights::AbstractVector;
    given_num_cols::Int=15,
    arrow_shape_scale_ratio::Real=0.7,
    height_top::Real=1.7
    ) where T<:Real

    @assert length(pfms)-1 == size(ds_mats, 2) "The number of columns in ds_mats should be equal to the length of pfms - 1"
    @assert length(weights) == size(ds_mats, 1) "The number of rows in ds_mats should be equal to the length of weights"
    
    coords_mat, pfm_starts, total_pfm_cols, total_d_cols = 
        make_arrow_shapes(ds_mats, weights, given_num_cols, pfms;
        arrow_shape_scale_ratio=arrow_shape_scale_ratio, height_top=height_top)

    p = nothinglogo(total_pfm_cols + total_d_cols);    
        
    for (ind, pfm) in enumerate(pfms)
        logo_x_offset = pfm_starts[ind]
        logoplot!(p, pfm, PlotPWM.bg; 
                    dpi=65,
                    setup_off=true, 
                    logo_x_offset=logo_x_offset)
    end

    for col in eachcol(coords_mat)
        arrowplot!(p, col)
    end
    return p
end