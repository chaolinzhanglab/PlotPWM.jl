using Plots
using PlotPWM


pfm1 =  [0.02  1.0  0.98  0.0   0.0   0.0   0.98  0.0   0.18  1.0
         0.98  0.0  0.02  0.19  0.0   0.96  0.01  0.89  0.03  0.0
         0.0   0.0  0.0   0.77  0.01  0.0   0.0   0.0   0.56  0.0
         0.0   0.0  0.0   0.04  0.99  0.04  0.01  0.11  0.23  0.0]

pfm2 =  [0.02  1.0  0.98  0.0   0.0   0.0   0.98  0.0   0.18  1.0
         0.98  0.0  0.02  0.19  0.0   0.96  0.01  0.89  0.03  0.0
         0.0   0.0  0.0   0.77  0.01  0.0   0.0   0.0   0.56  0.0
         0.0   0.0  0.0   0.04  0.99  0.04  0.01  0.11  0.23  0.0]

pfm3 =  [0.02  1.0  0.98  0.0   0.0   0.0   0.98  0.0   0.18  1.0
         0.98  0.0  0.02  0.19  0.0   0.96  0.01  0.89  0.03  0.0
         0.0   0.0  0.0   0.77  0.01  0.0   0.0   0.0   0.56  0.0
         0.0   0.0  0.0   0.04  0.99  0.04  0.01  0.11  0.23  0.0]

pfms = [pfm1, pfm2, pfm3]





#=
by 
=#
function plt2chk(coords; xlim=(-60,60), ylim=(-0,2), arr_ratio=0.5)
    _coords_ = deepcopy(coords)
    total_width = xlim[2] - xlim[1] 
    adjusted_width = arr_ratio * total_width
    # scale_width!(_coords_, adjusted_width)
    # scale_height!(_coords_, arr_ratio * 1.0) # 1.0 is the original height
    
    p = nothing
    for i in eachindex(_coords_)
        if i == 1
            p = plot(_coords_[1].x, _coords_[1].y, seriestype = :shape, fillalpha=0.5, ylim=ylim, xlim=xlim, 
                    legends=false,
                    size=(PlotPWM._width_factor_(12)*12, 220), fillcolor=:darkgray, linecolor=:black)
        else
            plot!(p, _coords_[i].x, _coords_[i].y, seriestype = :shape, fillalpha=0.5, fillcolor=:darkgray, linecolor=:black)
        end
    end
    display(p)
end

function plot_shape(_coords_; xlim=(0, 10),  ylim=(0,2))
    p = nothing
    for i in eachindex(_coords_)
        if i == 1
            p = plot(_coords_[1].x, _coords_[1].y, seriestype = :shape, fillalpha=0.5, ylim=ylim, xlim=xlim, 
                    legends=false,
                    size=(PlotPWM._width_factor_(12)*12, 220), fillcolor=:darkgray, linecolor=:black)
        else
            plot!(p, _coords_[i].x, _coords_[i].y, seriestype = :shape, fillalpha=0.5, fillcolor=:darkgray, linecolor=:black)
        end
    end
    return p
end



#=
Initially, coords initlized as Vector{shape}; 
    It lies within the range of 0 and 2 in the y axis, 
    and lies within the range of 0 to some arbitrary point in the x axis

Note: 
    By default, make_in_between_basic makes a logo such that its hieght is in between 0 and 2
=#
mutable struct coords_matrix
    # each column is a set of arrow-shapes that represented mode of distances between the pfms
    coords_mat::Matrix{Vector{shape}} # Matrix of arrow-shapes;

    function coords_matrix(mat::Matrix{T}, weights::AbstractVector) where T <: Real
        @assert size(mat, 1) == length(weights) "The number of rows in mat should be equal to the length of weights"
        coords_mat = map(x->make_in_between_basic(x; arrow_line_scale=log(x)), mat)

        # TODO use weights to scale the inner height of the arrow-shapes in each column
            # TODO also needs to translate it upwards (for "shorter" ones)
        # TODO center align each arrow-shape in each column
        # TODO place each column of arrow-shapes in the right positions
        new(coords_mat)
    end
end


coords = make_in_between_basic(11; arrow_line_scale=1.25)

# get_height(coords)
# scale_width!(coords, 45.0)

# scale_height!(coords,  2.0)
# scale_height!(coords,  2.0)
# scale_width!(coords, 2.0)

# y_substract!.(coords, 0.5)

# coords[1].y[1] = 22
# coords[1].y
# coords[2].y
# y_substract!(coords, 0.5)

# min_max_normalize_y!(coords)

# plt2chk(coords)


######################################

function get_height_increments(scaled_heights)
    vcat(reverse(cumsum(reverse(scaled_heights)))[2:end], 0)
end

function get_center_point_x(vec_shape::Vector{shape})
    right_most_pt = get_right_most_point(vec_shape)
    left_most_pt = get_left_most_point(vec_shape)
    return (right_most_pt + left_most_pt) / 2
end

function get_center_point_y(vec_shape::Vector{shape})
    top_most_pt = get_top_most_point(vec_shape)
    bottom_most_pt = get_bottom_most_point(vec_shape)
    return (top_most_pt + bottom_most_pt) / 2
end

#=
num_col_each_col!(coords_mat::Matrix{Vector{shape}}, given_len)
    coords_mat: Matrix of arrow-shapes
    given_len: the total length given for all the columns of arrow-shapes
Note that this function does the following: 
    1. scale the width of each arrow-shapes
    2. returns the number of columns for each "column"
=#
function num_col_each_col!(coords_mat::Matrix{Vector{shape}}, given_len)
    widths = get_width.(coords_mat)
    # get the maximum length of each column (set of arrow-shapes)
    max_widths_each_col = maximum(widths, dims=1)
    each_col_ratio = max_widths_each_col ./ sum(max_widths_each_col)
    num_cols_each = Int.(ceil.(given_len .* each_col_ratio))

    adjusted_lengths = num_cols_each .* (widths ./ max_widths_each_col)
    scale_width!.(coords_mat, adjusted_lengths)
    return num_cols_each
end

function obtain_pfm_regions_and_dstarts(pfms, num_cols_each; d_ϵ = 0.5)
    pfm_num_cols_each = size.(pfms,2)
    pfm_starts = Int[]
    d_starts = Int[]
    offset = 0
    for (ind, p_col) in enumerate(pfm_num_cols_each)
        push!(pfm_starts, offset)
        offset += p_col
        if ind ≤ length(num_cols_each)
            push!(d_starts, offset)
            offset += num_cols_each[ind]
        end
    end
    return pfm_starts, d_starts .+ d_ϵ
end



ds_mats = [12 6; 32 6]
weights = [0.7, 0.3]

#=

dist_cols:

=#

function make_arrow_shapes(ds_mats, weights, dist_cols::Int, pfms; 
    arrow_shape_scale_ratio=0.8, height_top=2.0)
    coords_mat = map(x->make_in_between_basic(x; arrow_line_scale=1.0), ds_mats)
    # scale the width of each arrow-shapes and 
    # get the number of columns for each "column"
    num_cols_each = num_col_each_col!(coords_mat, dist_cols)
    pfm_starts, d_starts = obtain_pfm_regions_and_dstarts(pfms, num_cols_each)

    # shift heights
    scaled_heights = weights .* height_top
    scale_height!.(coords_mat, scaled_heights)

    # centering 
    center_pts_x_orig = get_center_point_x.(coords_mat)
    center_pts_y_orig = get_center_point_y.(coords_mat)
    max_center_x = maximum(center_pts_x_orig, dims=1)
    scale_width_height_by_proportion!.(coords_mat, arrow_shape_scale_ratio)
    center_pts_x = get_center_point_x.(coords_mat)
    center_pts_y = get_center_point_y.(coords_mat)

    right_shift_pts = max_center_x .- center_pts_x
    up_shift_pts = center_pts_y_orig .- center_pts_y
    coords_mat = shift_right.(coords_mat, right_shift_pts)
    coords_mat = shift_up.(coords_mat, up_shift_pts)

    # shift the arrow-shapes upwards
    height_increments = get_height_increments(scaled_heights)
    for i in axes(coords_mat, 1)
        for j in axes(coords_mat, 2)
            coords_mat[i,j] = shift_up.(coords_mat[i,j], height_increments[i])
        end
    end

    # shift right the arrow-shapes
    for (ind, right_inc) in enumerate(d_starts)
        coords_mat[:,ind] .= shift_right.((coords_mat[:,ind]), right_inc)
    end

    total_pfm_cols = size.(pfms,2) |> sum
    total_d_cols = num_cols_each |> sum
    return coords_mat, pfm_starts, total_pfm_cols, total_d_cols
end


ds_mats = [12 6; 32 6; 35 14]
weights = [0.5, 0.2, 0.3]

ds_mats = [12 6; 32 6; 35 14; 356 4]
weights = [0.3, 0.2, 0.3, 0.2]

inds_sorted = sortperm(weights)
weights = weights[inds_sorted]
ds_mats = @view ds_mats[inds_sorted, :]

coords_mat, pfm_starts, total_pfm_cols, total_d_cols = 
    make_arrow_shapes(ds_mats, weights, 15, pfms;
    arrow_shape_scale_ratio=0.7, height_top=1.7)

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

p










# plot_shape(coords_mat[1,1]; xlim=(0, 10))
# plot_shape(coords_mat[2,1]; xlim=(0, 10))

# p1 = plot_shape(coords_mat[1,1]; xlim=(0, 100));
# p2 = plot_shape(coords_mat[2,1]; xlim=(0, 100));
# plot(p1)
# plot!(p2)

# # get the number of columns for each column

# scaled_heights

# sh = [1,5,3]


# cumsum(reverse(scaled_heights))



# plot_shape(coords_mat[1,1]; xlim=(0, 100))
# plot_shape(coords_mat[2,1]; xlim=(0, 100))

# #=
# get 

# =#

# scale_height!(coords, 0.5)

# input_pfms = [pfm1, pfm2, pfm3]
# sum_num_columns(input_pfms) = size.(input_pfms, 2) |> sum

# ncols = sum_num_columns(input_pfms)
# given_len = ncols


# p = nothinglogo(2*ncols)