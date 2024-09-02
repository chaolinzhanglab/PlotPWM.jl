
@userplot NothingLogo
@recipe function f(data::NothingLogo; 
                   xaxis=false,
                   yaxis=false,
                   thickness_scaling=0.0525,
                   logo_x_offset=0.0,
                   logo_y_offset=0.0,
                   ytickfontsize=265,
                   setup_off=false,
                   margin=275Plots.mm,
                   dpi=65,
                   beta=1.0,
                   crosslink=false
                   )
    if !setup_off
        num_cols = data.args[1]
        ylims --> (crosslink ? -2 : 0, 2)
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
        dpi --> dpi
    end
end
