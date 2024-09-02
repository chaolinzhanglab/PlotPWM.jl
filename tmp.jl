using PlotPWM

pfm =  [0.02  1.0  0.98  0.0   0.0   0.0   0.98  0.0   0.18  1.0
        0.98  0.0  0.02  0.19  0.0   0.96  0.01  0.89  0.03  0.0
        0.0   0.0  0.0   0.77  0.01  0.0   0.0   0.0   0.56  0.0
        0.0   0.0  0.0   0.04  0.99  0.04  0.01  0.11  0.23  0.0]

C = [0.01  0.04  0.05  0.0  0.74  0.05  0.03  0.05  0.03  0.0] 

background = [0.25, 0.25, 0.25, 0.25]

highlighted_regions=[1:5]

logoplot_with_highlight_crosslink(pfm, background, C, highlighted_regions)
logoplot_with_highlight_crosslink(pfm, C, highlighted_regions)

logoplot_with_highlight_crosslink(pfm, background, C, highlighted_regions1)
highlighted_regions1
highlighted_regions2


# logoplotwithcrosslink(pfm, background, C; rna=true)

# highlighted_regions=[1:5]

# save_crosslinked_logoplot(pfm, background, C, "tmp.png"; 
#     rna=true, highlighted_regions=highlighted_regions)


# logoplot(pfm)

# logoplot(zeros((4,20)))
# logoplot!(pfm, logo_x_offset=2, setup_off=true)

# nothinglogo(20)
# logoplot!(pfm, logo_x_offset=2, setup_off=true, alpha=0.5)



# pfm |> size


# q = [1:3, 5:9, 15:20]
# complement_ranges(q, 25)

# qq = setdiff(collect(1:13), reduce(union, (collect.(q))))
# qq = [4,7, 10,11,12]
# group_to_ranges(qq)


# function logoplot_with_highlight(
#         pfm::AbstractMatrix, 
#         background::AbstractMatrix, 
#         highlighted_regions::Vector{UnitRange{Int}}
#     )
#     num_columns = size(pfm, 2)
#     range_complement = complement_ranges(highlighted_regions, num_columns)
#     p = nothinglogo(num_columns);
#     for r in range_complement
#         logo_x_offset = r.start-1
#         logoplot!(p, 
#                   (@view pfm[:, r]), background; 
#                   alpha=0.35, 
#                   setup_off=true, 
#                   logo_x_offset=logo_x_offset)
#     end
#     for r in highlighted_regions
#         logo_x_offset = r.start-1
#         logoplot!(p, (@view pfm[:, r]), background; 
#                      setup_off=true, 
#                      logo_x_offset=logo_x_offset)
#     end
#     return p
# end

# function logoplot_with_highlight(
#         pfm::AbstractMatrix, 
#         highlighted_regions::Vector{UnitRange{Int}})
#     return logoplot_with_highlight(pfm, 
#                                    default_genomic_background, 
#                                    highlighted_regions)
# end



# highlighted_regions=[1:5]


#     return max(x1,y1) <= min(x2,y2)

# r = 1:3

# reduce(is_overlapping, highlighted_regions)


# !reduce(is_overlapping, [1:5, 3:8])
# reduce(is_overlapping, [1:5])


# p = logoplot_with_highlight(pfm, [0.25 for _ = 1:4], [1:5])
# p = logoplot_with_highlight(pfm, highlighted_regions)
# p