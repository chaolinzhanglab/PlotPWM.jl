using PlotPWM
using Documenter

DocMeta.setdocmeta!(PlotPWM, :DocTestSetup, :(using PlotPWM); recursive=true)

makedocs(;
    modules=[PlotPWM],
    authors="Shane Kuei-Hsien Chu (skchu@wustl.edu)",
    sitename="PlotPWM.jl",
    format=Documenter.HTML(;
        canonical="https://kchu25.github.io/PlotPWM.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/kchu25/PlotPWM.jl",
    devbranch="main",
)
