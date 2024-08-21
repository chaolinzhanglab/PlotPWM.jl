
### Definition of Information Content in Position Weight Matrices (PWM)
In a position weight matrix (PWM), the "letter height", or more formally, the *information content* $IC(\cdot)$  of the $i$-th column $c_i$, quantifies how conserved the nucleotides are at that position compared to a background model. It is calculated using the formula:

$$IC(c_i) = \sum_{\alpha}f_{\alpha i}\log_2 f_{\alpha i} / \beta_\alpha$$

where $f_{\alpha i}$ is the frequency of nucleotide $\alpha\in\Set{A,C,G,T}$ at the $i$-th column of a PWM and $\beta_\alpha$ denotes the genomic background frequency of nucleotide $\alpha$.

### Default genomic background
By default, the background model assumes a uniform distribution of nucleotides, with each nucleotide having a frequency of $\beta=(0.25, 0.25,0.25,0.25)$. In this case, the information content $IC(c_i)$ simplifies to:

$$IC(c_i)=2+\sum_{\alpha}f_{\alpha i}\log_2 f_{\alpha i}$$

This formula illustrates why the y-axis of the plot ranges from  $0$ to $2$.
