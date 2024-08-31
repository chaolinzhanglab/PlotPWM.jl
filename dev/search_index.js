var documenterSearchIndex = {"docs":
[{"location":"definitions/#Definition-of-Information-Content-in-Position-Weight-Matrices-(PWM)","page":"Definitions","title":"Definition of Information Content in Position Weight Matrices (PWM)","text":"","category":"section"},{"location":"definitions/","page":"Definitions","title":"Definitions","text":"In a position weight matrix (PWM), the \"letter height\", or more formally, the information content IC(cdot)  of the i-th column c_i, quantifies how conserved the nucleotides are at that position compared to a background model. It is calculated using the formula:","category":"page"},{"location":"definitions/","page":"Definitions","title":"Definitions","text":"IC(c_i) = sum_alphaf_alpha ilog_2 (f_alpha i  beta_alpha)","category":"page"},{"location":"definitions/","page":"Definitions","title":"Definitions","text":"where f_alpha i is the frequency of nucleotide alphainSetACGT at the i-th column of a PWM and beta_alpha denotes the genomic background frequency of nucleotide alpha.","category":"page"},{"location":"definitions/#Default-genomic-background","page":"Definitions","title":"Default genomic background","text":"","category":"section"},{"location":"definitions/","page":"Definitions","title":"Definitions","text":"By default, the background model assumes a uniform distribution of nucleotides, with each nucleotide having a frequency of beta=(025 025025025). In this case, the information content IC(c_i) simplifies to:","category":"page"},{"location":"definitions/","page":"Definitions","title":"Definitions","text":"IC(c_i)=2+sum_alphaf_alpha ilog_2 f_alpha i","category":"page"},{"location":"definitions/","page":"Definitions","title":"Definitions","text":"This formula illustrates why the y-axis of the logo-plot ranges from  0 to 2.","category":"page"},{"location":"","page":"Home","title":"Home","text":"CurrentModule = PlotPWM","category":"page"},{"location":"#PlotPWM","page":"Home","title":"PlotPWM","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for PlotPWM.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [PlotPWM]","category":"page"},{"location":"#PlotPWM.save_crosslinked_logoplot-NTuple{4, Any}","page":"Home","title":"PlotPWM.save_crosslinked_logoplot","text":"save_crosslinked_logoplot(pfm, background, c, save_name; dpi=65, rna=true)\nSave a logoplot with crosslinks to a file\n\n\n\n\n\n","category":"method"},{"location":"#PlotPWM.save_logoplot-Tuple{Any, Any, String}","page":"Home","title":"PlotPWM.save_logoplot","text":"save_logoplot(pfm, background, save_name; dpi=65)\n\nArguments\n\npfm::Matrix{Real}: Position frequency matrix\nbackground::Vector{Real}: Background probabilities of A, C, G, T\nsave_name::String: Name of the path/file to save the plot\n\nNote that\n\npfm must be a probability matrix\nsum of each column must be 1\nbackground must be a vector of length 4\nmust be a vector of probabilities\nsum of background must be 1\n\nExample\n\n\npfm =  [0.02  1.0  0.98  0.0   0.0   0.0   0.98  0.0   0.18  1.0\n        0.98  0.0  0.02  0.19  0.0   0.96  0.01  0.89  0.03  0.0\n        0.0   0.0  0.0   0.77  0.01  0.0   0.0   0.0   0.56  0.0\n        0.0   0.0  0.0   0.04  0.99  0.04  0.01  0.11  0.23  0.0]\n\nbackground = [0.25, 0.25, 0.25, 0.25]\n\n#= save the logo plot in the tmp folder as logo.png =#\nsave_logoplot(pfm, background, \"tmp/logo.png\")\n\n#= save the logo plot in the current folder as logo.png with a dpi of 65 =#\nsave_logoplot(pfm, background, \"logo.png\"; dpi=65)\n\n\n\n\n\n\n","category":"method"},{"location":"#PlotPWM.save_logoplot-Tuple{Any, String}","page":"Home","title":"PlotPWM.save_logoplot","text":"save_logoplot(pfm, save_name; dpi=65)\n\nThis is the same as `save_logoplot(pfm, background, save_name; dpi=65)`\nwhere `background` is set to `[0.25, 0.25, 0.25, 0.25]`\n\nSee `save_logoplot(pfm, background, save_name; dpi=65)` for more details.\n\n\n\n\n\n","category":"method"}]
}
