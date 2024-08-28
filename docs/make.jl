using SeqLogo
using Documenter

DocMeta.setdocmeta!(SeqLogo, :DocTestSetup, :(using SeqLogo); recursive=true)

makedocs(;
    modules=[SeqLogo],
    authors="Shane Kuei-Hsien Chu (skchu@wustl.edu)",
    sitename="SeqLogo.jl",
    format=Documenter.HTML(;
        canonical="https://kchu25.github.io/SeqLogo.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Definitions" => "definitions.md"
    ],
)

deploydocs(;
    repo="github.com/kchu25/SeqLogo.jl",
    devbranch="main",
)
