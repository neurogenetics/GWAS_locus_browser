#code to merge the genes and single cell data into a file that will be used by the app to generate expression plots
import pandas as pd

variants = pd.read_csv("genes_by_locus")

sc = pd.read_csv("expression/Nigra_Mean_Cell_GABA_type.txt", sep="\t")

merge = pd.merge(variants, sc, how = 'left', left_on='Gene',right_on='Gene')

dropna = merge.drop_na()

dropna.to_csv("expression/SingleCellGeneExpression.csv", index=False)
