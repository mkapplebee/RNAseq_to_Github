# RNAseq_to_Github

This is a repository of RNAseq analysis files written in R markdown and then exported to html format.
The data processed in these files is not in this repository, but the R markdown files can be examined to show the underlying R code, and the html files can be downloaded to examine the graphs, tables, and other output generated with the R markdown files are run with access to the data.

The data for these files are RNAseq results of seven Bacillus subtilis strains.  Six of the strains carry either one or two gene deletions relative to the reference strain, AM373.  Three of the strains have a single gene deleted, either liaS, mcpA, or nhaK, and the strains are referred to by the name of the deleted gene.  The other three strains carry pairs of the three same genes, and are referred to by the first letters of the two deleted genes -  ie, in the "LM" strain, the liaS and mcpA genes are deleted.

The RNAseq data was generated from these 7 strains during growth in Difco's sporulation medium (DSM), during late-exponential phase. Previous experiments had shown that the delta-liaS strain had a significant growth defect in this medium, while the double-mutants LM and LN did not.  This represented a potential epistatic interaction, which RNAseq was used to interogate.

The numbered files each contain a section of RNAseq analysis, beginning with initial QC analysis (post-mapping, which was done using Rockhopper2 - http://cs.wellesley.edu/~btjaden/Rockhopper/), examination of batch effects and the influence of antibiotic markers, and finally examination of differential expression between the strains or groups of strains.

Other files contain images or functions used within the R markdown reports.
