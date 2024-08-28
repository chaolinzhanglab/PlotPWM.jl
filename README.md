# PlotPWM

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://kchu25.github.io/PlotPWM.jl/dev/)
[![Build Status](https://github.com/kchu25/PlotPWM.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/kchu25/PlotPWM.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/kchu25/PlotPWM.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/kchu25/PlotPWM.jl)


# What is this?

PlotPWM is a package for plotting [position weight matrices (PWMs)](https://en.wikipedia.org/wiki/Position_weight_matrix), typically used to characterize motifs, i.e., the binding sites of proteins that interact with DNA or RNA.


## Table of contents

* [Usage](#Usage)  
   - [Plot your typical PWMs](#Plot-your-typical-PWMs)
      - [Save the PWM](#Save-the-PWM)
   - [Plot your PWMs with crosslinking tendencies](#Plot-your-PWMs-with-crosslinking-tendencies)
* [Some-definitions](#Some-definitions)

# Usage

## Plot your typical PWMs
```
using PlotPWM

# Given a position frequency matrix (each column sums to 1)

pfm =  [0.01  1.0  0.98  0.0   0.0   0.0   0.98  0.0   0.18  1.0
        0.98  0.0  0.01  0.19  0.0   0.96  0.01  0.89  0.03  0.0
        0.0   0.0  0.0   0.77  0.01  0.0   0.0   0.0   0.56  0.0
        0.0   0.0  0.0   0.05  0.99  0.04  0.01  0.11  0.24  0.0]

# Define the background probabilities for (A, C, G, T)

background = [0.25, 0.25, 0.25, 0.25]

logoplot(pfm, background)
```
will give

![pfm](demo/demo.png)

The function `logoplot(pfm)` produces a plot where:
- The x-axis shows the positions in the PWM. 
- The y-axis shows the information content (bits) for each position.

Here, `background` is an array representing the background probabilities for A, C, G, and T. These should sum to 1. In this case, a uniform background of `[0.25, 0.25, 0.25, 0.25]` is used, assuming equal probabilities for each base.

You can also simply call 
```
logoplot(pfm)
```
to get identical results as above, where background is set to be `[0.25, 0.25, 0.25, 0.25]` by default.

### Save the PWM
You can call `save_logoplot(pfm, background, save_name)` to save your result. For example:
```
save_logoplot(pfm, background, "tmp/logo.png")
```
Or simply
```
save_logoplot(pfm, "tmp/logo.png")
```
where a uniform background of `[0.25, 0.25, 0.25, 0.25]` is used implicitly.


## Plot your PWMs with crosslinking tendencies

The cross-linked PWMs not only display the PWM but also account for crosslinking tendencies, which is typically done for RNA-binding proteins (RBPs).

To achieve this, you'll need to estimate these tendencies alongside the PFM. For a PFM with $L$ columns, you'll provide a $K \times L$ matrix $C$, where $\sum_{k,\ell}C_{k\ell} \leq 1$.

For example, when $K=1$:
```
C = [0.01  0.04  0.05  0.0  0.74  0.05  0.03  0.05  0.03  0.0] 
```
You can then plot the cross-linked PWM using:

```
logoplotwithcrosslink(pfm, C; rna=true)
```
This will generate:

![pfm](demo/demo2.png)

### Multiplexed crosslinking tendencies

Multiplexed crosslinking tendencies refer to situations where multiple crosslinking signatures are present in the dataset. These different crosslinking signatures can be applied to each sequence before motif discovery tasks. This corresponds to cases where the crosslink matrix $C$ has more than one row, i.e., $K > 1$.

Suppose we have 
```
C2 = [0.01  0.02  0.03  0.0   0.37  0.03  0.02  0.03  0.02  0.0
      0.03  0.0   0.11  0.04  0.26  0.0   0.03  0.01  0.02  0.02]
```
Now, using
```
logoplotwithcrosslink(pfm, C2; rna=true)
```
You'd get 

![pfm](demo/demo3.png)

Here, different colors indicate different crosslinking signatures and their height is proportional to the crosslinking tendency at each position in the PWM.



# Some-definitions

### Definition of Information Content in PWMs
In a position weight matrix (PWM), the "letter height", or more formally, the <b>information content</b> $IC(\cdot)$  of the $i$-th column $c_i$, quantifies how conserved the nucleotides are at that position compared to a background model. It is calculated using the formula:

$$
IC(c_i) = \sum_{\alpha}f_{\alpha i}\log_2 \frac{f_{\alpha i}}{\beta_\alpha}
$$

where 
- $f_{\alpha i}$ the frequency of nucleotide $\alpha\in\Set{A,C,G,T}$ at the $i$-th column of a PWM. 
- $\beta_\alpha$ denotes the genomic background frequency of nucleotide $\alpha$.

### Default genomic background
By default, the background model assumes a uniform distribution of nucleotides, with each nucleotide having a frequency of $\beta=(0.25, 0.25,0.25,0.25)$. In this case, the information content $IC(c_i)$ simplifies to:

$$IC(c_i)=2+\sum_{\alpha}f_{\alpha i}\log_2 f_{\alpha i}$$

This formula illustrates why the y-axis of the plot ranges from  $0$ to $2$.

## Acknowledgement
This code repo modifies the code using the work from https://github.com/BenjaminDoran/LogoPlots.jl.