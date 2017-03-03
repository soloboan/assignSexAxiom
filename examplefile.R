##### An example file for running the script
### source the funtion 
source('deterSexintensitybased.R')

# run the script to generate the results
Sexassigned <- deterSexintensitybased(Axiomfile='AxiomGT1.summary.txt',outname='example')

# if you want to use you own threshold then run the script as follows
Sexassigned2 <- deterSexintensitybased(Axiomfile='AxiomGT1.summary.txt',intensitythresh=600,
                                       outname='example2')
