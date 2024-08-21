# PlotPWM

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://kchu25.github.io/PlotPWM.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://kchu25.github.io/PlotPWM.jl/dev/)
[![Build Status](https://github.com/kchu25/PlotPWM.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/kchu25/PlotPWM.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/kchu25/PlotPWM.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/kchu25/PlotPWM.jl)


# Usage

```
using PlotPWM

# Given a position frequency matrix (each column sum to 1)

pfm =  [0.01  1.0  0.98  0.0   0.0   0.0   0.98  0.0   0.18  1.0
        0.98  0.0  0.01  0.19  0.0   0.96  0.01  0.89  0.03  0.0
        0.0   0.0  0.0   0.77  0.01  0.0   0.0   0.0   0.56  0.0
        0.0   0.0  0.0   0.05  0.99  0.04  0.01  0.11  0.24  0.0]

logoplot(pfm)
```
will give

![pfm](demo/demo.png)

# Note

### Default genomic background
The information content $IC(\cdot)$ (i.e. the "letter height") of the $i$-th column $c_i$ in a position weight matrix (PWM) is 

$$
IC(c_i) = \sum_{\alpha}f_{\alpha i}\log_2 \frac{f_{\alpha i}}{\beta_\alpha}
$$

where $f_{\alpha i}$ the frequency of nucleotide $\alpha\in\Set{A,C,G,T}$ at the $i$-th column of a PWM. The $4$-dimensional vector $\beta$ is the assumed genomic background

By default, the background $\beta$ is assumed to be flat, i.e. $\beta=(0.25, 0.25,0.25,0.25)$.


