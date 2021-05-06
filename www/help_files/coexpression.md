# Co-Expression Data

Gene-based measures of tissue-specific gene expression and co-expression using the GTEx7 V6 gene expression dataset (47 tissues including all brain, accessible from https://www.gtexportal.org/home/). More about the data can be found [here](https://www.biorxiv.org/content/10.1101/288845v1.abstract). The following three columns can be seen:

## Column Definitions:
* `Expression` - The gene is defined as having tissue-specific expression if the gene expression in that tissue was 3.5 fold higher than the average expression of all genes in that tissue.
* `Adjacency` - The gene is specific to the tissue in regards to connectivity with other genes. Defined to be adjacent specific for the tissue if the adjacency is 3.5 fold greater than the average expression of all genes in the tissue.
* `Module Membership` - The module membership (local network measure of connectivity) within the co-expression network is specific within the tissue. Specific if the module membership is 3.5 fold greater than the average module membership.