@userplot NothingLogo
@recipe function f(data::NothingLogo; 
                   xaxis=false,
                   yaxis=false,
                   logo_x_offset=0.0,
                   logo_y_offset=0.0,
                   setup_off=false,
                   beta=1.0,
                   dpi=65,
                   crosslink=false,
                   xaxis_on=true
                   )

    logo_size_height = crosslink ? logo_height + 115 : logo_height;
    xaxis    = xaxis_on;
    xaxis    = crosslink ? false : true;
    yaxis    = crosslink ? false : true;
    _margin_ = crosslink ? 25Plots.mm : margin;
    if !setup_off
        xaxis --> xaxis
        yaxis --> yaxis
        num_cols = data.args[1]
        ylims --> (crosslink ? -crosslink_stretch_factor2 : 0, ylim_max)
        xlims --> (xlim_min, num_cols+1)
        logo_size = (_width_factor_(num_cols)*num_cols, logo_size_height) .* 2.5
        ticks --> :native
        yticks --> yticks  # Ensure ticks are generated
        ytickfontcolor --> :gray
        ytick_direction --> :out
        ytickfontsize --> ytickfontsize
        yminorticks --> yminorticks
        ytickfont --> font(logo_font_size, logo_font)
        xtickfontcolor --> :gray
        xticks --> 1:1:num_cols
        xtickfontsize --> xtickfontsize
        xaxis && (xaxis --> xaxis)
        yaxis && (yaxis --> yaxis)
        legend --> false
        tickdir --> :out
        grid --> false
        margin --> _margin_
        thickness_scaling --> thickness_scaling
        size --> logo_size
        # framestyle --> :none
        dpi --> dpi
    end
    xticks --> 1:1:data.args[1]
end