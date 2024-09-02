module PlotPWM

using Plots

include("const.jl")
include("const_glyphs.jl")
include("helpers.jl")
include("plot_logo.jl")
include("plot_logo_w_crosslinks.jl")
include("plot_nothing.jl")

export LogoPlot, 
       logoplotwithcrosslink, 
       logoplot_with_highlight,
       logoplot_with_highlight_crosslink,
       save_logoplot, 
       save_crosslinked_logoplot,
       NothingLogo





end
